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

		var findBestPath = function(chunkLibrary) {
			// Pick the first want. (Temp)
			var want = this.selectNext();
			// Iterate through chunks.
			var chunk = chunkLibrary.first();
			var result = {
				path: [],
				satisfies: []
			};
			while (chunk !== undefined) {
				// TODO: Check conditions.
				if (chunk.id && chunk.id === want.content.substr(2, want.content.length)) {
					result.path.push(chunk.id);
					result.satisfies.push(want.content);
				}
				chunk = chunkLibrary.next();
			}
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