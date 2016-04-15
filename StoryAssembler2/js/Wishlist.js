/* Implements a Wishlist for StoryAssembler.

A wishlist is an unordered set of Wants.
*/

define(["Want", "util"], function(Want, util) {

	var create = function(items) {
		items = items || [];
		var _wants = {};
		// Add the wants passed in to the constructor.
		var want;
		items.forEach(function(item) {
			want = Want.create(item); // will throw error if any wants in list are invalid
			_wants[want.id] = want;
		});

		// Interface functions for the Wishlist.
		var remove = function(id) {
			delete _wants[id];
		}

		var selectNext = function() {
			if (wantsRemaining() > 0) {
				return _wants[util.oneOf(Object.keys(_wants))];
			}
			return undefined;
		}

		var findPathSatisfyingWant = function(result, want, chunkLibrary) {
			// Iterate through chunks.
			var keys = chunkLibrary.getKeys();
			// TODO rename "result"
			// TODO: Standardize format of wants. Always an object so we don't need to do string parsing?
			for (var i = 0; i < keys.length; i++) {
				var chunk = chunkLibrary.get(keys[i]);
				// TODO: Check conditions.
				console.log("chunk, want", chunk, want);
				if (result.path.indexOf(chunk.id) < 0) {
					if (chunk.id && chunk.id === want.substr(2, want.length)) {
						result.path.push(chunk.id);
						// TODO: below should only do this if the want we're looking for was on the original want list.
						// result.satisfies.push(want);
					}
					// TODO: Separate "content" and "request" so below kludge is not necessary.
					if (chunk.content && chunk.content[0] === "R") {
						// var subpath = findPathSatisfyingWant(chunk.content, chunkLibrary);
						// if (subpath) {
							// result.path.concat(subpath.path);
							// result.satisfies.concat(subpath.satisfies);
						// }
						findPathSatisfyingWant(result, chunk.content, chunkLibrary);
					}
				}
			}
		}

		var findBestPath = function(chunkLibrary) {
			// Pick the first want. (Temp)
			var want = this.selectNext();
			var result = {
				path: [],
				satisfies: []
			}
			findPathSatisfyingWant(result, want.content, chunkLibrary);
			result.satisfies.push(want.content);
			return result;
		}

		var wantsRemaining = function() {
			return Object.keys(_wants).length;
		}

		// Return the wishlist interface.
		return {
			remove: remove,
			selectNext: selectNext,
			findBestPath: findBestPath,
			wantsRemaining: wantsRemaining
		}
	}

	return {
		create: create
	}
});	