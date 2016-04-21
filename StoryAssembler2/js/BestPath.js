/* Implements the BestPath algorithm for StoryAssembler.

bestpath takes an array of wants and pointers to the chunk library and state, and return a single path through the chunk library that potentially satisfies the most wants from the list.

The returned path will be an object in the form:
{
	route: [], // array of chunkIDs, each step of the path
	satisfies: [] // array of all possible Want objects that this path makes true.
}

Note that not everything in "satisfies" will necessarily come to pass: our path might lead through a choice, for instance, but at run time the player selects a different choice. We will really only use the first node in "route" to move the state forward, but we return the whole path in case the rest of the system wants it for some other purpose.
*/

define(["Request", "util"], function(Request, util) {

	// Module-level reference variables
	var chunkLibrary; 
	var State;

	// The entry function: does setup, gets the set of all possible paths that satisfy at leat one Want from the list, and returns the best candidate.
	var bestPath = function(wants, _chunkLibrary, _State) {
		State = _State;
		chunkLibrary = _chunkLibrary;
		var paths = searchLibraryForPaths(wants, false, []);
		if (paths.length > 0) {
			return chooseFromPotentialPaths(paths);
		} else {
			return {};
		}
	}

	// Stub: for now, just return the first option. In the future, this should search for the path that satisfies the most Wants.
	var chooseFromPotentialPaths = function(paths) {
		return paths[0];
	}


	// Returns paths from searching every valid chunk in the library.
	var searchLibraryForPaths = function(wants, okToBeChoice, skipList) {
		var paths = [];
		var keys = chunkLibrary.getKeys();
		for (var i = 0; i < keys.length; i++) {
			var chunk = chunkLibrary.get(keys[i]);

			// Verify this chunk is valid:
			// --> it's not blacklisted.
			if (skipList.indexOf(chunk.id) >= 0) {
				continue;
			}
			// --> the conditions don't disallow it given the current State.
			if (chunk.conditions) {
				var shouldContinue = false;
				for (var j = 0; j < chunk.conditions.length; j++) {
					if (!State.isTrue(chunk.conditions[j])) {
						shouldContinue = true;
					}
				}
				if (shouldContinue) continue;
			}
			// --> it's not a response to a choice
			if (chunk.choiceLabel && (!okToBeChoice)) {
				continue;
			}

			// If we made it, consider this chunk and save any found paths
			var result = findAllSatisfyingPathsFrom(chunk, wants, skipList);
			paths = paths.concat(result);
		}

		// Return all discovered paths.
		return paths;
	}

	// Returns paths from searching a single valid chunk in the library.
	var findAllSatisfyingPathsFrom = function(chunk, wants, skipList) {
		var paths = [];
		var pathToHere;
		
		// Does this chunk directly make one or more Wants true?
		wants.forEach(function(want) {
			var satisfied = false;
			if (want.type === "id") {
				satisfied = (chunk.id === want.val);
			} else { // type === condition
				if (chunk.effects) {
					satisfied = State.wouldAnyMakeTrue(chunk.effects, want.val);
				}
			}
			if (satisfied) {
				pathToHere = createPathOrAddWant(pathToHere, chunk.id, want);
			}
		});

		// Otherwise, see if any outgoing nodes can meet any of our wants. If so, add paths for each that start with this node, noting any satisfied Wants discovered along the way.
		var vPaths, req, okToBeChoice;
		if (chunk.request && chunk.request.type === "id") {
			req = Request.byId(chunk.request.val);
			okToBeChoice = false;
			vPaths = findValidPaths(chunk, skipList, req, wants, pathToHere);
			pathToHere = vPaths.pathToHere;
			paths = paths.concat(vPaths.paths);
		}
		if (chunk.choices) {
			for (var j = 0; j < chunk.choices.length; j++) {
				req = chunk.choices[j];
				okToBeChoice = chunk.choices !== undefined;
				vPaths = findValidPaths(chunk, skipList, req, wants, pathToHere);
				pathToHere = vPaths.pathToHere;
				paths = paths.concat(vPaths.paths);
			}
		}

		// If nothing beneath this chunk led to a successful path, but this chunk satisfied at least one Want, then the only possible path from this point is a single one-step path to here.
		if (paths.length === 0 && pathToHere) {
			return [pathToHere];
		}

		// Otherwise, we either found something and added it to paths, or we didn't and we'll return an empty array to indicate our search was unsuccessful.
		return paths;
	}

	var findValidPaths = function(chunk, skipList, req, wants, pathToHere) {
		skipList.push(chunk.id);
		var newWants = util.clone(wants);
		newWants.push(req);
		var okToBeChoice = chunk.choices !== undefined;
		var validPaths = searchLibraryForPaths(newWants, okToBeChoice, skipList);
		skipList = util.removeFromStringList(skipList, chunk.id);
		if (!pathToHere) {
			pathToHere = createPathOrAddWant(pathToHere, chunk.id, []);
		}
		return {
			paths: pathsWithValidWant(validPaths, newWants, wants, pathToHere),
			pathToHere: pathToHere
		}
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

	var createPathOrAddWant = function(path, id, want) {
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

	return {
		bestPath: bestPath
	}
});