/* Main StoryAssembler Module.

When beginScene is called, we need to pass in a defined ChunkLibrary, State, and Display module. 
*/

define(["Request", "Templates", "Want", "Wishlist", "Character"], function(Request, Templates, Want, Wishlist, Character) {

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
		Templates.init(_Character);
		continueScene();
	}

	/*
		Continues the scene.
			-optChunkId: a chunk id
			-mode: boolean, will be false if refreshing the view (to pull from whole library)
	*/
	var continueScene = function(optChunkId) {
		
		var bestPath;

		if (typeof State.get("speaker") == "undefined") { State.set("speaker", Character.getBestSpeaker(State, 1, "content")); }
		
		else { 
			/*
			//This would be used if a choiceLabel was a short-hand for the next full text node that expanded it, instead of a stand-alone utterance
			var hardcodedSpeaker = State.get("currentChoices").filter( function(choice) { return choice.chunkId == optChunkId});
			if (hardcodedSpeaker.length > 0) { State.set("speaker", hardcodedSpeaker[0].speaker); }
			else { 
				State.set("speaker", Character.getBestSpeaker(State, 2)); 
			}
			*/
			State.set("speaker", Character.getBestSpeaker(State, 1, "content"));
		}

		//Cases:
		if (optChunkId) {		//optchunkid is defined
		
			//display content field, or ground out request and display that content field (all this should happen in doChunkText)
			displayChunkText(optChunkId);

			var chunk = chunkLibrary.get(optChunkId);	//get data on our chunk to do the check below

			if (chunk.content) {	//if there was no chunk content, it already grounded out recursively and displayed with displayChunkText(), so we shouldn't redo that here
				handleEffects(chunk);			//apply this chunk's effects before running bestPath
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

				//if displayChunkText didn't populate the text or choices fully, go through and do that
				if ($("#storyArea").html() == "" || $("#choiceArea").html() == "") {	

					var chunk = chunkLibrary.get(bestPath.route[0]);

					handleFoundPath(bestPath.route[0], bestPath);
				}
				
			}
			else {
				handleNoPathFound(wishlist.wantsAsArray());
			}
			
		}

	}

	var getBestPath = function(chunkLibrary, startingPoint, tempWishlist) {		
	//this function gets best path from the starting point, or if that's not specified, does a blind search 
	//will use initial wishlist by default, but will go off passed in "tempWishlist" if necessary
		//console.log("called getBestPath with chunkLibrary: " + chunkLibrary.getKeys() + " and startingPoint: " + startingPoint);
		if (startingPoint) {
			var temp;
			if (tempWishlist) {	temp = tempWishlist.bestPath(chunkLibrary, {startAt: startingPoint}); }
			else { temp = wishlist.bestPath(chunkLibrary, {startAt: startingPoint}); }

			console.log("bestPath is: " , temp);
			return temp;
		}

		else {
			var temp 
			if (tempWishlist) { temp = tempWishlist.bestPath(chunkLibrary); }
			else { temp = wishlist.bestPath(chunkLibrary); }

			console.log("bestPath is: ", temp);
			return temp;
			//return wishlist.bestPath(chunkLibrary);
		}
	}

	//used to tell the narrative system to refresh
	var refreshNarrative = function() {
		StoryDisplay.clearText();
		displayChunkText(State.get("currentTextId"), "refresh");		//continue scene, but draw from whole library (so...refresh)

		newBestPath = getBestPath(chunkLibrary, State.get("currentTextId"));		//look for path from here
		doChunkChoices(State.get("currentTextId"), newBestPath.choiceDetails, "refresh");
	}

	//used in Diagnostics panel buttons to change a UI var (theVar) by some amount like +1 or -1 (theMod)
	var clickChangeState = function(theVar, theMod) {
		if (theMod[0] == "+") {
			State.set(theVar, State.get(theVar) + 1);
		}
		if (theMod[0] == "-") {
			State.set(theVar, State.get(theVar) - 1);
		}
		Display.setStats();					//refresh UI stat display
		refreshNarrative();					//refresh currently displayed chunk in case it's different
	}

	var displayChunkText = function(chunkId, mode) {
		var chunkSpeaker;

		mode = mode || "normal";

		var chunk = chunkLibrary.get(chunkId, mode);

		//If the chunk specifies who the speaker should be, use that. Otherwise use the speaker determined 
		//through earlier call to Character.getBestSpeaker
		if(chunk.speaker !== undefined){
			chunkSpeaker = chunk.speaker
			State.set("speaker", chunkSpeaker)
		}
		else{
			chunkSpeaker = State.get("speaker")
		}

		var text = Templates.render(chunk.content, chunkSpeaker);
		//var text = Templates.render(chunk.content, State.get("speaker")); 
		if (text !== undefined) { 							//if the chunk has text, display it
			StoryDisplay.addStoryText(text); 
		}
		else {												//if it's making a request for text to display...
			
			var contentRequestWant = Want.create({condition: "dummySetting eq true", order: "first"});		//create a temporary wishlist with that content request
			contentRequestWant.request = chunk.request;
			var tempWishlist = Wishlist.create([contentRequestWant], State);

			bestPath = getBestPath(chunkLibrary, chunkId, tempWishlist);	//grab text from request
			if (!bestPath) {								//if it still isn't known...
				bestPath = getBestPath(chunkLibrary);		//do a blind search
			}
			if (!bestPath) {								//if it's still empty, throw an error
				if (State.get('displayType') !== "editor") {
					throw new Error("Tried to get text for '" + chunkId + "' and it had no content, so we tried to recurse through bestPath, but did not find anything.");
				}
				else { endScene(true); }
			}
			else {
				doChunkText(chunkId, bestPath);		//display text from search
			}
			
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

			//TODO: not sure why we have to do this, but if the first entry in the path is the same as the current chunk (sometimes it is) force it to use the next one instead. This is a *really* weird fix and should be de-tangled / gotten rid of
			if (nextChunkId == chunkForText.id) {
				if (routePos+1 <= bestPath.route.length-1) { routePos++; }
				nextChunkId = bestPath.route[routePos];
			}

			chunkForText = chunkLibrary.get(nextChunkId);
			routePos += 1;
			if (chunkForText) {
				if (chunkForText.choices) { continueScene(nextChunkId); } 
				else {
					displayChunkText(chunkForText.id);
					doChunkChoices(chunkForText.id);
					handleEffects(chunkForText);
				}
			} else {
				throw new Error("We started with chunk '" + chunkId + "' and it had no content, so we tried to recurse through bestPath, but did not find anything in the path with content. bestPath was:", bestPath);
			}
		}
	}

	var doChunkChoices = function(chunkId, choiceDetails, mode) {

		mode = mode || "normal";		//mode can be "refresh" driven by state
		var chunk;

		if (mode == "refresh") {
			chunk = chunkLibrary.get(chunkId, "refresh");	
		}
		else {
			chunk = chunkLibrary.get(chunkId);
		}

		if (mode == "refresh") {
			StoryDisplay.clearChoices();
		}

		// Handle choices
		if (chunk.choices) {
			var choiceObjs = [];		//used to store current choiceObjs in blackboard (for graph reference)
			chunk.choices.forEach(function(choice, pos) {
				// TODO: What to do about choices that can't be met? Remove whole Chunk from consideration? Remove just that choice?

				if (typeof choice.speaker == "undefined") {		//if there's no hard-coded speaker for the choice...
					choice.speaker = Character.getBestSpeaker(State, 1, "choice");
					State.set("speaker", choice.speaker);
				}

				var choiceText = getChoiceText(choiceDetails[pos]);
				choiceText = Templates.render(choiceText, choice.speaker);		//render any grammars in there

				var choiceId = choice.val;
				if (choice.type == "condition") { 
					choiceId = choiceDetails[pos].id //if it's a condition, use the id of the one we fetched	
				}	
				
				var choiceObj = {
					text: choiceText,
					chunkId: choiceId,
					cantChoose: choiceDetails[pos].missing === true,
					persistent: choice.persistent,
					speaker: choice.speaker
				};
				choiceObjs.push(choiceObj);
				StoryDisplay.addChoice(choiceObj);
			});
			State.set("currentChoices", choiceObjs);

		// HERE: If there's a request, we should find a thing that satisfies it. We only want to go back to the wishlist (stuff below here) if this is truly a dead end.
		} else if (wishlist.wantsRemaining() > 0 && mode !== "refresh") {
			// We have finished a path. After clicking this button, since we didn't send a chunkId parameter below, the system will search for a new bestPath given the remaining wishlist items.
			StoryDisplay.addChoice({text: "Continue"});
			var choiceObj = {
				text: "Continue",
				chunkId: "unknown",
				cantChoose: false
			};
			State.set("currentChoices", [choiceObj]);

		} else if (mode !== "refresh") {
			doStoryBreak();
			State.set("currentChoices", []);
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

		if (choiceDetail.id) {		//if it has an ID, return the choiceLabel
			var chunk = chunkLibrary.get(choiceDetail.id, "refresh");
			if (chunk.available) { return chunk.choiceLabel; }

			else if (chunk.unavailableChoiceLabel) {			//if it has a label for the choice not being available , return that	
				return chunk.unavailableChoiceLabel;
			}
		} 
			
		else {		//otherwise, return empty?
			//return chunk.choiceLabel;
			return "";
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
			if (effect.indexOf("addWishlist") > -1) {		//if the effect is adding to the wishlist...
				eval("var newWant = " + effect.substring(effect.indexOf("{"), effect.indexOf("}")+1));
				wishlist.add(newWant);
			}
			else { State.change(effect); }
		});
		wishlist.removeSatisfiedWants();
		if (typeof Display !== "undefined") {			//if we're not running tests, update the storyStats on the display
			Display.setStats();
			Display.setAvatars();
		}
	}

	var doStoryBreak = function() {
		StoryDisplay.addStoryText("<br><br>");
	}

	// Show the scene is over.
	var endScene = function(assemblyFailed) {
		
		if (typeof Display !== "undefined" && State.get("displayType") !== "editor") {		//if we're not running tests, display scene outro
			Display.setSceneOutro("Chapter complete!");
		}
		else {
			if (assemblyFailed) { StoryDisplay.addStoryText("[Scene assembly failed.]");}
			else { StoryDisplay.addStoryText("[End of scene.]"); }
		}
	}

	return {
		beginScene: beginScene,
		refreshNarrative : refreshNarrative,
		clickChangeState : clickChangeState
	}
});		