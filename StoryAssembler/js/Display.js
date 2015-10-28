/* 	Display Module

	This module handles showing stories in the UI, and responding to user events.
*/

/* global define */

define([], function() {
	"use strict";

	/* PRIVATE FUNCTIONS AND VARIABLES */

	var clickHandler;

	// Create and return an HTML element of a given type with the given content.
	var makeEl = function(type, content) {
		var el = document.createElement(type);
		el.innerHTML = content;
		return el;
	}

	// Create a basic UI in the DOM to show story frames: a story area and a choice area.
	var makeUI = function() {
		var el;
		el = makeEl("div", "");
		el.id = "storyArea";
		document.getElementsByTagName('body')[0].appendChild(el);
		el = makeEl("div", "");
		el.id = "choiceArea";
		document.getElementsByTagName('body')[0].appendChild(el);
	}

	// Add a "chunk" of story to the story window.
	var addStoryChunk = function(chunkContent) {
		var el = makeEl("span", chunkContent);
		el.classList.add("chunk");
		document.getElementById("storyArea").appendChild(el);
	}

	// Add a choice to the choice window.
	var addChoice = function(choice) {
		var el = makeEl("div", choice.text);
		el.classList.add("choice");
		el.onclick = function() {
			clickHandler(choice.responseFrame);
		}
		document.getElementById("choiceArea").appendChild(el);
	}

	/* PUBLIC-FACING FUNCTIONS */

	// Set up the Display module to begin showing stories.
	var init = function(_clickHandler) {
		clickHandler = _clickHandler;
		if (!document.getElementById("storyArea")) {
			makeUI();
		} else {
			clearAll();
		}
	}

	// Remove all content from the UI.
	var clearAll = function() {
		document.getElementById("storyArea").innerHTML = "";
		document.getElementById("choiceArea").innerHTML = "";
	}

	var addStoryText = function(text) {
		addStoryChunk(text);
	}

	return {
		init: init,
		clearAll: clearAll,
		addStoryText: addStoryText,
		addChoice: addChoice
	}
})