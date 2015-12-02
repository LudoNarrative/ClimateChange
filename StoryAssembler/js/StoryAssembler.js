/* StoryAssembler Module

Handles the core loop of running a StoryAssembler story.
*/

/* global define */

define(["Display", "Templates", "Chunks", "State"], function(Display, Templates, Chunks, State) {
	"use strict";

	var scenePosition = 0;
	var sceneTemplate;
	var scenePlan;
	var characters; // A dictionary of all valid characters for this scene, with keys "displayName" and "attributes".
	var chunkSpeaker;
	var choiceSpeaker;

	// Begins running a scene with the given ID.
	var beginScene = function(sceneId, charArray) {
		scenePosition = 0;
		Display.init(handleSelection);
		characters = charArray || {};
		sceneTemplate = Templates.loadScene(sceneId);
		scenePlan = sceneTemplate.toPlan();
		doNextFrame();
	}

	// Handle the next frame request in the scene plan.
	var doNextFrame = function() {
		if (scenePosition >= scenePlan.frames.length) {
			endScene();
			return;
		}
		var frame = scenePlan.frames[scenePosition];
		handleEffects(frame);
		processFrame(frame.id);	
		scenePosition++;
	}

	// Takes a frame, renders all its content (including choices if any) and shows it in the UI.
	var processFrame = function(frameId) {
		var processResults = {};
		var frameTemplate = Templates.loadFrame(frameId);
		var framePlan = frameTemplate.toPlan();

		// Update speakers, if the plan provides this info. Speakers are assumed to remain the same until/unless updated.
		if (framePlan.chunkSpeaker) {
			if (!characters[framePlan.chunkSpeaker]) {
				throw new Error("Tried to set chunkSpeaker to '" + framePlan.chunkSpeaker + "' but this is not a registered character.");
			}
			chunkSpeaker = framePlan.chunkSpeaker;
		}
		if (framePlan.choiceSpeaker) {
			if (!characters[framePlan.choiceSpeaker]) {
				throw new Error("Tried to set choiceSpeaker to '" + framePlan.choiceSpeaker + "' but this is not a registered character.");
			}
			choiceSpeaker = framePlan.choiceSpeaker;
		}

		framePlan.chunks.forEach(function(chunk) {
			handleEffects(chunk);
			var renderedChunk = Chunks.render(chunk, characters[chunkSpeaker]);
			Display.addStoryText(renderedChunk);
		})
		if (framePlan.choices) {
			framePlan.choices.forEach(function(choice) {
				choice.text = Chunks.render(choice, characters[choiceSpeaker]);
				Display.addChoice(choice);
			});
			processResults.frameChoices = framePlan.choices;
		} 
		return processResults;
	}

	var handleEffects = function(unit) {
		if (!unit.effects) return;
		unit.effects.forEach(function(effect) {
			State.change(effect);
		});
	}

	// Deals with the player selecting a choice.
	var handleSelection = function(choice) {
		// Handle any effects of the choice
		handleEffects(choice);
		Display.clearAll();
		if (choice.responseFrame) {
			// If this frame provides more valid choices, we show it and wait for another user choice selection.
			if (Templates.isFramePrimary(choice.responseFrame)) {
				Display.clearAll();
				Display.addStoryText("Error: Can only jump to a 'secondary' frame, not to another point in a scene plan.");
				return;
			}
			var processResults = processFrame(choice.responseFrame);
		} else {
			// If not, we're done with this frame; move on to the next one.
			doNextFrame();
		}
	}

	// Show an indicator that the scene is over.
	var endScene = function() {
		Display.addStoryText("End of scene!");
	}

	// PUBLIC INTERFACE
	return {
		beginScene: beginScene
	}

});