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

		var chunkLibrary;
		var bestPath = function(_chunkLibrary) {
			chunkLibrary = _chunkLibrary;
			var want = this.selectNext().request;
			var wants = [want]; // For now, passing down a single want, but architected to accept a list.
			var paths = searchLibraryForPaths(wants, false, []);
			if (paths.length > 0) {
				return chooseFromPotentialPaths(paths);
			} else {
				return {};
			}
		}

		// Returns paths from searching every valid chunk in the library.
		var searchLibraryForPaths = function(wants, okToBeChoice, skipList) {
			var paths = [];
			var keys = chunkLibrary.getKeys();
			for (var i = 0; i < keys.length; i++) {
				var chunk = chunkLibrary.get(keys[i]);

				// Verify this chunk is valid.
				if (skipList.indexOf(chunk.id) >= 0) {
					continue;
				}
				if (chunk.conditions) {
					var shouldContinue = false;
					for (var j = 0; j < chunk.conditions.length; j++) {
						var cnd = chunk.conditions[j];
						if (!State.isTrue(cnd)) {
							shouldContinue = true;
						}
					}
					if (shouldContinue) continue;
				}
				if (chunk.choiceLabel && (!okToBeChoice)) {
					continue;
				}

				var result = findAllSatisfyingPathsFrom(chunk, wants, skipList);
				paths = paths.concat(result);
			}
			return paths;
		}

		// Returns paths from searching a single valid chunk in the library.
		var findAllSatisfyingPathsFrom = function(chunk, wants, skipList) {
			var paths = [];
			var pathToHere;

			// Does this chunk directly make one or more wants true?
			console.log("wants", wants);
			wants.forEach(function(want) {
				var satisfied = false;
				if (want.type === "id") {
					satisfied = chunk.id === want.val;
				} else { // type === condition
					if (chunk.effects) {
						satisfied = State.wouldAnyMakeTrue(chunk.effects, want.val);
					}
				}
				if (satisfied) {
					pathToHere = createOrAddWant(pathToHere, chunk.id, want);
				}
			});
			// If so, and there are no outgoing nodes, then the only possible paths from this point are a single one-step path of this chunk, with all the wants it satisfies.
			if (pathToHere && !chunk.request && !chunk.choices) {
				return [pathToHere];
			}

			// Otherwise, see if any outgoing nodes can meet any of our wants. If so, add a path that starts with this node and includes the returned path, and add any met wants to the path.

			// Recurse through all possible paths from this chunk
			var validPaths;
			if (chunk.request && chunk.request.type === "id") {
				var requestedChunk = chunkLibrary.get(chunk.request.val);
				var req = Request.byId(chunk.request.val);
				validPaths = findAllSatisfyingPathsFrom(requestedChunk, [req], skipList);

				paths = paths.concat(pathsWithValidWant(validPaths, req, wants, pathToHere));
			}
			if (chunk.choices) {
				for (var j = 0; j < chunk.choices.length; j++) {
					var choice = chunk.choices[j];

					skipList.push(chunk.id);
					var refinedWants = util.clone(wants);
					refinedWants.push(choice);
					validPaths = searchLibraryForPaths(refinedWants, chunk.choices, skipList);
					skipList = util.removeFromStringList(skipList, chunk.id);

					if (!pathToHere) {
						pathToHere = createOrAddWant(pathToHere, chunk.id, []);
					}
					paths = paths.concat(pathsWithValidWant(validPaths, choice, wants, pathToHere));

				}
			}
			// If none of the recursions were successful, but this one was, add it to the list.
			if (paths.length === 0 && pathToHere) {
				return [pathToHere];
			}

			return paths;
		}

		var pathsWithValidWant = function(pathList, nodeToRemove, wants, pathToHere) {
			var returnPaths = [];
			for (var y = 0; y < pathList.length; y++) {
				var thisPath = pathList[y];
				thisPath.satisfies = removeFromSatisfies(thisPath.satisfies, nodeToRemove); // scrub "satisfies" of the want we added.
				// now, if this path has any wants from our list, count it as valid.
				if (anyInFirstAreInSecond(thisPath.satisfies, wants)) {
					returnPaths.push({
						route: pathToHere ? pathToHere.route.concat(thisPath.route) : thisPath.route,
						satisfies: pathToHere ? pathToHere.satisfies.concat(thisPath.satisfies) : thisPath.satisfies
					});
				}
			}
			return returnPaths;
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
					satisfies: want? [want] : []
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