/* global requirejs */

requirejs.config({
	paths: {
		"domReady": "../../lib/domReady",
		"QUnit": "../../lib/qunit-1.23.1",
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

requirejs(["QUnit", "StateTests", "domReady!"], function(QUnit, StateTests) {
	console.log("SA2 tests-main.js loaded.");

	StateTests.run();

	QUnit.load();
    QUnit.start();

});
