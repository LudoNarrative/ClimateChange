/* global requirejs */

/*
Some helpful QUnit syntaxes.
https://qunitjs.com/cookbook/

assert.ok(true) --> fails if param is not true
assert.deepEqual(actual, expected) --> === (works on objects, too)
(also notOk, notDeepEqual, etc.


*/

// TODO: Any way to avoid having to require everything twice?
requirejs.config({
	paths: {
		"domReady": "../../lib/domReady",
		"QUnit": "../../lib/qunit-1.23.1",
    	"Condition": "../../js/Condition",
    	"Request": "../../js/Request",
    	"Want": "../../js/Want",
    	"Validate": "../../js/Validate",
    	"ChunkLibrary": "../../js/ChunkLibrary",
      "State": "../../js/State",
      "Display": "../../js/Display",
      "Templates": "../../js/Templates",
      "BestPath": "../../js/BestPath",
    	"util": "../../js/util",
      "Character" : "../../js/Character",
      "underscore": "../../lib/underscore-1.8.3.min",
      "jQuery": "../../../lib/jquery-3.0.0.min",
      "jQueryUI": "../../../lib/jquery-ui.min"
	},
	shim: {
       "QUnit": {
           exports: "QUnit",
           init: function() {
               QUnit.config.autoload = false;
               QUnit.config.autostart = false;
           }
       },
       "jQueryUI": {
          export: "$",
          deps: ["jQuery"]
        }
  }


});

requirejs(["QUnit", "StateTests", "RequestTests", "WantTests", "WishlistTests", "ChunkLibraryTests", "BestPathTests", "TemplatesTest", "StoryAssemblerTests", "CharacterTests", "domReady!"], function(QUnit, StateTests, RequestTests, WantTests, WishlistTests, ChunkLibraryTests, BestPathTests, TemplatesTest, StoryAssemblerTests, CharacterTests) {
	console.log("SA2 tests-main.js loaded.");

	StateTests.run();
	RequestTests.run();
	WantTests.run();
	WishlistTests.run();
	ChunkLibraryTests.run();
  BestPathTests.run();
  TemplatesTest.run();
  StoryAssemblerTests.run();
  CharacterTests.run();

	QUnit.load();
	QUnit.start();

});
