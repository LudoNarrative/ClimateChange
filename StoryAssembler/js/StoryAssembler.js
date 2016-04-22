/* Main StoryAssembler Module.
*/

define(["Display", "Request", "Templates"], function(Display, Request, Templates) {

	var chunkLibrary;
	var State;
	var wishlist;
	var beginScene = function(_wishlist, _chunkLibrary, _State) {
		chunkLibrary = _chunkLibrary;
		State = _State;
		wishlist = _wishlist;
		
		Display.init(handleChoiceSelection);
		Templates.init(State);
		continueScene();
	}

	var continueScene = function() {
		// Pick an item from the wishlist.
		var bestPath = wishlist.bestPath(chunkLibrary);
		// var allPaths = wishlist.allPaths(chunkLibrary);
		// wishlist.pathsToStr(allPaths);
		if (bestPath) {
			var nextStep = bestPath.route[0];
			doChunk(nextStep);
		} else {
			Display.addStoryText("[Ran out of chunks early!]");
			doStoryBreak();
			endScene();
		}
	}

	var doChunk = function(chunkId) {
		var chunk = chunkLibrary.get(chunkId);

		// Handle effects
		handleEffects(chunk);

		// Get and show text for that item.
		// var text = Request.getText(nextItem.content);
		var text = Templates.render(chunk);
		Display.addStoryText(text);

		// Handle choices
		if (chunk.choices) {
			chunk.choices.forEach(function(choice) {
				// TODO: What to do about choices that can't be met? Remove whole Chunk from consideration? Remove just that choice?
				// TODO: Our path needs to save which node we found that met the conditions for a choice, so we know what text to print here.
				var choiceText = choice.val;
				Display.addChoice({text: choiceText, chunkId: choice.val});
			});
		} else if (wishlist.wantsRemaining() > 0) {
			// doStoryBreak();
			Display.addChoice({text: "Continue"});
		} else {
			doStoryBreak();
			endScene();
		}

	}

	var handleChoiceSelection = function(choice) {
		Display.clearAll();
		if (choice.chunkId) {
			doChunk(choice.chunkId);
		} else {
			continueScene();
		}
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