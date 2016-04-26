/* Validator for StoryAssembler.
*/

define(["util"], function(util) {

	// Verifies that an object has the fields specified and only those fields; throws a descriptive error otherwise.
	var check = function(_obj, reqFields, optFields) {
		var obj = util.clone(_obj) || {};
		var missingFields = [];
		reqFields.forEach(function(field) {
			if (obj[field] === undefined) {
				missingFields.push(field);
			}
			delete obj[field];
		});
		if (missingFields.length > 0) {
			throw new Error("Couldn't find required field(s) " + missingFields.join(", "));
		}

		optFields.forEach(function(field) {
			delete obj[field];
		});

		// Ensure we don't have any extra fields
		var remainingKeys = Object.keys(obj);
		if (remainingKeys.length > 0) {
			throw new Error("Unrecognized field(s) " + remainingKeys.join(", "));
		}
	}

	return {
		check: check
	}
});		