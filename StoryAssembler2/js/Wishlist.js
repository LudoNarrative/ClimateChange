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

		var findPathSatisfyingWant = function(path, want, chunkLibrary) {
			// Iterate through chunks.
			var keys = chunkLibrary.getKeys();
			for (var i = 0; i < keys.length; i++) {
				var chunk = chunkLibrary.get(keys[i]);
				// TODO: Check conditions.
				console.log("chunk, want", chunk, want);
				if (path.steps.indexOf(chunk.id) < 0) {
					if (chunk.id && want.type === "id" && chunk.id === want.val) {
						path.steps.push(chunk.id);
					} else if (chunk.content) {
						path.steps.push(chunk.id);
					}
					if (chunk.request) {
						findPathSatisfyingWant(path, chunk.request, chunkLibrary);
					}
				}
			}
		}

		var findBestPath = function(chunkLibrary) {
			// Pick the first want. (Temp)
			var want = this.selectNext();
			var path = {
				steps: [],
				satisfies: []
			}
			findPathSatisfyingWant(path, want.request, chunkLibrary);
			path.satisfies.push(want.request);
			return path;
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