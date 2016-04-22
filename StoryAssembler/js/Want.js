/* Implements a Want for StoryAssembler.

A want is a Request with associated metadata.
*/

define(["Request", "Validate", "util"], function(Request, Validate, util) {

	var requiredFields = [];
	var optionalFields = ["condition", "chunkId", "order", "mandatory"];

	var create = function(want) {
		Validate.check(want, requiredFields, optionalFields);

		if (want.condition) {
			try {
				want.request = Request.byCondition(want.condition);
				delete want.condition;
			} catch(e) {
				throw new Error("Could not create a Want with invalid condition: " + e);
			}
		}
		else if (want.chunkId) {
			try {
				want.request = Request.byId(want.chunkId);
				delete want.chunkId;
			} catch(e) {
				throw new Error("Could not create a Want with invalid chunkId: " + e);
			}
		} else {
			throw new Error("A Want must be created with either a 'chunkId' or a 'request' field.");
		}

		want.id = util.iterator("wants");

		return want;
	}

	return {
		create: create
	}
});	