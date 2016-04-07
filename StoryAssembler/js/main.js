/* global requirejs */

requirejs.config({
	paths: {
		"domReady": "../lib/domReady",
		"text": "../lib/text",

		"underscore": "../lib/underscore-min",

		"util": "util",

		"StoryAssembler": "StoryAssembler",
		"Display": "Display",
		"Templates": "Templates",
		"Chunks": "Chunks",
		"State": "State",
		"TextChanger": "TextChanger"
	}
});

requirejs(["StoryAssembler", "State", "domReady!"], function(StoryAssembler, State) {
	console.log("main.js loaded.");

	// Load scene and handle first frame.
	var characters = {
		"Emma": {
			displayName: "Emma",
			attributes: ["kind", "shy"]
		},
		"Mel": {
			displayName: "Mel",
			attributes: []
		}
	};
	State.set("knowCareer", 0);
	StoryAssembler.beginScene("BestFriend", characters);

});
