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
		"Condition": "Condition",
		"Request": "Request",
		"Want": "Want"
		// "TextChanger": "TextChanger"
	}
});

requirejs(["State", "Want", "Display", "domReady!"], function(State, Want, Display) {
	console.log("SA2 main.js loaded.");

	Display.init(function(){}); // Click handler will go here.

	var sampleWishlist = [];
	sampleWishlist.push(Want.create({
		request: "introduceFriend eq true",
		order: "first",
		mandatory: true
	}), Want.create({
		id: "epilogue",
		order: "last"
	}));

});
