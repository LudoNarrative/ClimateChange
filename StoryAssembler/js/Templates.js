/* 	Templates Module

Allows including inline templating to vary text based on the State.

*/
/* global define */

define(["util", "Condition", "State"], function(util, Condition, State) {
	"use strict";

	//var State;
	var Character;
	var currentSpeaker = "";

	var init = function(_Character) {
		//State = _State;
		Character = _Character;
	}

	/* The built-in list of templates and how they should be processed is defined in this object. addTemplateCommand() can also be called to add new ones at run-time.

	Each template command is give a function to process it, that expects two variables: an array of parameters the template was called with, and the full original template command (mostly useful for debugging if something goes wrong). 

	eg. for "{ifState|career|3|text if true|text if false}", 
	'params' will be ["career", "3", "text if true", "text if false"]
	and 'text' will be the quoted string above.

	A template function should verify that its receiving the correct params and output an error if it's not.
	*/ 
	var templates = {
		// Template to randomly print one of the given params.
		"rnd": function(params, text) {
			// {rnd|one|of|these}
			if (params.length === 0) {
				console.error("Template command 'rnd' must have at least one param, in text '" + text + "'.");
				return "(rnd)";
			}
			var rNum = util.randomNumber(params.length) - 1;
			return params[rNum];
		},
		// Template to conditionally print text.
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
		"ifStateCondition": function(params, text) {
			// {ifStateCondition|career lte 3|text if true|text if false}
			if (params.length !== 3) {
				console.error("Template command 'ifState' must have three params: statement, text if true, text if false: in text '" + text + "'.");
				return "(ifStateCondition)";
			}

			if (State.isTrue(params[0])) {
				return params[1];
			} else {
				return params[2];
			}
		},
		// Returns the name of the current speaker (which is stored in the "speaker" variable on the blackboard), using the expected 'name' property. 
		"speaker": function(params, text) {
			if (params.length !== 0) {
				console.error("Template command 'speaker' must not have any params, in text '" + text + "'.");
				return "(speaker)";
			}
			var speaker = State.get("speaker");
			if (!speaker) return "(speaker)";
			var speakerChar = Character.get(speaker);
			if (!speakerChar) return "(speaker)";
			return speakerChar.name || speaker;
		},

		//{name|protagonist}
		"name": function(params, text) {
			if (params.length !== 1) {
				console.error("Template command 'speaker' must have 1 param, in text '" + text + "'.");
				return "(speaker)";
			}
			var speakerChar = Character.get(params[0]);
			if (!speakerChar) return "(speaker)";
			return speakerChar.name || speaker;
		},
		//{nickname|protagonist}
		"nickname": function(params, text) {
			if (params.length !== 1) {
				console.error("Template command 'nickname' must have 1 param, in text '" + text + "'.");
				return "(nickname)";
			}
			var speakerChar = Character.get(params[0]);
			if (!speakerChar) return "(nickname)";
			return speakerChar.nickname || speaker;
		},
		//{ifSpeaker|protagonist|text if true|text if false}
		"ifSpeaker": function(params, text) {
			if (params.length !== 3) {
				console.error("Template 'ifSpeaker' doesn't have three params in chunk '" + text + "'.");
				return "(ifSpeaker)";
			}
			var speakerId = State.get("speaker");
			if (params[0] == speakerId) { return params[1] }
			else { return params[2] }
		},
		"convoMode": function(params, text) {
			if (params.length !==3){
				console.error("Template 'convoMode' doesn't have three params in chunk '" + text + "'.");
				return "(convoMode)";
			}
			var cMode = State.get("mode").type;
			if (cMode == params[0]) { return params[1] }
			else { return params[2] }
		},
		"showCharTrait": function(params, text) {
			if (params.length !== 0) {
				console.error("Template command 'showCharTrait' must have params, in text '" + text + "'.");
				return "(showSpeakerTrait)";
			}
		}
		// Template stub demonstrating how you might show a random character trait. Look up the current speaker, and print something based on the first found property we have code for.
		//para
		/*
		"showSpeakerTrait": function(params, text) {
			if (params.length !== 0) {
				console.error("Template command 'showSpeakerTrait' must not have any params, in text '" + text + "'.");
				return "(showSpeakerTrait)";
			}

			var speakerId = State.get("speaker");
			var char = Character.get(speakerId);
			if (char.confident) {
				return char.name + " flashes a confident smile. ";
			} else if (char.forceful) {
				return char.name + " leans forward forcefully. ";
			} else {
				return "";
			}
		}
		*/
	}

	// Add a new template command at run-time. (Probably mostly only useful for testing, or to load in template commands from an external definition file. Normally, you would add them to the "templates" object above.)
	var addTemplateCommand = function(cmd, func) {
		templates[cmd] = func;
	}

	// Process a single templated string in the form {command|param1|param2}
	// (Parameters are optional)
	// Identify the command, isolate the parameters, and call the appropriate function.
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

		// If we just have a single word, and it's not a recognized command, assume we want to print a value by this name from the State.
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

	// Main public interface. Given text with grammars, return its content with any templates rendered into fully realized text.
	var render = function(rawText, speaker, mode) {

		var currentSpeaker = speaker;
		var txt;
		if (typeof rawText == "object") { txt = rawText[0]; }		//if rawText is coming from chunk content, it's an array, otherwise string
		else { txt = rawText; }

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

		// If you wanted to do additional NLG-style processing here like analyzing a sentence and adding hedges, etc., this would be the place to modify 'txt' further before returning it.
		if (typeof txt !== "undefined" && mode !== "want") {		//if it's undefined (other systems expecting undefined, not a txt string back, so leave it if so)
			var speakerName = processTemplate("{name|" + currentSpeaker + "}");
			if (speakerName !== "(speaker)") { txt = speakerName + ": " + txt; }
			
		}

		return txt;
	}

	// PUBLIC INTERFACE
	return {
		init: init,
		render: render,
		addTemplateCommand: addTemplateCommand
	}

});