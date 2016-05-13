/* 	Display Module

	This module handles showing stories in the UI, and responding to user events.
*/

/* global define */

define([], function() {
	"use strict";

	/* PRIVATE FUNCTIONS AND VARIABLES */
	var showUnavailableChoices = true;

	var clickHandler;

	// Create and return an HTML element of a given type with the given content.
	var makeEl = function(type, content, elClass) {
		var el = document.createElement(type);
		el.innerHTML = content;
		if (elClass) el.classList.add(elClass);
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

	// Add some story text to the story window.
	var addStoryText = function(text) {
		var el = makeEl("span", text, "chunk");
		document.getElementById("storyArea").appendChild(el);
	}

	// Add a choice to the choice window.
	var addChoice = function(choice) {
		var el = makeEl("div", choice.text, "choice");
		if (!choice.cantChoose) {
			el.onclick = function() {
				clickHandler(choice);
			}
		} else {
			if (!showUnavailableChoices) return;
			el.classList.add("unavailableChoice");
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

	var showDiagnostics = function(bestPath, wishlist) {
		console.log("!")
		var diagEl = document.getElementById("diagnostics");
		if (!diagEl) {
			diagEl = makeEl("div", "");
			diagEl.id = "diagnostics";
			document.getElementsByTagName('body')[0].appendChild(diagEl);
		}
		diagEl.innerHTML = "";

		var pathEl = makeEl("div", "<div class='dHeader'>Best Path:</div>");
		var pathSteps = makeEl("div", "", "pathSteps");
		if (bestPath && bestPath.route) {
			bestPath.route.forEach(function(node, pos) {
				var arrow = pos < bestPath.route.length-1 ? " -> " : "";
				var step = makeEl("span", node + arrow, "pathStep");
				if (pos === 0) {
					step.classList.add("firstPathStep");
				}
				pathSteps.appendChild(step);
			});
		} else {
			pathSteps.innerHTML = "No Path";
		}
		pathEl.appendChild(pathSteps);
		diagEl.appendChild(pathEl);
		var satisfiesList = [];
		if (bestPath && bestPath.satisfies) {
			satisfiesList = bestPath.satisfies.map(function(item){
				return item.val;
			});
			var satisfiesEl = makeEl("div", "This path would satisfy the highlighted Wants below.", "pathExpl");
			pathEl.appendChild(satisfiesEl);
		}

		var wishlistEl = makeEl("div", "<div class='dHeader'>Wishlist Is Now:</div>");
		var wishlistArr = wishlist.wantsAsArray();
		wishlistArr.forEach(function(want) {
			var wantEl = makeEl("div", want.val, "wlWant");
			if (satisfiesList.indexOf(want.val) >= 0) {
				wantEl.classList.add("matchedWant");
			}
			wishlistEl.appendChild(wantEl);
		})
		diagEl.appendChild(wishlistEl);
	}

	// PUBLIC INTERFACE
	return {
		init: init,
		clearAll: clearAll,
		addStoryText: addStoryText,
		addChoice: addChoice,
		showDiagnostics: showDiagnostics
	}
})