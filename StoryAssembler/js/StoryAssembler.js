/* StoryAssembler Module

Handles the core loop of running a StoryAssembler story.
*/

/* global define */

define(["Display", "Templates"], function(Display, Templates) {
	"use strict";

	var scenePosition = 0;
	var sceneTemplate;
	var scenePlan;

	// Begins running a scene with the given ID.
	var beginScene = function(sceneId) {
		scenePosition = 0;
		Display.init();
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
		processFrame(frame.id);	
		scenePosition++;
	}

	// Takes a frame, renders all its content (including choices if any) and shows it in the UI.
	var processFrame = function(frameId) {
		var frameTemplate = Templates.loadFrame(frameId);
		var framePlan = frameTemplate.toPlan();
		Display.showChunks(framePlan.chunks);
		if (framePlan.choices) {
			Display.showChoices(framePlan.choices, handleSelection);
		}
	}

	// Deals with the player selecting a choice.
	var handleSelection = function(responseFrameId) {
		Display.clearAll();
		processFrame(responseFrameId);
		doNextFrame();
	}

	// Show an indicator that the scene is over.
	var endScene = function() {
		Display.showChunks([{"text": "End of scene!"}]);
	}

	// PUBLIC INTERFACE
	return {
		beginScene: beginScene
	}

});