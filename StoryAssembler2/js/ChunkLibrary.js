/* Implements the library of chunks for StoryAssembler.

A chunk is a unit of story content and associated metadata. It can either directly contain text for printing, or contain a request for how to find a more specific chunk.

The library controls access to chunks.
*/

define(["Validate", "util"], function(Validate, util) {

	var _library = {};

	var requiredFields = ["content"];
	var optionalFields = ["id", "choices", "choiceContent", "effects", "conditions"];

	// Validates and adds a chunk to the library.
	var addChunk = function(chunk) {
		Validate.check(chunk, requiredFields, optionalFields); // will throw an error if chunk has wrong fields.

		// Assign an ID if one was not specified
		if (chunk.id === undefined) {
			chunk.id = "unnamedChunk" + util.iterator("chunks");
		}

		_library[chunk.id] = chunk;

		return chunk.id;
	}

	// Add a single chunk or an array of chunks to the library, returning a single ID or array of IDs.
	var add = function(input) {
		if (util.isArray(input)) {
			var newIds = [];
			input.forEach(function(chunk) {
				newIds.push(addChunk(chunk));
			});
			return newIds;
		} else {
			return addChunk(input);
		}
	}

	// return a chunk from a given id.
	var get = function(chunkId) {
		return _library[chunkId];
	}

	return {
		add: add,
		get: get
	}
});		