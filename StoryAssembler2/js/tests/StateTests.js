"use strict";
define(["../State"], function(State) {
	
	var run = function() {
		test( "getting and setting", function( assert ) {
			State.set("testVal", 5);
			assert.ok( State.get("testVal") == 5, "Passed!" );
		});
	}

	return {
		run: run
	}
});