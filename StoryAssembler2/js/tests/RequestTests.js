/* global test */
"use strict";
define(["../Request"], function(Request) {
	
	var run = function() {
		test("requests", function( assert ) {
			assert.equal(Request.createWithId("alpha"), "R:alpha", "id request");
			assert.equal(Request.createWithCondition("param eq 5"), "R:{param eq 5}", "condition request");
			assert.throws(function(){Request.createWithCondition("param fakeop 5")}, "request with malformed condition");
		});
	}

	return {
		run: run
	}
});