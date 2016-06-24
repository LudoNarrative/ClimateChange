/* Implements a Request for StoryAssembler.

A Request is a simple object explaining how to find a path leading to a chunk that will satisfy it.

Requests can be for a chunk with a particular ID, or for a chunk that makes a particular condition true. See the Condition module for a definition of how conditions should be formed.

*/

define(["Condition"], function(Condition) {

	var byId = function(id) {
		return {
			type: "id",
			val: id
		}
	}

	var byGoto = function(id) {
		return {
			type: "goto",
			val: id
		}
	}

	var byCondition = function(condition) {
		// If an invalid condition is passed in, calling the Condition.parts() function below will throw an error.
		// We don't actually care about the value of the parsed result in this case, however; just that it's not invalid.
		Condition.parts(condition);
		return {
			type: "condition",
			val: condition
		}
	}

	return {
		byId: byId,
		byGoto: byGoto,
		byCondition: byCondition
	}
});	