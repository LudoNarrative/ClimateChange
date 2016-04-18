/* global test */
"use strict";
define(["../ChunkLibrary"], function(ChunkLibrary) {
	
	var run = function() {
		QUnit.module( "ChunkLibrary tests" );
		test("get and set", function( assert ) {
			var chunk1 = {
				request: "R:AskPlayerHowToReact",
				choices: [
				   "R:{shownPlayerAttribute eq true}",
				   "R:spurnHost"
				]
			};
			assert.ok(ChunkLibrary.add(chunk1));
			
			var chunk2 = {
				id: "AskPlayerHowToReact",
				content: "How do you want to greet people when you arrive?"
			};
			assert.ok(ChunkLibrary.add(chunk2));
			
			var chunk3 = {
				id: "SpurnHost",
				choiceContent: "Be mean to the host.",
				content: "Screw you!",
				effects: ["set host angry"],
				conditions: ["host neq angry"]
			};
			assert.ok(ChunkLibrary.add(chunk3));

			var chunk4 = {
				id: "TestChunkId",
				content: "baz"
			};
			var addedId = ChunkLibrary.add(chunk4);
			assert.deepEqual(addedId, "TestChunkId", "returned id should be same as that passed in.");
			assert.deepEqual(ChunkLibrary.get(addedId).content, "baz", "get should return correct chunk");

			var chunk5 = {
				content: "xyzzy"
			};
			addedId = ChunkLibrary.add(chunk5);
			assert.deepEqual(ChunkLibrary.get(addedId).content, "xyzzy", "should generate unique id if necessary");

			// var badChunk1 = {
			// 	id: "bar"
			// };
			// assert.throws(function(){ChunkLibrary.add(badChunk1)}, "missing required 'content' field");
			var badChunk2 = {
				content: "text",
				foo: "bar"
			};
			assert.throws(function(){ChunkLibrary.add(badChunk2)}, "contains unrecognized 'foo' field");
		});

		test("first and next", function( assert ) {
			ChunkLibrary.reset();
			assert.deepEqual(ChunkLibrary.size(), 0);
			ChunkLibrary.add([
				{id: "Test1", content: "foo"},
				{id: "Test2", content: "foo"},
				{id: "Test3", content: "foo"}
			]);
			assert.deepEqual(ChunkLibrary.size(), 3);
			var result = ChunkLibrary.first();
			assert.deepEqual(typeof result.id, "string");
			result = ChunkLibrary.next();
			result = ChunkLibrary.next();
			assert.deepEqual(typeof result.id, "string");
			result = ChunkLibrary.next();
			assert.deepEqual(result, undefined);
			result = ChunkLibrary.first();
			assert.deepEqual(typeof result.id, "string");
		});
	}

	return {
		run: run
	}
});