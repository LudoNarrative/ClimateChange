/* global test */
"use strict";
define(["../StoryAssembler", "../ChunkLibrary", "../State", "../Wishlist", "../Display"], function(StoryAssembler, ChunkLibrary, State, Wishlist, Display) {

	var getStoryEl = function() {
		return document.getElementById("storyArea").children[0];
	}
	var getChoiceEl = function() {
		return document.getElementById("choiceArea");
	}
	var html = function(el) {
		return el.innerHTML;
	}
	var countChildren = function(el) {
		return el.children.length;
	}
	var child = function(num, el) {
		return el.children[num-1];
	}
	var clickEl = function(el) {
		el.click();
	}
	var clickChoice = function(num) {
		clickEl(child(num, getChoiceEl()));
	}
	var contentForChoice = function(num) {
		return html(child(num, getChoiceEl()));
	}
	var cleanUpDom = function() {
		var el = document.getElementById("storyArea");
		el.parentNode.removeChild(el);
		el = document.getElementById("choiceArea");
		el.parentNode.removeChild(el);
		el = document.getElementById("diagnostics");
		el.parentNode.removeChild(el);
	}
	
	var run = function() {

		test("Integration tests for StoryAssembler", function( assert ) {
			var wl;

			ChunkLibrary.reset();
			State.reset();
			wl = Wishlist.create([{condition: "x eq true"}], State);
			ChunkLibrary.add([
				{ id: "Chunk1", content: "Chunk1 Content", choices: [{chunkId: "Chunk2"}] },
				{ id: "Chunk2", choiceLabel: "Chunk2 Label", content: "Chunk2 Content", effects: ["set x true"] }
			]);
			StoryAssembler.beginScene(wl, ChunkLibrary, State, Display);
			assert.deepEqual(html(getStoryEl()), "Chunk1 Content", "Basic: First chunk should be shown correctly");
			assert.deepEqual(contentForChoice(1), "Chunk2 Label", "Basic: First choice should be shown correctly");
			clickChoice(1);
			assert.deepEqual(html(getStoryEl()), "Chunk2 Content", "Basic: Second chunk should be shown correctly");
			assert.deepEqual(countChildren(getChoiceEl()), 0, "Should be no choices if we've run out of chunks.");

			ChunkLibrary.reset();
			State.reset();
			wl = Wishlist.create([{condition: "x eq true"}], State);
			ChunkLibrary.add([
				{ id: "Chunk1", content: "Chunk1 Content", choices: [{chunkId: "Chunk2"}] },
				{ id: "Chunk2", choiceLabel: "Chunk2 Label", content: "Chunk2 Content", choices: [{chunkId: "Chunk3"}] },
				{ id: "Chunk3", choiceLabel: "Chunk3 Label", content: "Chunk3 Content", effects: ["set x true"] }
			]);
			StoryAssembler.beginScene(wl, ChunkLibrary, State, Display);
			assert.deepEqual(html(getStoryEl()), "Chunk1 Content", "In multi-choice chain, first chunk should be shown correctly");
			assert.deepEqual(contentForChoice(1), "Chunk2 Label", "In multi-choice chain, first option correct.");
			clickChoice(1);
			assert.deepEqual(html(getStoryEl()), "Chunk2 Content", "In multi-choice chain, second chunk shows correctly.");
			assert.deepEqual(contentForChoice(1), "Chunk3 Label", "In multi-choice chain, second option correct.");
			assert.deepEqual(countChildren(getChoiceEl()), 1, "In multi-choice chain, should be exactly 1 option.");
			clickChoice(1);
			assert.deepEqual(html(getStoryEl()), "Chunk3 Content", "In multi-choice chain, last chunk should show correctly.");
			assert.deepEqual(countChildren(getChoiceEl()), 0, "In multi-choice chain, no options when finished.");

			// Test chaining through condition-based request (condition is different than initial wishlist goals)
			ChunkLibrary.reset();
			State.reset();
			State.set("beat", 1);
			wl = Wishlist.create([{condition: "beat eq 3"}, {condition: "beat eq 2"}], State);
			ChunkLibrary.add([
				{ id: "Chunk1", content: "Chunk1 Content", choices: [{chunkId: "Chunk2x"}], effects: ["set beat 2"] },
				{ id: "Chunk2x", choiceLabel: "Chunk2 Label", request: {condition: "x eq true"} },
				{ id: "Chunk3x", conditions: ["beat eq 2"], content: "Chunk3 Content", effects: ["set beat 3", "set x true"] }
			]);
			StoryAssembler.beginScene(wl, ChunkLibrary, State, Display);
			assert.deepEqual(html(getStoryEl()), "Chunk1 Content", "Chain through condition request: first node HTML correct");
			assert.deepEqual(countChildren(getChoiceEl()), 1, "Chain through condition request: initially only 1 choice");
			assert.deepEqual(contentForChoice(1), "Chunk2 Label", "Chain through condition request: single choice is to Chunk2");
			console.log("clicking choice in Chunk1");
			clickChoice(1);
			assert.deepEqual(html(getStoryEl()), "Chunk3 Content", "Chain through condition request: after click, should chain through.");
			assert.deepEqual(countChildren(getChoiceEl()), 0, "Chain through condition request: no options when finished.");

			// Test "persistent" wishlist parameter and "repeatable" chunk parameter.
			State.reset();
			wl = Wishlist.create([{condition: "x eq true", persistent: true}], State);
			ChunkLibrary.add([
				{ id: "Chunk1", content: "Chunk1 Content", effects: ["set x true"], repeatable: true }
			]);
			StoryAssembler.beginScene(wl, ChunkLibrary, State, Display);
			assert.deepEqual(html(getStoryEl()), "Chunk1 Content", "Persistent chunks work first time (1/3)");
			assert.deepEqual(countChildren(getChoiceEl()), 1, "Persistent chunks work first time (2/3)");
			assert.deepEqual(contentForChoice(1), "Continue", "Persistent chunks work first time (3/3)");
			clickChoice(1);
			assert.deepEqual(html(getStoryEl()), "Chunk1 Content", "Persistent chunks work second time (1/2)");
			assert.deepEqual(contentForChoice(1), "Continue", "Persistent chunks work second time (2/2)");

			ChunkLibrary.reset();
			State.reset();
			wl = Wishlist.create([{condition: "x eq true", persistent: true}], State);
			ChunkLibrary.add([
				{ id: "Chunk1", content: "Chunk1 Content", effects: ["set x true"], repeatable: false }
			]);
			StoryAssembler.beginScene(wl, ChunkLibrary, State, Display);
			assert.deepEqual(html(getStoryEl()), "Chunk1 Content", "Non-repeatable chunks work first time (1/2)");
			assert.deepEqual(contentForChoice(1), "Continue", "Non-repeatable chunks work first time (2/2)");
			clickChoice(1);
			assert.deepEqual(html(getStoryEl()), "[No path found!]", "Non-repeatable chunks: if a used non-repeatable chunk is the only thing satisfying a wishlist item, fail to find a path");

			ChunkLibrary.reset();
			State.reset();
			wl = Wishlist.create([{condition: "x eq true", persistent: true}], State);
			ChunkLibrary.add([
				{ id: "Chunk1", content: "...", effects: ["set x true"], repeatable: false },
				{ id: "Chunk2", content: "...", effects: ["set x true"], repeatable: false },
				{ id: "Chunk3", content: "...", effects: ["set x true"], repeatable: false }
			]);
			StoryAssembler.beginScene(wl, ChunkLibrary, State, Display);
			clickChoice(1);
			clickChoice(1);
			clickChoice(1);
			assert.deepEqual(html(getStoryEl()), "[No path found!]", "Non-repeatable chunks: should run out when we've exhausted supply.");


			//test whether it can find the next want from wishlist if current choice-thread ends
			ChunkLibrary.reset();
			State.reset();
			State.set("beat", 1);
			wl = Wishlist.create([{condition: "beat eq 2"}, {condition: "beat eq 3"}], State);
			ChunkLibrary.add([
				{ id: "Chunk1", content: "Chunk1 Content", choices: [{chunkId: "Chunk2b"}], effects: ["set beat 2"] },
				{ id: "Chunk2b", choiceLabel: "Chunk2 Label", content: "Chunk2 content" },
				{ id: "Chunk3", conditions: ["beat eq 2"], content: "Chunk3 Content", effects: ["set beat 3"] }
			]);
			StoryAssembler.beginScene(wl, ChunkLibrary, State, Display);
			assert.deepEqual(html(getStoryEl()), "Chunk1 Content", "Move to different want after thread ends: first node HTML correct");
			assert.deepEqual(countChildren(getChoiceEl()), 1, "Move to different want after thread ends: initially only 1 choice");
			assert.deepEqual(contentForChoice(1), "Chunk2 Label", "Move to different want after thread ends: single choice is to Chunk2");
			clickChoice(1);
			assert.deepEqual(html(getStoryEl()), "Chunk2 content", "Move to different want after thread ends: after click, should chain through.");
			assert.deepEqual(contentForChoice(1), "Continue", "Move to different want after thread ends: single choice is to Chunk2");
			clickChoice(1);
			assert.deepEqual(html(getStoryEl()), "Chunk3 Content", "Move to different want after thread ends: second node HTML correct");

			//write unit test for pulling in chunk with choices into chunk making request that has no content
			ChunkLibrary.reset();
			State.reset();
			State.set("beat", 1);
			wl = Wishlist.create([{condition: "beat eq 3"}, {condition: "beat eq 2"}], State);
			ChunkLibrary.add([
				{ id: "Chunk1", content: "Chunk1 Content", choices: [{chunkId: "Chunk2"}], effects: ["set beat 2"] },
				{ id: "Chunk2", choiceLabel: "Chunk2 Label", request: {condition: "x eq true"} },
				{ id: "Chunk3", conditions: ["beat eq 2"], content: "Chunk3 Content", choices: [{chunkId: "Chunk4"}], effects: ["set beat 3", "set x true"] },
				{ id: "Chunk4", choiceLabel: "Chunk4 Label", content: "Chunk4 Content" },
			]);
			StoryAssembler.beginScene(wl, ChunkLibrary, State, Display);
			assert.deepEqual(html(getStoryEl()), "Chunk1 Content", "Choices also chain from requests: first node HTML correct");
			assert.deepEqual(countChildren(getChoiceEl()), 1, "Choices also chain from requests: initially only 1 choice");
			assert.deepEqual(contentForChoice(1), "Chunk2 Label", "Choices also chain from requests: single choice is to Chunk2");
			clickChoice(1);
			assert.deepEqual(html(getStoryEl()), "Chunk3 Content", "Choices also chain from requests: after click, should chain through.");
			assert.deepEqual(contentForChoice(1), "Chunk4 Label", "Choices also chain from requests: single choice is to Chunk4");
			assert.deepEqual(countChildren(getChoiceEl()), 1, "Choices also chain from requests: second screen only 1 choice");
			clickChoice(1);
			assert.deepEqual(html(getStoryEl()), "Chunk4 Content", "Choices also chain from requests: after click, should chain through again.");
			assert.deepEqual(countChildren(getChoiceEl()), 0, "Choices also chain from requests: no options when finished.");
			console.log(wl.wantsAsArray());

			// Test incremental progress towards wishlist items.
			ChunkLibrary.reset();
			State.reset();
			State.set("stress", 0);
			wl = Wishlist.create([{condition: "stress gte 3"}], State);
			ChunkLibrary.add([
				{ id: "StressChunk", content: "StressChunk Content", effects: ["incr stress 1"], repeatable: true }
			]);
			StoryAssembler.beginScene(wl, ChunkLibrary, State, Display);
			assert.deepEqual(html(getStoryEl()), "StressChunk Content", "Testing incremental progress (1)");
			assert.deepEqual(contentForChoice(1), "Continue", "Testing incremental progress (2)");
			clickChoice(1);
			assert.deepEqual(html(getStoryEl()), "StressChunk Content", "Testing incremental progress (3)");
			clickChoice(1);
			assert.deepEqual(countChildren(getChoiceEl()), 0, "Testing incremental progress (4)");


			cleanUpDom();


		});
	}

	return {
		run: run
	}
});