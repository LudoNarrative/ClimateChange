/* 	Chunks Module

*/

/* global define */

define(["State", "TextChanger", "util"], function(State, TextChanger, util) {
	"use strict";

	var templates = {
		"rnd": function(params, text) {
			if (params.length === 0) {
				console.error("Template command 'rnd' must have at least one param, in text '" + text + "'.");
				return "(rnd)";
			}
			var rNum = util.randomInt(params.length) - 1;
			return params[rNum];
		},
		"ifState": function(params, text) {
			// {ifState|career|3|text if true|text if false}
			if (params.length !== 4) {
				console.error("Template command 'ifState' must have four params: variable, value, text if true, text if false: in text '" + text + "'.");
				return "(ifState)";
			}
			
			var varToCheck = params[0];
			var expectedVal = params[1];
			var textIfTrue = params[2];
			var textIfFalse = params[3];

			var currVal = State.get(varToCheck);
			if (currVal == expectedVal) { // Note: double equals "truthy" comparison
				return textIfTrue;
			} else {
				return textIfFalse;
			}
		},
		// "attr": function(params, text) {
		// 	if (params.length !== 3) {
		// 		console.error("Template command 'attr' must have three params: attribute to check for current speaker, text if true, text if false: in text '" + text + "'.");
		// 		return "(attr)";
		// 	}

		// 	var attToCheck = params[0];
		// 	var textIfTrue = params[1];
		// 	var textIfFalse = params[2];
		// }
	}

	var addTemplateCommand = function(cmd, func) {
		templates[cmd] = func;
	}

	// Process a single templated string in the form {command|param1|param2}
	// (Parameters are optional)
	var processTemplate = function(text) {
		// Check format is correct
		console.assert(text[0] === "{", "template '" + text + "' does not begin with curly brace.");
		console.assert(text[text.length - 1] === "}", "template '" + text + "' does not end with curly brace.");

		// strip opening/closing characters, verify no nesting, and make into an array
		var strippedText = text.slice(1, text.length - 1);

		if (strippedText.search(/[\{\}]/g) >= 0) {
			console.error("Nested params are not allowed in template '" + strippedText + "'");
			return "()";
		}

		var texts = strippedText.split("|");

		// Assume the first element is the command, and the rest are parameters
		var cmd = texts[0];
		var params = [];
		if (texts.length > 0) {
			texts.shift();
			params = texts;
		}
		if (!templates[cmd]) {
			console.error("Missing template command '" + cmd + "'. Process text '" + text + "'.");
			return "(" + cmd + ")";
		}
		if (typeof templates[cmd] !== "function") {
			console.error("Template command '" + cmd + "' is not a function! Processing text '" + text + "'.");
			return "(" + cmd + ")";
		}
		return templates[cmd](params, text);
	}

	// Returns text that's had all templates replaced by fully realized versions.
	// Format: {command|opt1|opt2|...}
	var render = function(chunk, speaker) {
		var txt = chunk.text;
		var re = /{[^}]*}/g;  // matches every pair of {} characters with contents
		var match;
		while ((match = re.exec(txt)) !== null) {
			// Reject escaped opening braces, so \{ won't count.
			if (match.index > 0 && txt[match.index - 1] === "\\") continue;

			// Replace match with rendered version.
			var matchText = match[0];
			txt = txt.replace(matchText, processTemplate(matchText));
			re = /{[^}]*}/g;
		}

		// Now that all templates have been replaced, modify the text based on state. (NLG techniques.)
		if (speaker && speaker.attributes) {
			if (speaker.attributes.indexOf("shy") >= 0) {
				txt = TextChanger.shy(txt);
			}
		}

		return txt;
	}

	var test = function() {
		addTemplateCommand("testNoParams", function(params, text) {
			return "resultOne";
		});
		addTemplateCommand("testTwoParams", function(params, text) {
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
		var expect = function(templateTxt, expectedTxt, explanation) {
			var result = render({text: templateTxt});
			if (result !== expectedTxt) {
				console.error(explanation + ": '" + templateTxt + "' became '" + result + "' instead of '" + expectedTxt + "'.");
			}
		}
		expect("some text", "some text", "text without templates fails");
		expect("some {testNoParams} text", "some resultOne text", "cmd without params fails");
		expect("{testNoParams} at start", "resultOne at start", "templates at start of string don't work");
		expect("at end is {testNoParams}", "at end is resultOne", "templates at end of string don't work");
		expect("some \\{testNoParams\\} text", "some \\{testNoParams\\} text", "escaping braces doesn't work");
		expect("\\{testNoParams\\} at start", "\\{testNoParams\\} at start", "escaping braces at start of string doesn't work");
		expect("this is {fucked {up", "this is {fucked {up", "malformed should be skipped");
		expect("lots of {testTwoParams|fun|asdf} {testTwoParams|exciting|xcvb} {testNoParams} stuff", "lots of fun exciting resultOne stuff", "test with multiple params");
		expect("{testTwoParams|paral|x}{testTwoParams|lel|y}", "parallel", "adjacent templates not working");
		expect("{testTwoParams|{testNoParams}|nope}", "()|nope}", "nested params are not yet allowed");
	}

	// PUBLIC INTERFACE
	return {
		render: render,
		addTemplateCommand: addTemplateCommand,
		test: test
	}

});