/* Implements the BestPath algorithm for StoryAssembler.

bestpath takes an array of wants and pointers to the chunk library and state, and return a single path through the chunk library that potentially satisfies the most wants from the list.

The returned path will be an object in the form:
{
	route: [], // array of strings (chunkIDs), each step of the path
	satisfies: [] // set of every Want object that this path makes true. order is not important.
}

We need to modify this so that if route[0] is a choice, we know the first step of each choice we recursed into, so we can print the choice labels. An additional field:
	choiceDetails: [
		{ id: string chunkId } OR {} (could not be satisfied)
	] // in same order as Requests.

Note that not everything in "satisfies" will necessarily come to pass: our path might lead through a choice, for instance, but at run time the player selects a different choice. We will really only use the first node in "route" to move the state forward, but we return the whole path in case the rest of the system wants it for some other purpose.

For reference, a Want object (defined in Want.js) is in the form:
{
	request: a Request object, with fields type ("id" or "condition") and val
	optional other fields such as order, mandatory
}
*/

define(["Request", "util"], function(Request, util) {

	var MAX_DEPTH = 4;

	// Module-level reference variables
	var chunkLibrary; 
	var State;

	var init = function(_chunkLibrary, _State) {
		State = _State;
		chunkLibrary = _chunkLibrary;
	}

	// The usual entry function: does setup, calls allPaths to gets the set of all possible paths that satisfy at leat one Want from the list, and returns the best candidate.
	var bestPath = function(wants, params, _chunkLibrary, _State) {
		var paths = allPaths(wants, params, _chunkLibrary, _State);
		if (paths.length > 0) {
			return chooseFromPotentialPaths(paths, wants);
		} else {
			return undefined;
		}
	}

	// Another possible entry function, for if we want to return the list of all possible paths. (Currently used mostly for unit testing.)
	var allPaths = function(wants, params, _chunkLibrary, _State) {
		if (_chunkLibrary) init(_chunkLibrary, _State);
		if (params.max_depth) {
			MAX_DEPTH = params.max_depth;
		}
		return searchLibraryForPaths(wants, false, [], params, 1);
	}

	// Given a set of paths, choose the path that maximally satisfies Wants.
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
	var searchLibraryForPaths = function(wants, okToBeChoice, skipList, params, rLevel) {
		var paths = [];
		var keys = chunkLibrary.getKeys();
		log(rLevel, "searchLibraryForPaths. wants is [" + showWants(wants) + "] and we are skipping [" + skipList + "]. rLevel " + rLevel);

		if (params.startAt) {
			var chunk = chunkLibrary.get(params.startAt);
			return findAllSatisfyingPathsFrom(chunk, wants, skipList, rLevel);
		}

		for (var i = 0; i < keys.length; i++) {
			var chunk = chunkLibrary.get(keys[i]);

			// Verify this chunk is valid:
			// --> it's not blacklisted.
			if (skipList.indexOf(chunk.id) >= 0) {
				log(rLevel, "skipping '" + chunk.id + "'");
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
				if (shouldContinue) {
					log(rLevel, "skipping '" + chunk.id + "' because a condition contradicts current State.");
					continue;
				}
			}
			// --> it's not a response to a choice
			if (chunk.choiceLabel && (!okToBeChoice)) {
				log(rLevel, "skipping '" + chunk.id + "' b/c has a choiceLabel field");
				continue;
			}

			// If we made it, consider this chunk and save any found paths
			log(rLevel, "--> considering '" + chunk.id + "':");
			var result = findAllSatisfyingPathsFrom(chunk, wants, skipList, rLevel);
			if (result.length > 0) {
				log(rLevel, "**> found these paths: " + pathsToStr(result));
				paths = addNewIfUnique(paths, result);
				// paths = paths.concat(result);
			} else {
				log(rLevel, "**> found no paths.");
			}
		}

		// Return all discovered paths.
		log(rLevel, "finished searchLibraryForPaths for wants: [" + showWants(wants) + "] and skipList [" + skipList + "].");
		return paths;
	}

	// Returns paths from searching a single valid chunk in the library.
	var findAllSatisfyingPathsFrom = function(chunk, originalWants, skipList, rLevel) {
		var paths = [];
		var pathToHere;
		log(rLevel, "findAllSatisfyingPaths starting from '" + chunk.id + "' and satisfying wants: " + showWants(originalWants));
		
		// Does this chunk directly make one or more Wants true?
		var wants = [];
		originalWants.forEach(function(want) {
			var satisfied = false;
			if (want.type === "id") {
				satisfied = (chunk.id === want.val);
				if (satisfied) log(rLevel, "-->id makes '" + want.val + "' true");
			} else { // type === condition
				if (chunk.effects) {
					satisfied = State.wouldAnyMakeTrue(chunk.effects, want.val);
				}
				if (satisfied) log(rLevel, "-->an effect makes '" + want.val + "' true");
			}
			if (satisfied) {
				pathToHere = createPathOrAddWant(pathToHere, chunk.id, want);
			} else {
				wants.push(want);
			}
		});

		if (wants.length !== originalWants.length) {
			log(rLevel, "--> remaining wants: " + (wants.length ? showWants(wants) : "none"));
		} else {
			log(rLevel, "nothing in " + chunk.id + " directly made any Wants true");
		}
		// If we still have unsatisfied wants, check for outgoing nodes; otherwise we can stop here.
		var choiceDetails = [];
		if (wants.length > 0) { 
			// See if any outgoing nodes can meet any of our wants. If so, add paths for each that start with this node, noting any satisfied Wants discovered along the way.
			if (chunk.request && chunk.request.type === "id") {
				var req = Request.byId(chunk.request.val);
				log(rLevel, "We will now search for the request in chunk " + chunk.id + ".");
				var validPaths = searchFromHere(paths, chunk, skipList, req, wants, pathToHere, rLevel, false);
				if (validPaths.length > 0 && validPaths[0].route) {
					paths = addNewIfUnique(paths, validPaths);
				}
			}
		}
		if (chunk.choices) {
			// Even if we've satisfied all our wants, we need to recurse so we know what nodes this choice leads to.
			log(rLevel, "We will now search through the " + chunk.choices.length + " choice(s) in chunk " + chunk.id + ".");
			chunk.choices.forEach(function(choice) {
				var validPaths = searchFromHere(paths, chunk, skipList, choice, wants, pathToHere, rLevel, true);
				// Each path in validPaths should have a choiceDetails field, even if it didn't meet the Want requirements (so we know what choice labels to print when displaying the choice).
				if (!util.isArray(validPaths[0].choiceDetails)) {
					choiceDetails.push(validPaths[0].choiceDetails);
				} else {
					choiceDetails.push(validPaths[0].choiceDetails[0]);
				}
				if (validPaths.length > 0 && validPaths[0].route) {
					paths = addNewIfUnique(paths, validPaths);
				}
			});
			// log(rLevel, "After choices, choiceDetails is now " + choiceDetails.map(function(x){return x.id}));
			log(rLevel, "Search through choice(s) of " + chunk.id + " finished.")
		}
		if (paths.length === 0) {
			if (pathToHere) {
				// If nothing beneath this chunk led to a successful path, but this chunk satisfied at least one Want, then the only possible path from this point is a single one-step path to here.
				if (chunk.choices && numChoicesFound(choiceDetails) === 0) {
					log(rLevel, "-->no choices of '" + chunk.id + "' were valid, so we can't count this path as successful.");
					return []; // We can't pick this node because none of the choices were available.
				}
				log(rLevel, "-->no valid descendants of '" + chunk.id + "', but it directly satisfied >= 1 Want, so marking path to here successful: " + pathToStr(pathToHere));
				if (chunk.choices) {
					pathToHere.choiceDetails = choiceDetails;
				}
				return [pathToHere];
			} else {
				return []; // return an empty array to indicate our search was unsuccessful
			}
		} else {
			// Otherwise, we found something and added it to paths.
			paths.forEach(function(path) {
				path.choiceDetails = choiceDetails;
			});
			return paths;
		}
	}

	var numChoicesFound = function(choiceDetails) {
		var count = 0;
		choiceDetails.forEach(function(d) {
			if (d.id) count += 1;
		});
		return count;
	}

	// Recurse down into a request (either a direct request or a choice request) and return any unique paths found.
	var searchFromHere = function(paths, chunk, skipList, req, wants, pathToHere, rLevel, isChoice) {

		// If we've bottomed out our recursion depth, if we have established that the path to this chunk is valid, then say the set of all valid paths from here is just the path to here. Otherwise, say no valid paths from here.
		if (rLevel >= MAX_DEPTH) {
			log(rLevel, "hit MAX_DEPTH " + MAX_DEPTH + "; stopping here for this path.");
			if (pathToHere === undefined) {
				return [{id: "skipping", choiceDetails: {missing: true, requestVal: req.val}}];
			} else {
				return [pathToHere];
			}
		} 

		var newSkipList = util.clone(skipList);
		return findValidPaths(chunk, newSkipList, req, wants, pathToHere, rLevel, isChoice);
	}

	// Internal function to setup, recurse, and takedown a restricted search through the chunk library.
	// We have a list of Wants we're searching for. In that context, we have a specific Want (req). What we want to do is start a new top-level search for just req; but from the results, we want to abandon any that don't meet one of our original wants.
	var findValidPaths = function(chunk, skipList, req, wants, pathToHereRef, rLevel, isChoice) {

		var validPaths = [];

		// First we'll revise the list of Wants we're looking for to include the additional search parameter.
		var newWants = util.clone(wants);
		newWants.push(req);

		var okToBeChoice = chunk.choices !== undefined;

		// Then we'll temporarily exclude the current node from the seach space (to avoid infinite loops/graphs with cycles), and do the search.
		skipList.push(chunk.id);
		var foundPaths = searchLibraryForPaths(newWants, okToBeChoice, skipList, {}, rLevel + 1);
		skipList = util.removeFromStringList(skipList, chunk.id);

		// The only valid paths are those that DID satisfy "req", AND also satisfied at least one original Want.
		log(rLevel, "found " + foundPaths.length + " paths");
		log(rLevel, "We only want paths that satisfy " + req.val + " AND satisfy at least one of these Wants: " + showWants(wants));
		validPaths = pathsThatSatisfyReq(foundPaths, req);

		// If we have any paths at this point, pick one and save the id of the first step in its route, so if this is a choice we'll know what chunk matched.
		var choiceMatch;
		if (isChoice && validPaths.length) {
			choiceMatch = validPaths[0].route[0];
			log(rLevel, "setting choiceMatch to " + choiceMatch);
		}

		validPaths = pathsPrunedToOriginalWants(validPaths, wants);
		log(rLevel, "(" + validPaths.length + " are valid)");

		// Link each remaining path to the current node, first ensuring we have a pathToHere obj. I.e. if we're at A and we found a path B->C, we want the path to now be A->B->C.
		if (validPaths.length > 0) {
			if (!pathToHereRef) {
				pathToHereRef = createPathOrAddWant(pathToHereRef, chunk.id);
			}
			validPaths.forEach(function(path) {
				path.route = pathToHereRef.route.concat(path.route);
				path.satisfies = pathToHereRef.satisfies.concat(path.satisfies);
				if (choiceMatch) {
					path.choiceDetails = [{id: choiceMatch}];
				} 
			});
			return validPaths;
		}
		else {
			if (choiceMatch) {
				return [{choiceDetails: {id: choiceMatch}}];
			} else {
				return [{choiceDetails: {missing: true, requestVal: req.val}}]
			}
		}
	}

	// From pathList, eliminate paths that do not satisfy 'req'.
	var pathsThatSatisfyReq = function(pathList, req) {
		var validPaths = [];
		pathList.forEach(function(path) {
			var wantVals = getWantVals(path.satisfies);
			if (wantVals.indexOf(req.val) >= 0) {
				validPaths.push(path);
			} 
		});
		return validPaths;
	}

	// From pathList, remove any wants in the 'satisfies' field that are not in the given 'wants' list. If this removes all wants from a path's 'satisfies' field, remove that path entirely.
	var pathsPrunedToOriginalWants = function(pathList, wants) {
		var validPaths = [];
		pathList.forEach(function(path) {
			path.satisfies = restrictWantsTo(path.satisfies, wants);
			if (path.satisfies.length > 0) {
				validPaths.push(path);
			} 
		});
		return validPaths;
	}

	// wantsList might be [x, y, z]. if targetWants is [y, z], we want to return [y, z]. If targetWants is [q], we want to return [].
	var restrictWantsTo = function(wantsList, targetWants) {
		var newList = [];
		var targetWantVals = getWantVals(targetWants);
		wantsList.forEach(function(want) {
			if (targetWantVals.indexOf(want.val) >= 0) {
				newList.push(want);
			}
		});
		return newList;
	}

	// Take two lists of paths, and return the first list with any unique paths from the second list added. 
	var addNewIfUnique = function(paths, newPaths) {
		newPaths.forEach(function(path1) {
			for (var i = 0; i < paths.length; i++) {
				var path2 = paths[i]
				if (util.arrEqual(path1.route, path2.route)) {
					// path1 is in paths; we can exclude path1.
					return; // from forEach (consider next newPath)
				}
			}
			// not found, so add.
			paths.push(path1);	
		});
		return paths;
	}

	// Take a list of Want objects and return an array of their "val" fields, making it easier to compare two Wants.
	var getWantVals = function(wants) {
		return wants.map(function(want) {
			return want.val;
		})
	}

	var createPathOrAddWant = function(path, id, want) {
		if (!path) {
			path = { 
				route: [id],
				satisfies: want ? [want] : [],
			}
		} else if (want) {
			path.satisfies.push(want);
		}
		return path;
	}

	var pathToStr = function(path) {
		if (!path) return "undefined";
		var msg = path.route.join("->") + " [satisfies " + path.satisfies.map(function(x){return x.val}).join("; ");
		if (path.choiceDetails) {
			// msg += ", choiceDetails: " + path.choiceDetails.map(function(x){return x.id}).join("; ") + "]";
		} else { 
			msg += "]"
		}
		return msg;
	}
	var pathsToStr = function(arrOfPaths) {
		return arrOfPaths.map(pathToStr).join(" | ");
	}
	var showWants = function(wants) {
		return wants.map(function(x) {
			return x.val
		});
	}

	var logState = false;
	var logOn = function() {
		logState = true;
	}
	var logOff = function() {
		logState = false;
	}
	var _spaces = "                                                                                                                              ";
	var _spacesPerTab = 5;
	var log = function(rLevel, msg) {
		if (logState) {
			console.log(_spaces.slice(0, (rLevel-1) * _spacesPerTab) + msg);
		}
	}

	return {
		init: init,
		bestPath: bestPath,
		allPaths: allPaths,
		logOn: logOn,
		logOff: logOff
	}
});