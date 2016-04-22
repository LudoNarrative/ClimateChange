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

	var init = function(_chunkLibrary, _State) {
		State = _State;
		chunkLibrary = _chunkLibrary;
	}

	// The entry function: does setup, gets the set of all possible paths that satisfy at leat one Want from the list, and returns the best candidate.
	var bestPath = function(wants, _chunkLibrary, _State) {
		if (_chunkLibrary) init(_chunkLibrary, _State);
		var paths = searchLibraryForPaths(wants, false, []);
		if (paths.length > 0) {
			return chooseFromPotentialPaths(paths, wants);
		} else {
			return undefined;
		}
	}

	var allPaths = function(wants, _chunkLibrary, _State) {
		if (_chunkLibrary) init(_chunkLibrary, _State);
		return searchLibraryForPaths(wants, false, []);
	}

	// Given an array of paths, choose one that maximally satisfies Wants.
	// We are assuming the only Wants listed are those in our original list.
	var chooseFromPotentialPaths = function(paths, wants) {
		var bestScore = -1;
		var bestPos = -1;
		paths.forEach(function(path, pos) {
			var thisScore = path.satisfies.length;
			if (thisScore > bestScore) {
				bestScore = thisScore;
				bestPos = pos;
			}
		});
		return paths[bestPos];
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
	var findAllSatisfyingPathsFrom = function(chunk, originalWants, skipList) {
		var paths = [];
		var pathToHere;
		log("considering " + chunk.id);
		
		// Does this chunk directly make one or more Wants true?
		var wants = [];
		originalWants.forEach(function(want) {
			var satisfied = false;
			if (want.type === "id") {
				satisfied = (chunk.id === want.val);
				if (satisfied) log("-->id makes '" + want.val + "' true");
			} else { // type === condition
				if (chunk.effects) {
					satisfied = State.wouldAnyMakeTrue(chunk.effects, want.val);
				}
				if (satisfied) log("-->an effect makes '" + want.val + "' true");
			}
			if (satisfied) {
				pathToHere = createPathOrAddWant(pathToHere, chunk.id, want);
			} else {
				wants.push(want);
			}
		});

		// Otherwise, see if any outgoing nodes can meet any of our wants. If so, add paths for each that start with this node, noting any satisfied Wants discovered along the way.
		var reqs = [];
		if (chunk.request && chunk.request.type === "id") {
			log("-->request '" + chunk.request.val + "', so will recurse...");
			reqs.push(Request.byId(chunk.request.val));
		}
		if (chunk.choices) {
			chunk.choices.forEach(function(choice) {
				log("-->has choice '" + choice.val + "', so will recurse...");
				reqs.push(choice);
			});
		}
		reqs.forEach(function(req) {
			log("-->recursing down to find '" + req.val + "'");
			paths = paths.concat(findValidPaths(chunk, skipList, req, wants, pathToHere));
		});

		// If nothing beneath this chunk led to a successful path, but this chunk satisfied at least one Want, then the only possible path from this point is a single one-step path to here.
		if (paths.length === 0 && pathToHere) {
			log("-->no paths from '" + chunk.id + "' led to valid path, but this directly satisfied >= 1 Want, so marking path to here successful");
			return [pathToHere];
		}

		// Otherwise, we either found something and added it to paths, or we didn't and we'll return an empty array to indicate our search was unsuccessful.
		log("-->returning paths of " + pathsToStr(paths));
		return paths;
	}

	// Internal function to setup, recurse, and takedown a restricted search through the chunk library.
	var findValidPaths = function(chunk, skipList, req, wants, pathToHereRef) {

		// First we'll revise the list of Wants we're looking for to include the additional search parameter.
		var newWants = util.clone(wants);
		newWants.push(req);
		var okToBeChoice = chunk.choices !== undefined;

		// Then we'll temporarily exclude the current node from the seach space (to avoid infinite loops), and do the search.
		skipList.push(chunk.id);
		log("(looking for valid paths from '" + chunk.id + "' satisfying req '" + req.val + "'. wants looking for: " + newWants.map(function(x){return x.val}) + "; skipping " + skipList + ")");
		var foundPaths = searchLibraryForPaths(newWants, okToBeChoice, skipList);
		skipList = util.removeFromStringList(skipList, chunk.id);

		// Remove any paths found that only had the additional search parameter (i.e., we only care about paths from here that satisfied one of our original Wants.)
		log("(back from looking from '" + chunk.id + "'; found " + foundPaths.length + " paths");
		var validPaths = pathsWithValidWant(foundPaths, req, wants);
		log("(" + validPaths.length + " of them valid)");

		// Link each remaining path to the current node, first ensuring we have a pathToHere obj. I.e. if we're at A and we found a path B->C, we want the path to now be A->B->C.
		if (validPaths.length > 0) {
			if (!pathToHereRef) {
				pathToHereRef = createPathOrAddWant(pathToHereRef, chunk.id);
			}
			validPaths.forEach(function(path) {
				linkPathToHere(path, pathToHereRef);
			});
		}

		log("returning " + pathsToStr(validPaths));
		return validPaths;
	}

	var pathsWithValidWant = function(pathList, wantToRemove, wants) {
		var validList = [];
		log("pathsWithValidWant: pathList " + pathsToStr(pathList) + ", wantToRemove: " + wantToRemove.val);
		pathList.forEach(function(path) {
			// scrub "satisfies" of the Want we added.
			var oldLength = path.satisfies.length;
			path.satisfies = removeFromSatisfies(path.satisfies, wantToRemove); 
			// If this had the target want, and any of our original Wants are there, keep this path.
			if (path.satisfies.length < oldLength && anyInFirstAreInSecond(path.satisfies, wants)) {
				validList.push(path);
			}
		});
		log("validList is now " + pathsToStr(validList));
		return validList;
	}

	var linkPathToHere = function(path, pathToHere) {
		log("linkPathToHere: path is " + pathToStr(path) + ", pathToHere is " + pathToStr(pathToHere));
		path.route = pathToHere.route.concat(path.route);
		// path.satisfies = util.removeArrDuplicates(pathToHere.satisfies.concat(path.satisfies));
		path.satisfies = pathToHere.satisfies.concat(path.satisfies);
		log("--> aaaaand now it's " + pathToStr(path));
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
		log("createPathOrAddWant: path is " + pathToStr(path));
		if (!path) {
			path = { 
				route: [id],
				satisfies: want ? [want] : []
			}
		} else if (want) {
			path.satisfies.push(want);
		}
		log("-->and now it's " + pathToStr(path));
		return path;
	}

	var pathToStr = function(path) {
		if (!path) return "undefined";
		return path.route.join("->") + " [" + path.satisfies.map(function(x){return x.val}).join("; ") + "]";
	}
	var pathsToStr = function(arrOfPaths) {
		return arrOfPaths.map(pathToStr).join("\n");
	}

	var logState = false;
	var logOn = function() {
		logState = true;
	}
	var logOff = function() {
		logState = false;
	}
	var log = function(msg) {
		if (logState) console.log(msg);
	}

	return {
		init: init,
		bestPath: bestPath,
		allPaths: allPaths,
		logOn: logOn,
		logOff: logOff
	}
});