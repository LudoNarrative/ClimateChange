/* Implements a Request for StoryAssembler.

A Request is a string explaining how to find a path leading to a chunk that will satisfying this request.

A valid Request string should always begin with the two characters "R:"

Next should be either a Condition, or a chunk ID. Conditions should be wrapped in curly braces. A condition is in the format defined in the State.isTrue function, in the format PARAM op VALUE, such as:
	metMother eq true

Some valid request strings:
	"R:someChunkId"
	"R:{metYourMother eq true}"

*/

define(["Condition"], function(Condition) {

	var requestPrefix = "R:";

	var createWithId = function(id) {
		// Check that this ID matches one we know about.
		return requestPrefix + id;
	}
	var createWithCondition = function(condition) {
		// If an invalid condition is passed in, will throw an error.
		// We don't actually care about the parsed result in this case.
		Condition.parts(condition);
		return requestPrefix + "{" + condition + "}";
	}

	return {
		createWithId: createWithId,
		createWithCondition: createWithCondition
	}
});	