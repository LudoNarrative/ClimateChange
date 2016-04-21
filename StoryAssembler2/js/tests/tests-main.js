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
      "BestPath": "../../js/BestPath",
    	"util": "../../js/util"
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

requirejs(["QUnit", "StateTests", "RequestTests", "WantTests", "WishlistTests", "ChunkLibraryTests", "BestPathTests", "domReady!"], function(QUnit, StateTests, RequestTests, WantTests, WishlistTests, ChunkLibraryTests, BestPathTests) {
	console.log("SA2 tests-main.js loaded.");

	StateTests.run();
	RequestTests.run();
	WantTests.run();
	WishlistTests.run();
	ChunkLibraryTests.run();
  BestPathTests.run();

	QUnit.load();
	QUnit.start();

});
