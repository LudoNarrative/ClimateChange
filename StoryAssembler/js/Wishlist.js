/* Implements a Wishlist for StoryAssembler.

A wishlist is an unordered set of Wants.
*/

define(["Want", "BestPath", "util"], function(Want, BestPath, util) {

	// Note: We need to pass in a reference to State, rather than including it here, so we don't create a duplicate State by requiring it above.
	var create = function(items, _State) {
		var State = _State;
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

		var wantsAsArray = function() {
			var keys = Object.keys(_wants);
			var arr = [];
			keys.forEach(function(key) {
				arr.push(_wants[key].request);
			});
			return arr;
		}
		var fullWantsAsArray = function() {
			var keys = Object.keys(_wants);
			var arr = [];
			keys.forEach(function(key) {
				arr.push(_wants[key]);
			});
			return arr;
		}

		var bestPath = function(chunkLibrary, params) {
			return BestPath.bestPath(fullWantsAsArray(), params || {}, chunkLibrary, State);
		}
		var allPaths = function(chunkLibrary, params) {
			return BestPath.allPaths(fullWantsAsArray(), params || {}, chunkLibrary, State);
		}

		var removeSatisfiedWants = function() {
			var keys = Object.keys(_wants);
			keys.forEach(function(key) {
				if (State.isTrue(_wants[key].request.val)) {
					delete _wants[key];
				}
			});
		}

		var toStr = function() {
			return wantsAsArray().map(function(want) {
				return want.val;
			}).join(", ");
		}

		// Return the wishlist interface.
		return {
			remove: remove,
			selectNext: selectNext,
			bestPath: bestPath,
			allPaths: allPaths,
			wantsRemaining: wantsRemaining,
			logOn: BestPath.logOn,
			logOff: BestPath.logOff,
			pathToStr: BestPath.pathToStr,
			pathsToStr: BestPath.pathsToStr,
			toStr: toStr,
			removeSatisfiedWants: removeSatisfiedWants,
			wantsAsArray: wantsAsArray
		}
	}

	return {
		create: create
	}
});	