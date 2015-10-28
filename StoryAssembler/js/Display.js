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
	var addChoice = function(choiceText, responseFrame) {
		var el = makeEl("div", choiceText);
		el.classList.add("choice");
		el.onclick = function() {
			clickHandler(responseFrame);
		}
		document.getElementById("choiceArea").appendChild(el);
	}

	/* PUBLIC-FACING FUNCTIONS */

	// Set up the Display module to begin showing stories.
	var init = function() {
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

	var showChunks = function(chunks) {
		chunks.forEach(function(chunk) {
			addStoryChunk(chunk.text);
		})
	}

	var showChoices = function(choices, _clickHandler) {
		clickHandler = _clickHandler;
		choices.forEach(function(choice) {
			addChoice(choice.text, choice.responseFrame);
		});
	}

	return {
		init: init,
		clearAll: clearAll,
		showChunks: showChunks,
		showChoices: showChoices
	}
})