"use strict";
define([], function() {
	
	var run = function() {
		QUnit.test( "hello test", function( assert ) {
			assert.ok( 1 == "1", "Passed!" );
		});
	}

	return {
		run: run
	}
});