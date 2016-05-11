/* 	Templates Module

Allows including inline templating to vary text based on the State.

*/

/* global define */

define(["util"], function(util) {
	"use strict";

	var State;
	var init = function(_State) {
		State = _State;
	}

	var templates = {
		"rnd": function(params, text) {
			// {rnd|one|of|these}
			if (params.length === 0) {
				console.error("Template command 'rnd' must have at least one param, in text '" + text + "'.");
				return "(rnd)";
			}
			var rNum = util.randomNumber(params.length) - 1;
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

		// If we just have a single word, and it's not a recognized command, assume we want to print a value from the state.
		if (texts.length === 1 && !templates[texts[0]]) {
			return State.get(texts[0]);
		}

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
	var render = function(chunk) {
		var txt = chunk.content;
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
		// if (speaker && speaker.attributes) {
		// 	if (speaker.attributes.indexOf("shy") >= 0) {
		// 		txt = TextChanger.shy(txt);
		// 	}
		// }

		return txt;
	}

	// PUBLIC INTERFACE
	return {
		init: init,
		render: render,
		addTemplateCommand: addTemplateCommand
	}

});