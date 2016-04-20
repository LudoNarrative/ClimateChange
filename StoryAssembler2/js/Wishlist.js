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
			var wants = [want]; // For now, passing down a single want, but architected to accept a list.
			var paths = searchLibraryForPaths(wants, chunkLibrary, [], undefined);
			if (paths.length > 0) {
				return chooseFromPotentialPaths(paths);
			} else {
				return {};
			}
		}

		var searchLibraryForPaths = function(wants, chunkLibrary, skipList, parent) {
			var paths = [];
			var keys = chunkLibrary.getKeys();
			for (var i = 0; i < keys.length; i++) {
				var chunk = chunkLibrary.get(keys[i]);
				var result = findAllSatisfyingPathsFrom(chunk, wants, parent, chunkLibrary, skipList);
				paths = paths.concat(result);
			}
			return paths;
		}

		var findAllSatisfyingPathsFrom = function(chunk, wants, parent, chunkLibrary, skipList) {
			var paths = [];
			var pathToHere;

			// Verify this chunk is valid.
			if (skipList.indexOf(chunk.id) >= 0) {
				return paths;
			}
			if (chunk.conditions) {
				for (var i = 0; i < chunk.conditions.length; i++) {
					var cnd = chunk.conditions[i];
					if (!State.isTrue(cnd)) {
						console.log("it is not true that " + cnd + ", so skipping");
						skipList.push(chunk.id);
						return paths;
					}
				}
			}
			if (chunk.choiceLabel && (!parent || (parent && !parent.choices))) {
				console.log("skipping " + chunk.id + " b/c has choiceLabel field and parent does not have choices field.");
				return paths;
			}

			// Consider each want.
			for (var z = 0; z < wants.length; z++) {
				var want = wants[z];

				// Does this chunk directly make any want true?
				if (want.type === "id" && chunk.id === want.val) {
					console.log("id " + chunk.id + " matches want " + want.val + "; adding to path");
					pathToHere = createOrAddWant(pathToHere, chunk.id, want);
				} else if (chunk.effects && want.type === "condition") {
					for (var b = 0; b < chunk.effects.length; b++) {
						var effect = chunk.effects[b]
						if (State.wouldMakeTrue(effect, want.val)) {
							console.log("id " + chunk.id + " has effect that would make want " + want.val + " true; adding to path");
							pathToHere = createOrAddWant(pathToHere, chunk.id, want);
							break;
						}
					}
				}
			}
			// If so, and there are no outgoing nodes, then return a one-step path to this point. 
			if (pathToHere && !chunk.request && !chunk.choices) {
				return [pathToHere];
			}

			// Otherwise, see if any outgoing nodes can meet any of our wants. If so, add a path that starts with this node and includes the returned path, and add any met wants to the path.

			// Recurse through all possible paths from this chunk
			if (chunk.request && chunk.request.type === "id") {
				console.log("request of type id: iterating down");
				var requestedChunk = chunkLibrary.get(chunk.request.val);
				var req = Request.byId(chunk.request.val);
				var validPaths = findAllSatisfyingPathsFrom(requestedChunk, [req], chunk, chunkLibrary, []);
				
				// Remove any paths that don't satisfy want
				for (var y = 0; y < validPaths.length; y++) {
					var thisPath = validPaths[y];
					thisPath.satisfies = removeFromSatisfies(thisPath.satisfies, req); // scrub "satisfies" of the want we added.
					// now, if this path has any wants from our list, count it as valid.
					if (anyInFirstAreInSecond(thisPath.satisfies, wants)) {
						paths.push({
							route: pathToHere ? pathToHere.route.concat(thisPath.route) : thisPath.route,
							satisfies: pathToHere ? pathToHere.satisfies.concat(thisPath.satisfies) : thisPath.satisfies
						});
					}
				}
			}
			if (chunk.choices) {
				for (var j = 0; j < chunk.choices.length; j++) {
					var choice = chunk.choices[j];
					skipList.push(chunk.id);

					// Recurse with the additional want of satisfying this choice option's request
					var validPaths = searchLibraryForPaths(choice, chunkLibrary, skipList, chunk);

					// Remove any paths that don't satisfy want
					for (var y = 0; y < validPaths.length; y++) {
						var thisPath = validPaths[y];
						thisPath.satisfies = removeFromSatisfies(thisPath.satisfies, choice); // scrub "satisfies" of the choice want we added.
						// now, if this path has any wants from our list, count it as valid.
						if (anyInFirstAreInSecond(thisPath.satisfies, wants)) {
							paths.push({
								route: pathToHere ? pathToHere.route.concat(thisPath.route) : thisPath.route,
								satisfies: pathToHere ? pathToHere.satisfies.concat(thisPath.satisfies) : thisPath.satisfies
							});
						}
					}

					skipList = util.removeFromStringList(skipList, chunk.id);
				}
			}
			// If none of the recursions were successful, but this one was, add it to the list.
			if (paths.length === 0 && pathToHere) {
				return [pathToHere];
			}

			return paths;
		}

		var removeFromSatisfies = function(satisfies, wantToRemove) {
			var newSatisfies = [];
			satisfies.forEach(function(want) {
				if (want.val !== wantToRemove.val) {
					newSatisfies.push(want);
				}
			});
			return newSatisfies;
		}

		var anyInFirstAreInSecond = function(firstWants, secondWants) {
			for (var i = 0; i < firstWants.length; i++) {
				var want = firstWants[i];
				for (var j = 0; j < secondWants.length; j++) {
					if (want.val === secondWants[j].val) {
						return true;
					}
				}
			}
			return false;
		}

		var createOrAddWant = function(path, id, want) {
			if (!path) {
				path = { // TODO: This needs to be appending to satisfies each time through loop.
					route: [id],
					satisfies: [want]
				}
			} else {
				path.satisfies.push(want);
			}
			return path;
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