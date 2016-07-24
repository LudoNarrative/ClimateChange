/* Main StoryAssembler Module.

When beginScene is called, we need to pass in a defined ChunkLibrary, State, and Display module. 
*/

define(["Request", "Templates", "Want"], function(Request, Templates, Want) {

	var chunkLibrary;
	//var State;
	var wishlist;
	var StoryDisplay;
	var Display;
	
	var beginScene = function(_wishlist, _chunkLibrary, _State, _StoryDisplay, _Display, _Character, params) {
		chunkLibrary = _chunkLibrary;
		State = _State;
		StoryDisplay = _StoryDisplay;
		Display = _Display;
		wishlist = _wishlist;
		params = params || {};
		
		StoryDisplay.init(handleChoiceSelection, refreshNarrative);
		Templates.init(State, _Character);
		continueScene();
	}

	/*
		Continues the scene.
			-optChunkId: a chunk id
			-mode: boolean, will be false if refreshing the view (to pull from whole library)
	*/
	var continueScene = function(optChunkId) {
		
		var bestPath;

		//Cases:
		if (optChunkId) {		//optchunkid is defined
		
			//display content field, or ground out request and display that content field (all this should happen in doChunkText)
			displayChunkText(optChunkId);

			var chunk = chunkLibrary.get(optChunkId);	//get data on our chunk to do the check below

			if (chunk.content) {	//if there was no chunk content, it already grounded out recursively and displayed with displayChunkText(), so we shouldn't redo that here

				bestPath = getBestPath(chunkLibrary, optChunkId);		//look for path from here

				StoryDisplay.diagnose({
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

			StoryDisplay.diagnose({
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

	//used to tell the narrative system to refresh
	var refreshNarrative = function() {
		StoryDisplay.clearText();
		displayChunkText(State.get("currentTextId"), "refresh");		//continue scene, but draw from whole library (so...refresh)
	}

	//used in Diagnostics panel buttons to change a UI var (theVar) by some amount like +1 or -1 (theMod)
	var clickChangeState = function(theVar, theMod) {
		if (theMod[0] == "+") {
			State.set(theVar, State.get(theVar) + 1);
		}
		if (theMod[0] == "-") {
			State.set(theVar, State.get(theVar) - 1);
		}
		Display.setStats("storyStats");			//refresh UI stat display
		refreshNarrative();					//refresh currently displayed chunk in case it's different
	}

	var displayChunkText = function(chunkId, mode) {

		mode = mode || "normal";

		var chunk = chunkLibrary.get(chunkId, mode);
		var text = Templates.render(chunk.content);
		if (text !== undefined) { 							//if the chunk has text, display it
			StoryDisplay.addStoryText(text); 
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

			if (unsatisfiedWants) {	StoryDisplay.addStoryText("[No path found!]"); }			//we ended too soon, show error
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
		State.set("currentTextId", chunkId);			//set current text id so we can reference it later

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
				StoryDisplay.addChoice({
					text: choiceText,
					chunkId: choice.val,
					cantChoose: choiceDetails[pos].missing === true
				});

			});
		// HERE: If there's a request, we should find a thing that satisfies it. We only want to go back to the wishlist (stuff below here) if this is truly a dead end.
		} else if (wishlist.wantsRemaining() > 0) {
			// We have finished a path. After clicking this button, since we didn't send a chunkId parameter below, the system will search for a new bestPath given the remaining wishlist items.
			StoryDisplay.addChoice({text: "Continue"});
		} else {
			doStoryBreak();
			endScene();
		}
		StoryDisplay.diagnose({
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
			var chunk = chunkLibrary.get(choiceDetail.id, "refresh");			
		} 
		if (chunk.available) { return chunk.choiceLabel; }
		else {
			if (chunk.choiceUnavailableLabel) {
				return unavailableChoiceLabel;
			}
			else {
				return chunk.choiceLabel;
			}
		}
	}

	var handleChoiceSelection = function(choice) {
		StoryDisplay.clearAll();

		// Continue the scene. If we have a specific chunkId, we'll start our search with that; otherwise if it's undefined, we'll search over the whole library for a new best path.
		continueScene(choice.chunkId);
	}

	var handleEffects = function(chunk) {
		if (!chunk.effects) return;
		chunk.effects.forEach(function(effect) {
			State.change(effect);
		});
		wishlist.removeSatisfiedWants();
		Display.setStats("storyStats");
	}

	var doStoryBreak = function() {
		StoryDisplay.addStoryText("<br><br>");
	}

	// Show the scene is over.
	var endScene = function() {
		var text = "Chapter complete!"; 		//TODO: we need stats here
		Display.setSceneOutro(text);
	}

	return {
		beginScene: beginScene,
		refreshNarrative : refreshNarrative,
		clickChangeState : clickChangeState
	}
});		