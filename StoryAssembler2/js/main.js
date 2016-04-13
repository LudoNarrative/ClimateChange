/* global requirejs */

requirejs.config({
	paths: {
		"domReady": "../lib/domReady",
		"text": "../lib/text",

		// "underscore": "../lib/underscore-min",

		// "util": "util",

		// "StoryAssembler": "StoryAssembler",
		"Display": "Display",
		// "Templates": "Templates",
		// "Chunks": "Chunks",
		"State": "State",
		// "TextChanger": "TextChanger"
	}
});

requirejs(["State", "Display", "domReady!"], function(State, Display) {
	console.log("SA2 main.js loaded.");

	// Load scene and handle first frame.
	State.set("knowCareer", 12);
	Display.init(function(){});
	Display.addStoryText("Display module working!");
	console.log("knowCareer should be 12: ", State.get("knowCareer"));
	// StoryAssembler.beginScene("BestFriend", characters);

});
