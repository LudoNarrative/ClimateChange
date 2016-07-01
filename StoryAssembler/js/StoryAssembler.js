/* Main StoryAssembler Module.

When beginScene is called, we need to pass in a defined ChunkLibrary, State, and Display module. 
*/

define(["Request", "Templates", "Want"], function(Request, Templates, Want) {

	var chunkLibrary;
	var State;
	var wishlist;
	var Display;
	var beginScene = function(_wishlist, _chunkLibrary, _State, _Display, _Character, params) {
		chunkLibrary = _chunkLibrary;
		State = _State;
		Display = _Display;
		wishlist = _wishlist;
		params = params || {};
		
		Display.init(handleChoiceSelection);
		Templates.init(State, _Character);
		continueScene();
	}

	var continueScene = function(optChunkId) {
		
		var bestPath;

		//Cases:
		if (optChunkId) {		//optchunkid is defined
		
			//display content field, or ground out request and display that content field (all this should happen in doChunkText)
			displayChunkText(optChunkId);

			var chunk = chunkLibrary.get(optChunkId);	//get data on our chunk to do the check below

			if (chunk.content) {	//if there was no chunk content, it already grounded out recursively and displayed with displayChunkText(), so we shouldn't redo that here

				bestPath = getBestPath(chunkLibrary, optChunkId);		//look for path from here

				Display.diagnose({
				path: bestPath,
				wishlist: wishlist,
				state: State.getBlackboard()
				});

				if (bestPath) {		//if we found one, handle it
					handleFoundPath(optChunkId, bestPath);
				}
				
				else {		// otherwise do a blind search
					//console.log("specific search failed, starting general search");
					bestPath = getBestPath(chunkLibrary);		//do a blind search

					if (bestPath) {
						handleFoundPath(optChunkId, bestPath);
					}

					else {
						handleNoPathFound(wishlist.wantsAsArray());
					}
				}
			}
			
		}

		else {	//optchunkid is undefined, so we're trying to continue the scene

			bestPath = getBestPath(chunkLibrary);		//do a blind search

			Display.diagnose({
				path: bestPath,
				wishlist: wishlist,
				state: State.getBlackboard()
			});

			if (bestPath) {		//if we find bestPath, then we want to handle the found path (show text, show choices)
				
				displayChunkText(bestPath.route[0]);

				var chunk = chunkLibrary.get(bestPath.route[0]);

				handleFoundPath(bestPath.route[0], bestPath);
				
			}
			else {
				handleNoPathFound(wishlist.wantsAsArray());
			}
			
		}

	}

	var getBestPath = function(chunkLibrary, startingPoint) {		
	//this function gets best path from the starting point, or if that's not specified, does a blind search 
		console.log("called getBestPath with chunkLibrary: " + chunkLibrary.getKeys() + " and startingPoint: " + startingPoint);
		if (startingPoint) {
			var temp = wishlist.bestPath(chunkLibrary, {startAt: startingPoint});
			console.log("bestPath is: " , temp);
			return temp;
		}

		else {
			var temp = wishlist.bestPath(chunkLibrary);
			console.log("bestPath is: ", temp);
			return temp;
			//return wishlist.bestPath(chunkLibrary);
		}
	}

	var displayChunkText = function(chunkId) {
		var chunk = chunkLibrary.get(chunkId);
		var text = Templates.render(chunk.content);
		if (text !== undefined) { 							//if the chunk has text, display it
			Display.addStoryText(text); 
		}
		else {												//if it's making a request for text to display...
			
			bestPath = getBestPath(chunkLibrary, chunkId);	//grab text from request
			if (!bestPath) {								//if it still isn't known...
				bestPath = getBestPath(chunkLibrary);		//do a blind search
			}
			if (!bestPath) {								//if it's still empty, throw an error
				throw new Error("Tried to get text for '" + chunkId + "' and it had no content, so we tried to recurse through bestPath, but did not find anything.");
			}

			doChunkText(chunkId, bestPath);		//display text from search
			
		}

	}

	var handleNoPathFound = function(wishlist) {
		if (wishlist.length > 0) {				//if we still have Wants...
			var unsatisfiedWants = false;
			wishlist.forEach(function(wish) {	//and they aren't persistent Wants...
				if (!wish.persistent) { unsatisfiedWants = true; }
			});

			if (unsatisfiedWants) {	Display.addStoryText("[No path found!]"); }			//we ended too soon, show error
			else { endScene(); }			//otherwise end the scene
		}
		else {
			endScene();
		}
	}

	var handleFoundPath = function(chunkId, bestPath) {
	
		//var chunkWithText = chunkId ? chunkId : bestPath.route[0];
		doChunkText(chunkId, bestPath);
		doChunkChoices(chunkId, bestPath.choiceDetails);

		// Remove this chunk from consideration, unless it has the 'repeatable' flag.
		if (!chunkLibrary.get(chunkId).repeatable) {
			chunkLibrary.remove(chunkId);
		}
		
	}

	var doChunkText = function(chunkId, bestPath) {
		var chunk = chunkLibrary.get(chunkId);

		// Handle effects
		handleEffects(chunk);

		var chunkForText = chunk;
		var routePos = 0;
		while (!chunkForText.content) {		//find content to display for the chunk
			var nextChunkId = bestPath.route[routePos];
			chunkForText = chunkLibrary.get(nextChunkId);
			//routePos += 1;		//JG: do we still need this?
			if (chunkForText) {
				if (chunkForText.choices) {
					/*
					displayChunkText(chunkForText.id);
					handleEffects(chunkForText);

					bestPath = getBestPath(chunkLibrary, nextChunkId);
					if (!bestPath) { bestPath = getBestPath(chunkLibrary);}
					
					//sometimes there are no choiceDetails because the choice has content that is the end of the experience...need to refactor doChunkChocies so that you don't need choiceDetails, but it will let you render the choice
					doChunkChoices(nextChunkId, bestPath.choiceDetails);
					*/

					continueScene(nextChunkId);		//TODO: verify this is still correct after above re-factoring
				} else {
					displayChunkText(chunkForText.id);
					handleEffects(chunkForText);
				}
			} else {
				throw new Error("We started with chunk '" + chunkId + "' and it had no content, so we tried to recurse through bestPath, but did not find anything in the path with content. bestPath was:", bestPath);
			}
		}

		// TODO: We shouldn't display "undefined" if there's no content field.
		}

	var doChunkChoices = function(chunkId, choiceDetails) {

		var chunk = chunkLibrary.get(chunkId);

		// Handle choices
		if (chunk.choices) {
			chunk.choices.forEach(function(choice, pos) {
				// TODO: What to do about choices that can't be met? Remove whole Chunk from consideration? Remove just that choice?
				var choiceText = getChoiceText(choiceDetails[pos]);
				choiceText = Templates.render(choiceText);				//render any grammars in there
				// if (choice.type == "id") { choiceText = getChoiceText(choice.val); }
				Display.addChoice({
					text: choiceText,
					chunkId: choice.val,
					cantChoose: choiceDetails[pos].missing === true
				});

			});
		// HERE: If there's a request, we should find a thing that satisfies it. We only want to go back to the wishlist (stuff below here) if this is truly a dead end.
		} else if (wishlist.wantsRemaining() > 0) {
			// We have finished a path. After clicking this button, since we didn't send a chunkId parameter below, the system will search for a new bestPath given the remaining wishlist items.
			Display.addChoice({text: "Continue"});
		} else {
			doStoryBreak();
			endScene();
		}
		Display.diagnose({
			wishlist: wishlist,
			state: State.getBlackboard()
		});
	}

	var allChoicesGotos = function(choices) {		//returns boolean of whether a chunk's choices are all gotos

		if (!choices) { return false }
		var passed = true;
		choices.forEach(function(choice) {
			if (choice.type !== "goto") { passed = false; }
		});
		return passed;
	}

	var getChoiceText = function(choiceDetail) {
		var chunk;

		if (choiceDetail.id) {
			var chunk = chunkLibrary.get(choiceDetail.id);			
		} 
		if (chunk) { return chunk.choiceLabel; }
		else {
			return "Unavailable choice request: \"" + choiceDetail.requestVal + "\"";
		}
	}

	var handleChoiceSelection = function(choice) {
		Display.clearAll();

		// Continue the scene. If we have a specific chunkId, we'll start our search with that; otherwise if it's undefined, we'll search over the whole library for a new best path.
		continueScene(choice.chunkId);
	}

	var handleEffects = function(chunk) {
		if (!chunk.effects) return;
		chunk.effects.forEach(function(effect) {
			State.change(effect);
		});
		wishlist.removeSatisfiedWants();
	}

	var doStoryBreak = function() {
		Display.addStoryText("<br><br>");
	}

	// Show an indicator that the scene is over.
	var endScene = function() {
		Display.addStoryText("[End of scene.]");
	}

	return {
		beginScene: beginScene
	}
});		