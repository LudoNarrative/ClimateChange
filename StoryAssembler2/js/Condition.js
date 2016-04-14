/* Implements a Condition, a string representing a valid query on the State.

	Currently handles condition strings in the form "PARAM op VALUE", "TRUE", or "FALSE".
	"op" is not case sensitive and can be one of the values defined below.

*/

define([], function() {

	var ops = ["eq", "neq", "gte", "lte", "gt", "lt"];

	var parts = function(condition) {
		// coerce to string
		condition = "" + condition; 

		// tokenize, getting an array of tokens separated by whitespace.
		var conditionParts = condition.replace(/\s\s+/g, " ").split(" ");

		if (conditionParts.length !== 3) {
			if (conditionParts[0].toLowerCase() === "true") {
				return {
					op: "forceTrue",
				}
			} else if (conditionParts[0].toLowerCase() === "false") {
				return {
					op: "forceFalse",
				}
			} else {
				throw new Error("Expected condition in the form 'PARAM OP VALUE' but saw '" + condition + "' which seems to have " + conditionParts.length + " parts.");
			}
		}
		var param = conditionParts[0];
		var op = conditionParts[1].toLowerCase();
		var value = conditionParts[2];
		if (value === "true") value = true;
		if (value === "false") value = false;

		if (ops.indexOf(op) < 0) {
			throw new Error("Found invalid op '" + op + "' in condition '" + condition + "' (valid ops are: " + ops.join(", ") + ")");
		}

		return {
			param: param,
			op: op,
			value: value
		}
	}


	return {
		parts: parts
	}
});	