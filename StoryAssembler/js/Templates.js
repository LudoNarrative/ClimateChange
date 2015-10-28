/* 	Display Module

	This module handles showing stories in the UI, and responding to user events.
*/

/* global define */

define(["underscore", "util", "text!../data/SceneTemplates.json", "text!../data/FrameTemplates.json"], function(underscore, util, SceneTemplates, FrameTemplates) {
	"use strict";

	var frameTemplates = JSON.parse(FrameTemplates);
	var sceneTemplates = JSON.parse(SceneTemplates);

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

	var toPlan = function(template, field) {
		console.assert(util.isArray(template[field]), "Scene templates must have a '" + field + "' array.");
		var plan = {};
		plan[field] = util.clone(template[field]);
		plan[field] = sortByOrder(plan[field]);
		plan[field] = evaluateConditions(plan[field]);
		if (field === "chunks") {
			plan.choices = template.choices;
		} else if (template.choices) {
			throw new Error("Choices can only appear in a Frame plan, not a Scene plan.");
		}
		return plan;
	}

	var makeMissing = function(id, field) {
		var missingItem = {};
		if (field === "chunks") {
			missingItem.text =  "(" + id + ")";
		} else if (field === "frames") {
			missingItem.id = "MissingFrameTemplate";
		}
		return missingItem;
	}

	var loadTemplate = function(id, templateSource, itemField) {
		var template = templateSource[id];
		if (!template || !template[itemField]) {
			template = {};
			template[itemField] = [];
			template[itemField].push(makeMissing(id, itemField));
		}
		template.toPlan = function() {
			return toPlan(this, itemField);
		};
		return template;
	}

	var loadFrame = function(id) {
		return loadTemplate(id, frameTemplates, "chunks");
	}

	var loadScene = function(id) {
		return loadTemplate(id, sceneTemplates, "frames");
	}

	return {
		loadScene: loadScene,
		loadFrame: loadFrame
	}

});