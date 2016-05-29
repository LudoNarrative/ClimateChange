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

		//this function should be re-factored to follow the below logic...this will help with the current broken test (and handle edge cases with recursive requests)
		//some code from doChunkChoices will need to be moved up here as part of refactoring (continue button and end scene code)

		//Cases:
		if (optChunkId) {		//optchunkid is defined
		
			//display content field, or ground out request and display that content field (all this should happen in doChunkText)
			displayChunkText(optChunkId);

			bestPath = wishlist.bestPath(chunkLibrary, {startAt: optChunkId});		//then look for path from here

			Display.diagnose({
			path: bestPath,
			wishlist: wishlist,
			state: State.getBlackboard()
			});

			if (bestPath) {		//if we found one, say "Continue."
				//Display.addChoice({text: "Continue"});
				handleFoundPath(optChunkId, bestPath);
			}
			
			else {		// otherwise do a blind search
				console.log("specific search failed, starting general search");
				bestPath = wishlist.bestPath(chunkLibrary);		//do a blind search

				if (bestPath) {
					handleFoundPath(optChunkId, bestPath);
				}

				else {
					handleNoPathFound(wishlist.wantsAsArray());
				}
			}
			
		}

		else {	//optchunkid is undefined, so we're trying to continue the scene
			
			bestPath = wishlist.bestPath(chunkLibrary);		//do a blind search

			Display.diagnose({
				path: bestPath,
				wishlist: wishlist,
				state: State.getBlackboard()
			});

			if (bestPath) {		//if we find bestPath, then we want to handle the found path (show text, show choices)
				
				displayChunkText(bestPath.route[0]);
				handleFoundPath(bestPath.route[0], bestPath);
				
			}
			else {
				handleNoPathFound(wishlist.wantsAsArray());
			}
			
		}

	}

	var displayChunkText = function(chunkId) {
		var chunk = chunkLibrary.get(chunkId);
		var text = Templates.render(chunk);
		if (text !== undefined) { 
			Display.addStoryText(text); 
		}
		else {
			console.log("undefined for " + chunkId);
			
			bestPath = wishlist.bestPath(chunkLibrary, {startAt: chunkId});
			if (!bestPath) {
				bestPath = wishlist.bestPath(chunkLibrary);		//do a blind search
			}
			doChunkText(chunkId, bestPath);
			
		}

	}

	var handleNoPathFound = function(wishlist) {
		if (wishlist.length > 0) {
			Display.addStoryText("[No path found!]");
		}
		else {
			endScene();
		}
	}

	var handleFoundPath = function(optChunkId, bestPath) {
	
		//var chunkWithText = optChunkId ? optChunkId : bestPath.route[0];
		doChunkText(optChunkId, bestPath);
		doChunkChoices(optChunkId, bestPath.choiceDetails);
		
	}

	var doChunkText = function(chunkId, bestPath) {
		var chunk = chunkLibrary.get(chunkId);

		// Handle effects
		handleEffects(chunk);

		// Get and show text for that item.
		// var text = Request.getText(nextItem.content);
		var chunkForText = chunk;
		var routePos = 0;
		while (!chunkForText.content) {		//find content to display for the chunk
			routePos += 1;
			var nextChunkId = bestPath.route[routePos];
			chunkForText = chunkLibrary.get(nextChunkId);
			if (chunkForText) {
				if (chunkForText.choices) {
					continueScene(nextChunkId);		//TODO: verify this is still correct after above re-factoring
					return;
				} else {
					displayChunkText(chunkForText.id);
					handleEffects(chunkForText);
				}
			} else {
				throw new Error("We started with chunk '" + chunkId + "' and it had no content, so we tried to recurse through bestPath, but did not find anything in the path with content. bestPath was:", bestPath);
			}
		}

		//var text = Templates.render(chunkForText);
		//Display.addStoryText(text);
		// TODO: We shouldn't display "undefined" if there's no content field.
		}

	var doChunkChoices = function(chunkId, choiceDetails) {

		var chunk = chunkLibrary.get(chunkId);

		// Handle choices
		if (chunk.choices) {
			chunk.choices.forEach(function(choice, pos) {
				// TODO: What to do about choices that can't be met? Remove whole Chunk from consideration? Remove just that choice?
				// TODO: Our path needs to save which node we found that met the conditions for a choice, so we know what text to print here.
				var choiceText = getChoiceText(choiceDetails[pos]);
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

	var getChoiceText = function(choiceDetail) {
		if (choiceDetail.id) {
			var chunk = chunkLibrary.get(choiceDetail.id);
			return chunk.choiceLabel;
		} else {
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