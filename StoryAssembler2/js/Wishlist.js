/* Implements a Wishlist for StoryAssembler.

A wishlist is an unordered set of Wants.
*/

define(["Want", "Request", "util"], function(Want, Request, util) {

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

		var bestPath = function(chunkLibrary) {
			var want = this.selectNext().request;

			var paths = searchLibraryForPaths(want, chunkLibrary);
			if (paths.length > 0) {
				return chooseFromPotentialPaths(paths);
			} else {
				return {};
			}
		}

		var searchLibraryForPaths = function(want, chunkLibrary) {
			var paths = [];
			var keys = chunkLibrary.getKeys();
			for (var i = 0; i < keys.length; i++) {
				var chunk = chunkLibrary.get(keys[i]);
				var result = findAllSatisfyingPathsFrom(chunk, want, undefined, chunkLibrary);
				if (result.length > 0) {
					paths = paths.concat(result);
				}
			}
			return paths;
		}

		var findAllSatisfyingPathsFrom = function(chunk, want, parent, chunkLibrary) {
			var paths = [];
			var path = {};
			if (chunk.conditions) {
				for (var i = 0; i < chunk.conditions.length; i++) {
					var cnd = chunk.conditions[i];
					if (!State.isTrue(cnd)) {
						console.log("it is not true that " + cnd + ", so skipping");
						return paths;
					}
				}
			}
			if (chunk.choiceLabel && (!parent || (parent && !parent.choices))) {
				console.log("skipping " + chunk.id + " b/c has choiceLabel field and parent does not have choices field.");
				return paths;
			}
			if (want.type === "id" && chunk.id === want.val) {
				console.log("id " + chunk.id + " matches want " + want.val + "; adding to path");
				path = {
					route: [chunk.id],
					satisfies: [want]
				}
			} else if (want.type === "condition" && chunk.effects) {
				chunk.effects.forEach(function(effect) {
					if (State.wouldMakeTrue(effect, want.val)) {
						console.log("id " + chunk.id + " has effect that would make want " + want.val + " true; adding to path");
						path = {
							route: [chunk.id],
							satisfies: [want]
						}
						// TODO; Despite forEach loop, this can only handle one b/c sets val of path manually
					}
				});
			}
			if (chunk.request && chunk.request.type === "id") {
				console.log("request of type id: iterating down");
				var requestedChunk = chunkLibrary.get(chunk.request.val);
				var reqPath = findAllSatisfyingPathsFrom(requestedChunk, Request.byId(chunk.request.val), chunk, chunkLibrary);
				if (reqPath.length > 0) {
					var firstPath = reqPath[0];
					if (!path.route) path.route = [];
					path.route = path.route.concat(firstPath.route);
					// path.satisfies = path.satisfies.concat(firstPath.satisfies); // TODO: we don't want to record the want we satisfied as a result of being in this node: we only care about the original want. Maybe we can prune when we get back to the top?
				}
			}
			// if (chunk.choices) {
			// 	for (var j = 0; j < chunk.choices.length; j++) {
			// 		var choice = chunk.choices[j];
			// 		findAllSatisfyingPathsFrom();
			// 	}
			// }

			if (path.route) {
				paths.push(path);
			}
			return paths;
		}

		var chooseFromPotentialPaths = function(paths) {
			// Stub: just return the first.
			console.log("paths[0]", paths[0]);
			return paths[0];
		}

		var wantsRemaining = function() {
			return Object.keys(_wants).length;
		}

		// Return the wishlist interface.
		return {
			remove: remove,
			selectNext: selectNext,
			bestPath: bestPath,
			wantsRemaining: wantsRemaining
		}
	}

	return {
		create: create
	}
});	