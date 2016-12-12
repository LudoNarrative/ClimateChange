/* global test, QUnit */
"use strict";
define(["../Templates", "../State"], function(Templates, State) {
	
	var run = function() {
		QUnit.module( "Templates Module tests" );
		test("templating", function( assert ) {

			Templates.init(State);

			// Add two template commands
			Templates.addTemplateCommand("testNoParams", function(params, text) {
				return "resultOne";
			});
			Templates.addTemplateCommand("testTwoParams", function(params, text) {
				if (params.length !== 2) {
					console.error("Template command 'testTwoParams' must have exactly two params, in text '" + text + "'.");
					return "(testTwoParams)";
				}
				if (true) {
					return params[0]
				} else {
					return params[1];
				}
			});

			// Shorthand function
			var render = function(txt) { return Templates.render(txt); }

			// Tests
			assert.deepEqual(render("some text"), "(speaker): some text", "text without templates is unchanged");
			assert.deepEqual(render("some {testNoParams} text"), "(speaker): some resultOne text", "cmd without params");
			assert.deepEqual(render("{testNoParams} at start"), "(speaker): resultOne at start", "templates at start of string");
			assert.deepEqual(render("at end is {testNoParams}"), "(speaker): at end is resultOne", "templates at end of string");
			assert.deepEqual(render("some \\{testNoParams\\} text"), "(speaker): some \\{testNoParams\\} text", "escaping braces");
			assert.deepEqual(render("\\{testNoParams\\} at start"), "(speaker): \\{testNoParams\\} at start", "escaping braces at start of string doesn't work");
			assert.deepEqual(render("this is {messed {up"), "(speaker): this is {messed {up", "malformed should be skipped");
			assert.deepEqual(render("lots of {testTwoParams|fun|asdf} {testTwoParams|exciting|xcvb} {testNoParams} stuff"), "(speaker): lots of fun exciting resultOne stuff", "test with multiple params");
			assert.deepEqual(render("{testTwoParams|paral|x}{testTwoParams|lel|y}"), "(speaker): parallel", "adjacent templates");
			assert.deepEqual(render("{testTwoParams|{testNoParams}|nope}"), "(speaker): ()|nope}", "nested params shuold be rejected");

			//State.change("set charName Maria");
			//assert.deepEqual(render("Hello, {charName}!"), "Hello, Maria!", "showing State value directly");

		});

	}

	return {
		run: run
	}
});			