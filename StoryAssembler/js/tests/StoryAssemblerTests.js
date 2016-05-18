/* global test */
"use strict";
define(["../StoryAssembler", "../ChunkLibrary", "../State", "../Wishlist"], function(StoryAssembler, ChunkLibrary, State, Wishlist) {

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
			StoryAssembler.beginScene(wl, ChunkLibrary, State);
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
			StoryAssembler.beginScene(wl, ChunkLibrary, State);
			assert.deepEqual(html(getStoryEl()), "Chunk1 Content", "In multi-choice chain, first chunk should be shown correctly");
			assert.deepEqual(contentForChoice(1), "Chunk2 Label", "In multi-choice chain, first option correct.");
			clickChoice(1);
			assert.deepEqual(html(getStoryEl()), "Chunk2 Content", "In multi-choice chain, second chunk shows correctly.");
			assert.deepEqual(contentForChoice(1), "Chunk3 Label", "In multi-choice chain, second option correct.");
			assert.deepEqual(countChildren(getChoiceEl()), 1, "In multi-choice chain, should be exactly 1 option.");
			clickChoice(1);
			assert.deepEqual(html(getStoryEl()), "Chunk3 Content", "In multi-choice chain, last chunk should show correctly.");
			assert.deepEqual(countChildren(getChoiceEl()), 0, "In multi-choice chain, no options when finished.");


			ChunkLibrary.reset();
			State.reset();
			State.set("beat", 1);
			wl = Wishlist.create([{condition: "beat eq 3"}, {condition: "beat eq 2"}], State);
			ChunkLibrary.add([
				{ id: "Chunk1", content: "Chunk1 Content", choices: [{chunkId: "Chunk2"}], effects: ["set beat 2"] },
				{ id: "Chunk2", choiceLabel: "Chunk2 Label", request: {condition: "x eq true"} },
				{ id: "Chunk3", conditions: ["beat eq 2"], content: "Chunk3 Content", effects: ["set beat 3", "set x true"] }
			]);
			StoryAssembler.beginScene(wl, ChunkLibrary, State);
			assert.deepEqual(html(getStoryEl()), "Chunk1 Content", "Chain through condition request: first node HTML correct");
			assert.deepEqual(countChildren(getChoiceEl()), 1, "Chain through condition request: initially only 1 choice");
			assert.deepEqual(contentForChoice(1), "Chunk2 Label", "Chain through condition request: single choice is to Chunk2");
			console.log("!!!!!");
			wl.logOn();
			clickChoice(1);
			wl.logOff();
			assert.deepEqual(html(getStoryEl()), "Chunk3 Content", "Chain through condition request: after click, should chain through.");
			assert.deepEqual(countChildren(getChoiceEl()), 0, "Chain through condition request: no options when finished.");

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
			StoryAssembler.beginScene(wl, ChunkLibrary, State);
			assert.deepEqual(html(getStoryEl()), "Chunk1 Content", "Move to different want after thread ends: first node HTML correct");
			assert.deepEqual(countChildren(getChoiceEl()), 1, "Move to different want after thread ends: initially only 1 choice");
			assert.deepEqual(contentForChoice(1), "Chunk2 Label", "Move to different want after thread ends: single choice is to Chunk2");
			console.log("?!?!");
			wl.logOn();
			clickChoice(1);
			wl.logOff();
			assert.deepEqual(html(getStoryEl()), "Chunk2 content", "Move to different want after thread ends: after click, should chain through.");
			assert.deepEqual(contentForChoice(1), "Continue", "Move to different want after thread ends: single choice is to Chunk2");
			clickChoice(1);
			assert.deepEqual(html(getStoryEl()), "Chunk3 Content", "Move to different want after thread ends: second node HTML correct");

		});
	}

	return {
		run: run
	}
});