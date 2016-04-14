/* global requirejs */

/*
Some helpful QUnit syntaxes.
https://qunitjs.com/cookbook/

assert.ok(true) --> fails if param is not true
assert.deepEqual(actual, expected) --> === (works on objects, too)
(also notOk, notDeepEqual, etc.


*/

requirejs.config({
	paths: {
		"domReady": "../../lib/domReady",
		"QUnit": "../../lib/qunit-1.23.1",
    	"Condition": "../../js/Condition",
    	"Request": "../../js/Request",
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

requirejs(["QUnit", "StateTests", "RequestTests", "WantTests", "domReady!"], function(QUnit, StateTests, RequestTests, WantTests) {
	console.log("SA2 tests-main.js loaded.");

	StateTests.run();
	RequestTests.run();
	WantTests.run();

	QUnit.load();
	QUnit.start();

});
