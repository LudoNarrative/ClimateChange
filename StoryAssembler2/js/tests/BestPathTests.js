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
			assert.deepEqual(nextPath.satisfies[0].type, "id", "simple id request should satisfy the right wany");
			assert.deepEqual(nextPath.satisfies[0].val, "TestNode", "simple id request should satisfy the right want");

			// Test that ID paths ends when it satisfies Wants.
			ChunkLibrary.reset();
			ChunkLibrary.add([
				{ id: "TestNodeX", content: "..." },
				{ id: "TestNode", request: Request.byId("TestNode2") },
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
			wl = Wishlist.create([{request: "x eq true"}], State);
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
			wl = Wishlist.create([{request: "x eq false"}], State);
			ChunkLibrary.add([
				{ id: "Node1", effects: ["set x false"], request: Request.byId("Node2") },
				{ id: "Node2", effects: ["set z true"], request: Request.byId("Node3") },
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

			wl = Wishlist.create([{request: "jokesTold gte 4"}], State);
			ChunkLibrary.add([
				{ id: "Node1", effects: ["decr jokesTold 1"], content: "..." },
				{ id: "Node2", effects: ["incr jokesTold 1"], conditions: ["location eq 10"], content: "..." },
				{ id: "Node3", effects: ["incr jokesTold 1"], conditions: ["location eq 5"], content: "..." } 
			]);
			nextPath = wl.bestPath(ChunkLibrary);
			assert.deepEqual(nextPath.route, ["Node2"], "conditions should restrict valid paths");

			// Test choice structure.
			ChunkLibrary.reset();
			console.log("test choice structure");

			wl = Wishlist.create([{request: "x eq 1"}], State);
			ChunkLibrary.add([
				{ id: "Choice1", effects: ["set x 1"], choiceLabel: "..." },
				{ id: "Choice2", effects: ["set x 1"] } 
			]);
			nextPath = wl.bestPath(ChunkLibrary);
			assert.deepEqual(nextPath.route, ["Choice2"], "can't choose a chunk with a choiceLabel unless through a choice");

			ChunkLibrary.reset();
			wl = Wishlist.create([{request: "x eq 1"}], State);
			ChunkLibrary.add([
				{ id: "alpha", content: "What do you choose?", choices: [Request.byId("Choice1"), Request.byId("Choice2")] },
				{ id: "Choice1", choiceLabel: "Choice 1", content: "Result of Choice 1." },
				{ id: "Choice2", choiceLabel: "Choice 2", content: "Result of Choice 2.", effects: ["set x 1"] } 
			]);
			nextPath = wl.bestPath(ChunkLibrary);
			assert.deepEqual(nextPath.route, ["alpha", "Choice2"], "can iterate down through choices");

			ChunkLibrary.reset();
			wl = Wishlist.create([{request: "x eq 1"}], State);
			ChunkLibrary.add([
				{ id: "alpha", content: "What do you choose?", choices: [Request.byId("Choice1"), Request.byId("z eq completed")] },
				{ id: "Choice1", choiceLabel: "Choice 1", content: "Result of Choice 1." },
				{ id: "Choice2", choiceLabel: "Choice 2", content: "Result of Choice 2.", effects: ["set z completed"], request: Request.byId("Node2") },
				{ id: "Node2", content: "...", effects: ["set x 1"] },

			]);
			nextPath = wl.bestPath(ChunkLibrary);
			assert.deepEqual(nextPath.route, ["alpha", "Choice2", "Node2"], "can iterate down through choices & requests");

			// ChunkLibrary.reset();
			// wl = Wishlist.create([{request: "x eq 1"}], State);
			// State.set("node2Banned", true);
			// ChunkLibrary.add([
			// 	{ id: "Node1", request: Request.byId("Node2") },
			// 	{ id: "Node2", request: Request.byId("Node1"), conditions: ["node2Banned eq false"], effects: ["set x 1"] },
			// ]);
			// nextPath = wl.bestPath(ChunkLibrary);
			// assert.deepEqual(nextPath, undefined, "can't find a path ending in a node with an invalid condition.");

			// TODO: A cycle should consider the last node before cycling as a leaf node. (I.e. we want this to be valid, but we don't want to recurse forever down it looking for leaf nodes.


			// TODO: Write test (and determine correct behavior) for case where something requires something where the condition is not true. [what if this is in a choice?]


		});

	}

	return {
		run: run
	}
});