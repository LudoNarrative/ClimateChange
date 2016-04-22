/* global test, QUnit */
"use strict";
define(["../Wishlist", "../ChunkLibrary", "../Request", "../State"], function(Wishlist, ChunkLibrary, Request, State) {
	
	var run = function() {
		QUnit.module( "BestPath Module tests" );
		test("bestPath", function( assert ) {
			var wl, nextPath;

			wl = Wishlist.create([{chunkId: "TestNode"}], State);
			ChunkLibrary.reset();

			// Test one-step path based on ID.
			ChunkLibrary.add([
				{ id: "TestNode", content: "Hello, world!" },
			]);
			nextPath = wl.bestPath(ChunkLibrary);
			assert.deepEqual(nextPath.route, ["TestNode"], "simple id request should have right path");
			// We expect "nextPath.satisfies" to be an array of Wants satisfied by this path. Normally we could not guarantee these would be in any special order, but in this case since we know there's only one, we can grab it and check its two fields, "type" and "val".
			assert.deepEqual(nextPath.satisfies[0].type, "id", "simple id request should satisfy the right want (type)");
			assert.deepEqual(nextPath.satisfies[0].val, "TestNode", "simple id request should satisfy the right want (val)");

			// Test that ID paths ends when it satisfies Wants.
			ChunkLibrary.reset();
			ChunkLibrary.add([
				{ id: "TestNodeX", content: "..." },
				{ id: "TestNode", request: {chunkId: "TestNode2"} },
				{ id: "TestNodeZ", content: "..." },
				{ id: "TestNode2", content: "Hola, mundo!" }
			]);
			nextPath = wl.bestPath(ChunkLibrary);
			assert.deepEqual(nextPath.route, ["TestNode"], "don't need to go to leaf nodes that don't satisfy any wants");
			assert.deepEqual(nextPath.satisfies.length, 1, "two-step path should only show wants satisfied");
			assert.deepEqual(nextPath.satisfies[0].val, "TestNode", "two-step path should have correct want satisfied");

			// Test one-step path based on a request.
			ChunkLibrary.reset();
			State.set("x", false);
			wl = Wishlist.create([{condition: "x eq true"}], State);
			ChunkLibrary.add([
				{ id: "alpha", effects: ["set x true"] }
			]);
			nextPath = wl.bestPath(ChunkLibrary);
			assert.deepEqual(nextPath.route, ["alpha"], "request-based path");
			assert.deepEqual(nextPath.satisfies.length, 1, "request path should only show wants satisfied");
			assert.deepEqual(nextPath.satisfies[0].val, "x eq true", "request-based path should have correct want satisfied");

			// Test that request paths stop when Want is satisfied.
			ChunkLibrary.reset();
			State.reset();
			State.set("x", true);
			wl = Wishlist.create([{condition: "x eq false"}], State);
			ChunkLibrary.add([
				{ id: "Node1", effects: ["set x false"], request: {chunkId: "Node2"} },
				{ id: "Node2", effects: ["set z true"], request: {chunkId: "Node3"} },
				{ id: "Node3", content: "..." }
			]);
			nextPath = wl.bestPath(ChunkLibrary);
			assert.deepEqual(nextPath.route, ["Node1"], "request-based path doesn't need to go to leaf nodes that don't satisfy useful wants");
			assert.deepEqual(nextPath.satisfies.length, 1, "request path should only show original wants satisfied");

			// Test that conditions restrict valid paths.
			ChunkLibrary.reset();
			State.reset();
			State.set("jokesTold", 3);
			State.set("location", 10);

			wl = Wishlist.create([{condition: "jokesTold gte 4"}], State);
			ChunkLibrary.add([
				{ id: "Node1", effects: ["decr jokesTold 1"], content: "..." },
				{ id: "Node2", effects: ["incr jokesTold 1"], conditions: ["location eq 10"], content: "..." },
				{ id: "Node3", effects: ["incr jokesTold 1"], conditions: ["location eq 5"], content: "..." } 
			]);
			nextPath = wl.bestPath(ChunkLibrary);
			assert.deepEqual(nextPath.route, ["Node2"], "conditions should restrict valid paths");

			// Test choice structure.
			ChunkLibrary.reset();

			wl = Wishlist.create([{condition: "x eq 1"}], State);
			ChunkLibrary.add([
				{ id: "Choice1", effects: ["set x 1"], choiceLabel: "..." },
				{ id: "Choice2", effects: ["set x 1"] } 
			]);
			nextPath = wl.bestPath(ChunkLibrary);
			assert.deepEqual(nextPath.route, ["Choice2"], "can't choose a chunk with a choiceLabel unless through a choice");

			ChunkLibrary.reset();
			State.reset();
			wl = Wishlist.create([{condition: "x eq 1"}], State);
			ChunkLibrary.add([
				{ id: "alpha", content: "What do you choose?", choices: [{chunkId: "Choice1"}, {condition: "z eq 5"}] },
				{ id: "Choice1", choiceLabel: "Choice 1", content: "Result of Choice 1." },
				{ id: "Choice2", choiceLabel: "Choice 2", content: "Result of Choice 2.", effects: ["set z 5", "set x 1"] },
			]);
			nextPath = wl.bestPath(ChunkLibrary);
			assert.deepEqual(nextPath.route, ["alpha", "Choice2"], "can iterate down through choices");
			assert.deepEqual(nextPath.satisfies.length, 1, "'satisfies' should only show original Wants");

			ChunkLibrary.reset();
			State.reset();
			wl = Wishlist.create([{condition: "x eq 1"}], State);
			State.set("node2Banned", true);
			ChunkLibrary.add([
				{ id: "Node1", request: {chunkId: "Node2"} },
				{ id: "Node2", request: {chunkId: "Node1"}, conditions: ["node2Banned eq false"], effects: ["set x 1"] },
			]);
			nextPath = wl.bestPath(ChunkLibrary);
			assert.notOk(nextPath, "can't find a path ending in a node with an invalid condition.");

			// Test multiple wants. 
			ChunkLibrary.reset();
			State.reset();
			wl = Wishlist.create([{condition: "x eq true"}, {condition: "y eq true"}], State);
			ChunkLibrary.add([
				{ id: "Node1", content: "...", effects: ["set x true", "set q true"] },
				{ id: "Node2", content: "...", effects: ["set y true", "set w true", "set r true"] },
				{ id: "Node3", content: "...", effects: ["set x true", "set y true"] },

			]);
			nextPath = wl.bestPath(ChunkLibrary);
			assert.deepEqual(nextPath.route, ["Node3"], "should pick a path that satisfies as many Wants as possible.");

			wl = Wishlist.create([{condition: "x eq true"}, {condition: "y eq true"}, {condition: "foo eq true"}], State);
			nextPath = wl.bestPath(ChunkLibrary);
			assert.deepEqual(nextPath.route, ["Node3"], "should pick a maximally Want-satisfying path, even if not all wants can be satisfied.");

			ChunkLibrary.reset();
			State.reset();
			wl = Wishlist.create([{condition: "x eq true"}, {condition: "y eq true"}], State);
			ChunkLibrary.add([
				{ id: "DirectNode", content: "...", effects: ["set x true"] },
				{ id: "ChoiceNode", content: "...", effects: ["set x true"], choices: [{chunkId: "Result1"}, {chunkId: "Result2"}] },
				{ id: "Result1", choiceLabel: "...", content: "...", effects: ["set q true"] },
				{ id: "Result2", choiceLabel: "...", content: "...", effects: ["set y true"] }
			]);
			nextPath = wl.bestPath(ChunkLibrary);
			assert.deepEqual(nextPath.route, ["ChoiceNode", "Result2"], "should maximize Wants through choice structures.");

			// TODO: A cycle should consider the last node before cycling as a leaf node. (I.e. we want this to be valid, but we don't want to recurse forever down it looking for leaf nodes.


			// TODO: Write test (and determine correct behavior) for case where something requires something where the condition is not true. [what if this is in a choice?]


		});

		test("allPaths", function( assert ) {
			var allPaths, wl;

			ChunkLibrary.reset();
			State.reset();
			wl = Wishlist.create([{condition: "x eq true"}], State);
			ChunkLibrary.add([
				{ id: "Node1", effects: ["set x true"] },
				{ id: "Node2", effects: ["set x true"] },
				{ id: "Node3", effects: ["set x true"] },
			]);
			allPaths = wl.allPaths(ChunkLibrary);
			assert.deepEqual(allPaths.length, 3, "allPaths should return right number of paths");
			assert.deepEqual(allPaths[0].satisfies.length, 1, "allPaths should have satisfies of right length");
			assert.deepEqual(allPaths[0].satisfies[0].val, "x eq true", "allPaths should return paths with right 'satisfies'");

			ChunkLibrary.reset();
			State.reset();
			wl = Wishlist.create([{condition: "x eq true"}], State);
			ChunkLibrary.add([
				{ id: "Node1", content: "...", choices: [{chunkId: "Node2"}, {chunkId: "Node3"}], effects: ["set x true"] },
				{ id: "Node2", content: "...", choiceLabel: "...", effects: ["set x true"] },
				{ id: "Node3", content: "...", choiceLabel: "..." }
			]);
			allPaths = wl.allPaths(ChunkLibrary);
			assert.deepEqual(allPaths.length, 1, "setting up test");
			assert.deepEqual(allPaths[0].satisfies.length, 1, "duplicate effects shouldn't change 'satisfies' size");

		});

	}

	return {
		run: run
	}
});