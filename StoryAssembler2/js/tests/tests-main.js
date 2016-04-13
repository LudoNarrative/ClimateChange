/* global requirejs */

requirejs.config({
	paths: {
		"domReady": "../../lib/domReady",
		// "text": "../lib/text",
		"QUnit": "../../lib/qunit-1.23.1",
		"Tests": "tests",

		// "underscore": "../lib/underscore-min",

		// "util": "util",

		// "StoryAssembler": "StoryAssembler",
		// "Display": "Display",
		// "Templates": "Templates",
		// "Chunks": "Chunks",
		// "State": "State",
		// "TextChanger": "TextChanger"
	},
	shim: {
       "QUnit": {
           exports: "QUnit",
           init: function() {
               QUnit.config.autoload = false;
               QUnit.config.autostart = false;
           }
       } 
    }
});

requirejs(["QUnit", "Tests", "domReady!"], function(QUnit, Tests) {
	console.log("SA2 tests-main.js loaded.");

	// Load scene and handle first frame.
	// State.set("knowCareer", 12);
	// Display.init(function(){});
	// Display.addStoryText("Display module working!");
	// console.log("knowCareer should be 12: ", State.get("knowCareer"));
	// StoryAssembler.beginScene("BestFriend", characters);
	Tests.run();

	QUnit.load();
    QUnit.start();

});
