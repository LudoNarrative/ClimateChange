/* global test */
"use strict";
define(["../Want"], function(Want) {
	
	var run = function() {
		test("wants", function( assert ) {
			var want = Want.create({
				request: "introduceFriend eq true",
				order: "first",
				mandatory: true
			});
			assert.deepEqual(want.content, "R:{introduceFriend eq true}", "request-based want should have a valid content field");
			assert.deepEqual(want.mandatory, true, "want should preserve creation parameters");

			var want2 = Want.create({
				chunkId: "epilogue",
				order: 2
			});
			assert.deepEqual(want2.content, "R:epilogue", "chunkId-based want should have a valid content field");
			assert.notDeepEqual(want.id, want2.id, "wants should have unique ids.");

			assert.throws(function(){Want.create({})}, "should reject invalid want definition");
			assert.throws(function(){Want.create({id: "test", foo: "bar"})}, "should reject invalid want params");

		});
	}

	return {
		run: run
	}
});