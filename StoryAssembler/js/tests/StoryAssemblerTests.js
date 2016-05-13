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

		});
	}

	return {
		run: run
	}
});