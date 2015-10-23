/* global requirejs */

requirejs.config({
	paths: {
		"domReady": "../lib/domReady",
		"text": "../lib/text",
		"Display": "Display"
	}
});

requirejs(["Display", "domReady!"], function(Display) {
	console.log("main.js loaded.");

	Display.init();
	Display.showFrame();
});
