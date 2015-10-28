/* global requirejs */

requirejs.config({
	paths: {
		"domReady": "../lib/domReady",
		"text": "../lib/text",
		"Display": "Display"
	}
});

requirejs(["Display", "text!../data/sampleChoiceFrame.json", "domReady!"], function(Display, sampleChoiceFrame) {
	console.log("main.js loaded.");

	var frame = JSON.parse(sampleChoiceFrame);	

	Display.init();
	Display.showFrame(frame);
});
