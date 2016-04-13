/* global requirejs */

requirejs.config({
	paths: {
		"domReady": "../lib/domReady",
		"text": "../lib/text",

		// "underscore": "../lib/underscore-min",

		// "util": "util",

		// "StoryAssembler": "StoryAssembler",
		// "Display": "Display",
		// "Templates": "Templates",
		// "Chunks": "Chunks",
		// "State": "State",
		// "TextChanger": "TextChanger"
	}
});

requirejs(["domReady!"], function() {
	console.log("SA2 main.js loaded.");

	// Load scene and handle first frame.
	// State.set("knowCareer", 0);
	// StoryAssembler.beginScene("BestFriend", characters);

});
