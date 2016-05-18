/* Main StoryAssembler Module.

When beginScene is called, we need to pass in a defined ChunkLibrary, State, and Display module. 
*/

define(["Request", "Templates"], function(Request, Templates) {

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
		// If optChunkId is undefined, the startAt parameter below will also be undefined and will have no effect.
		var bestPath = wishlist.bestPath(chunkLibrary, {startAt: optChunkId});
		Display.diagnose({
			path: bestPath,
			wishlist: wishlist,
			state: State.getBlackboard()
		});

		if (!bestPath) {		//if we can't find a path from our starting chunk, failover to a general search
			console.log("specific search failed, starting general search");
			bestPath = wishlist.bestPath(chunkLibrary);
			console.log("bestPath",bestPath);
		}

		if (bestPath) {
			var chunkWithText = optChunkId ? optChunkId : bestPath.route[0];
			doChunkText(chunkWithText, bestPath);
			doChunkChoices(chunkWithText, bestPath.choiceDetails);
		} else {
			Display.addStoryText("[Ran out of chunks early!]");
			doStoryBreak();
			endScene();
		}
	}

	var doChunkText = function(chunkId, bestPath) {
		var chunk = chunkLibrary.get(chunkId);

		// Handle effects
		handleEffects(chunk);

		// Get and show text for that item.
		// var text = Request.getText(nextItem.content);
		var chunkForText = chunk;
		var routePos = 0;
		while (!chunkForText.content) {
			routePos += 1;
			var nextChunkId = bestPath.route[routePos];
			chunkForText = chunkLibrary.get(nextChunkId);
			if (chunkForText) {
				if (chunkForText.choices) {
					continueScene(nextChunkId);
					return;
				} else {
					handleEffects(chunkForText);
				}
			} else {
				throw new Error("We started with chunk '" + chunkId + "' and it had no content, so we tried to recurse through bestPath, but did not find anything in the path with content. bestPath was:", bestPath);
			}
		}

		var text = Templates.render(chunkForText);
		Display.addStoryText(text);
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