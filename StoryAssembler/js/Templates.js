/* 	Display Module

	This module handles showing stories in the UI, and responding to user events.
*/

/* global define */

define(["underscore", "util", "text!../data/FrameTemplates.json"], function(underscore, util, FrameTemplates) {
	"use strict";

	var frameTemplates = JSON.parse(FrameTemplates);

	var testCondition = function(condition) {
		return condition;
	}

	var evaluateConditions = function(items) {
		var returnItems = [];
		items.forEach(function(item) {
			if (item.conditions) {
				for (var i = 0; i < item.conditions.length; i++) {
					var conditionIsTrue = testCondition(item.conditions[i]);
					if (!conditionIsTrue) return; // continue to next item
				}
			}
			// If we haven't rejected this item, save it.
			returnItems.push(util.clone(item));
		});
		return returnItems;
	}

	var sortByOrder = function(steps) {
		// Convert special tokens to numeric values, and make sure every chunk has a numeric order.
		for (var i = 0; i < steps.length; i++) {
			var thisOrder = steps[i].order;
			if (thisOrder === "first") {
				steps[i].order = Number.NEGATIVE_INFINITY;
			} else if (thisOrder === "last") {
				steps[i].order = Number.POSITIVE_INFINITY;
			} else if (thisOrder === undefined) {
				steps[i].order = 0;
			}
		}

		// Sort by order.
		steps = underscore.sortBy(steps, "order");
		return steps;
	}

	var toScenePlan = function() {
		console.log("this", this);
		console.assert(util.isArray(this.frames), "Scene templates must have a 'frames' array.");
		var plan = {};
		plan.name = this.name;
		plan.frames = util.clone(this.frames);
		plan.frames = sortByOrder(plan.frames);
		plan.frames = evaluateConditions(plan.frames);
		return plan;
	}

	var toFramePlan = function() {
		console.log("this", this);
		console.assert(util.isArray(this.chunkRequests), "Frame templates must have a 'chunkRequests' array.");
		var plan = {};
		// plan.name = this.name;
		plan.chunks = util.clone(this.chunkRequests);
		plan.chunks = sortByOrder(plan.chunks);
		plan.chunks = evaluateConditions(plan.chunks);
		plan.choices = this.choices;
		return plan;
	}

	var loadFrame = function(id) {
		var template = frameTemplates[id];
		if (!template) {
			template = {};
			template.chunkRequests = [];
			template.chunkRequests.push({"text": "(" + id + ")"});
		}
		template.toPlan = toFramePlan;
		return template;
	}

	var loadScene = function(obj) {
		var template = JSON.parse(obj);
		template.toPlan = toScenePlan;
		return template;
	}

	return {
		loadScene: loadScene,
		loadFrame: loadFrame
	}

});