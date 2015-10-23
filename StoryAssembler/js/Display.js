/* 	Display Module

	This module handles showing stories in the UI, and responding to user events.
*/

/* global define */

define(["text!../data/sampleChoiceFrame.json"], function(sampleChoiceFrame) {
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
		clearAll();

		var frame = JSON.parse(sampleChoiceFrame);

		frame.chunks.forEach(function(chunk) {
			addStoryChunk(chunk.text);
		});

		frame.choices.forEach(function(choice) {
			addChoice(choice.text);
		});

	}

	return {
		init: init,
		clearAll: clearAll,
		showFrame: showFrame
	}
})