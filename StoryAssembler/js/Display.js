/* 	Display Module

	This module handles showing stories in the UI, and responding to user events.
*/

/* global define */

define([], function() {
	"use strict";

	/* PRIVATE FUNCTIONS AND VARIABLES */

	var makeEl = function(type, content) {
		var el = document.createElement(type);
		el.innerHTML = content;
		return el;
	}

	var makeUI = function() {
		var el;
		el = makeEl("div", "");
		el.id = "storyArea";
		document.getElementsByTagName('body')[0].appendChild(el);
		el = makeEl("div", "");
		el.id = "choiceArea";
		document.getElementsByTagName('body')[0].appendChild(el);
	}

	var addStoryChunk = function(chunkContent) {
		var el = makeEl("span", chunkContent);
		el.classList.add("chunk");
		document.getElementById("storyArea").appendChild(el);
	}

	var addChoice = function(choiceText) {
		var el = makeEl("div", choiceText);
		el.classList.add("choice");
		document.getElementById("choiceArea").appendChild(el);
	}

	/* PUBLIC-FACING FUNCTIONS */

	var init = function() {
		makeUI();
	}

	var clearAll = function() {
		document.getElementById("storyArea").innerHTML = "";
		document.getElementById("choiceArea").innerHTML = "";
	}

	var showFrame = function() {
		// Test this
		clearAll();
		addStoryChunk("First sentence of a story. ");
		addStoryChunk("Second sentence of a story. ");
		addChoice("Option #1");
		addChoice("Option #2");

	}

	return {
		init: init,
		clearAll: clearAll,
		showFrame: showFrame
	}
})