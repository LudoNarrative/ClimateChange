/* Implements a Want for StoryAssembler.

A want is a Request with associated metadata.
*/

define(["Request"], function(Request) {

	var requiredFields = ["content"];

	var create = function(params) {
		var want = {};
		params = params || {};

		// Consume params.
		if (params.request) {
			try {
				want.content = Request.createWithCondition(params.request);
				delete params.request;
			} catch(e) {
				throw new Error("Could not create a Want with invalid condition: " + e);
			}
		}
		if (params.id) {
			try {
				want.content = Request.createWithId(params.id);
				delete params.id;
			} catch(e) {
				throw new Error("Could not create a Want with invalid id: " + e);
			}
		}
		if (params.order) {
			want.order = params.order;
			delete params.order;
		}
		if (params.mandatory) {
			want.mandatory = params.mandatory;
			delete params.mandatory;
		}

		// Ensure we have all required fields
		var missingFields = [];
		requiredFields.forEach(function(field) {
			if (want[field] === undefined) {
				missingFields.push(field);
			}
		});
		if (missingFields.length > 0) {
			throw new Error("Tried to create a new want but missing these fields: " + missingFields.join(", "));
		}

		// Ensure we don't have any extra fields
		var remainingKeys = Object.keys(params);
		if (remainingKeys.length > 0) {
			throw new Error("Tried to create a new want but could not make sense of these keys: " + remainingKeys.join(", "));
		}
		return want;
	}

	return {
		create: create
	}
});	