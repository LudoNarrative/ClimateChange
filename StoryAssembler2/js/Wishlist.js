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

		var wantsRemaining = function() {
			return Object.keys(_wants).length;
		}

		// Return the wishlist interface.
		return {
			remove: remove,
			selectNext: selectNext,
			wantsRemaining: wantsRemaining
		}
	}

	return {
		create: create
	}
});	