/* global requirejs */

requirejs.config({
	paths: {
		"domReady": "../lib/domReady",
		"text": "../lib/text",

		"underscore": "../lib/underscore-min",

		"util": "util",

		"Display": "Display",
		"Templates": "Templates"
	}
});

requirejs(["Display", "Templates", "text!../data/sampleSceneTemplate.json", "domReady!"], function(Display, Templates, sampleSceneTemplate) {
	console.log("main.js loaded.");

	var handleSelection = function(responseFrameId) {
		Display.clearAll();
		processFrame(responseFrameId);
		doNextFrame();
	}

	var processFrame = function(frameId) {
		var frameTemplate = Templates.loadFrame(frameId);
		var framePlan = frameTemplate.toPlan();
		framePlan.chunks.forEach(function(chunk) {
			Display.addStory(chunk);
		});
		if (framePlan.choices) {
			Display.showChoices(framePlan.choices, handleSelection);
		}
	}

	var endScene = function() {
		Display.addStory({"text": "End of scene!"});
	}

	var doNextFrame = function() {
		if (scenePosition >= scenePlan.frames.length) {
			endScene();
			return;
		}
		var frame = scenePlan.frames[scenePosition];
		console.log("frame", frame);
		scenePosition++;
		processFrame(frame.id);	
	}

	// Load scene and handle first frame.
	Display.init();
	var sceneTemplate = Templates.loadScene(sampleSceneTemplate);
	var scenePlan = sceneTemplate.toPlan();
	console.log("scenePlan", scenePlan);
	var scenePosition = 0;
	doNextFrame();

});
