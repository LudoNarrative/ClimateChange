/* 	Templates Module

*/

/* global define */

define(["underscore", "util", "text!../data/SceneTemplates.json", "text!../data/FrameTemplates.json"], function(underscore, util, SceneTemplates, FrameTemplates) {
	"use strict";

	// Immediately load and parse external files when the module is loaded.
	var frameTemplates = JSON.parse(FrameTemplates);
	var sceneTemplates = JSON.parse(SceneTemplates);


	// Use the helper function below to return an instantiated Scene template.
	var loadScene = function(id) {
		return loadTemplate(id, sceneTemplates, "frames");
	}

	// Use the helper function below to return an instantiated Frame template.
	var loadFrame = function(id) {
		return loadTemplate(id, frameTemplates, "chunks");
	}

	// Get a specific template from the given source, making a minimally valid stand-in if it doesn't exist or is underspecified,  give it a "toPlan" function, then return it.
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

	// When run on a template, will return a plan generated from that template. Most of the magic is triggered in reifyTemplate.
	var toPlan = function(template, field) {
		var plan = {};
		plan[field] = reifyTemplate(template[field]);
		delete plan.conditions;
		if (template.choices) {
			if (field === "chunks") {
				plan.choices = reifyTemplate(template.choices);
			} else {
				throw new Error("Choices can only appear in a Frame plan, not a Scene plan.");
			}
		}
		if (template.effects) {
			plan.effects = template.effects;
		}
		return plan;
	}

	// Sorts the given field in a template into a final order, and eliminates any which do not meet the current conditions.
	var reifyTemplate = function(originalField) {
		var finalField = util.clone(originalField);
		finalField = sortByOrder(finalField);
		finalField = evaluateConditions(finalField);
		return finalField;
	}

	// Considers every object in a given field, and evaluates all of its conditions. If any are false, omit the object from the final plan. 
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

	// Stub for evaluating a single condition: right now, handles only true/false.
	var testCondition = function(condition) {
		return condition;
	}

	// When given an array of objects with a "order" key, sorts them such that any values of "first" happen at the beginning, "last" happen at the end, and any omitted order becomes 0.
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

		// Use the underscore library to do the sorting.
		steps = underscore.sortBy(steps, "order");

		return steps;
	}

	// Generate a blank Frame or Chunk that won't crash the rest of the system.
	var makeMissing = function(id, field) {
		var missingItem = {};
		if (field === "chunks") {
			missingItem.text =  "(" + id + ")";
		} else if (field === "frames") {
			missingItem.id = "MissingFrameTemplate";
		}
		return missingItem;
	}


	// PUBLIC INTERFACE
	return {
		loadScene: loadScene,
		loadFrame: loadFrame
	}

});