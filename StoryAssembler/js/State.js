/* 	State Module

	Stores information about the world that the story generator might wish to access or modify.
*/

/* global define */

define(["Condition"], function(Condition) {
	"use strict";

	var blackboard = {};

	var get = function(key) {
		return blackboard[key];
	}

	var set = function(key, value) {
		var tryNum = parseFloat(value);
		if (!isNaN(tryNum)) {
			value = tryNum;
		}
		blackboard[key] = value;
	}

	var remove = function(key) {
		delete blackboard[key];
	}

	var reset = function() {
		blackboard = {};
	}

	/* Checks a condition against the state.
	the condition string are validated by the Condition module.
	*/
	var isTrue = function(condition) {
		// Parse condition string; if invalid, will throw an error.
		var conditionParts = Condition.parts(condition);

		var valOfParam;
		var param = conditionParts.param;
		var op = conditionParts.op;
		var value = conditionParts.value;
		if (param !== undefined) {
			valOfParam = get(param);
			if (op !== "eq" && op !== "neq" && isNaN(parseFloat(valOfParam))) {
				throw new Error("Tried to perform op '" + op + "' on param '" + param + "' (" + valOfParam + ") but that does not appear to be a number.");
			}
		}
		// TODO: Move this into Condition module, so ops aren't defined in two places
		switch(op) {
			case "forceTrue":
				return true;
			case "forceFalse":
				return false;
			case "eq":
				return valOfParam == value;
			case "neq":
				return valOfParam != value;
			case "gte":
				return valOfParam >= value;
			case "lte":
				return valOfParam <= value;
			case "gt":
				return valOfParam > value;
			case "lt":
				return valOfParam < value;
		}
	}

	var _getEffectFields = function(effect) {
		var fields = {};
		var params = effect.replace(/\s\s+/g, " ").split(" ");
		fields.op = params.splice(0, 1)[0];
		var val = params[1];
		if (val === "true") val = true;
		if (val === "false") val = false;
		fields.val = val;
		fields.param = params[0];
		fields.params = params;
		return fields;
	}

	/*
	 * Makes a change to the state based on a recognized command.
	 *
	 * Currently handles:
	 *  - @@set PARAM VALUE@@: Sets a variable to a number or string.
	 *  - @@incr PARAM x@@: Increments a numeric variable by x.
	 *  - @@decr PARAM x@@: Decrements a numeric variable by x.
	 *  - @@mult PARAM x@@: Multiplies a numeric variable by x.
	 */
	var change = function(effect) {

		var expect = function(num) {
			if (fields.params.length !== num) {
				throw new Error("Invalid number of params for op '" + fields.op + "' (found " + fields.params.length + ", expected " + num + ") in effect '" + effect + "'");
			}
		}
		var expectNum = function(val) {
			if (val === undefined) {
				set(val, 0);
			} else if (isNaN(parseFloat(val))) {
				throw new Error("Expected in effect '" + effect + "' that '" + val + "' would be a number but it was a " + typeof val);
			}
		}
		var validateNumberParams = function() {
			expect(2);
			var oldVal = get(fields.params[0]);
			if (oldVal === undefined) {
				set(fields.param, 0);
				oldVal = 0;
			}
			expectNum(oldVal);
			expectNum(fields.params[1]);
		}

		var fields = _getEffectFields(effect);
		switch(fields.op) {
			case "set":
				expect(2);
				set(fields.param, fields.val);
				break;
			case "incr":
				validateNumberParams();
				set(fields.param, get(fields.param) + parseFloat(fields.val));
				break;
			case "decr":
				validateNumberParams();
				set(fields.param, get(fields.param) - parseFloat(fields.val));
				break;
			case "mult":
				validateNumberParams();
				set(fields.param, get(fields.param) * parseFloat(fields.val));
				break;
			default:
				throw new Error("Invalid op '" + fields.op + "' in effect '" + effect + "'");
		}
	}

	// Check if a given effect would make the given condition true, by storing the current blackboard value, running the effect, checking the condition, then restoring the original value. 
	var wouldMakeMoreTrue = function(effect, condition) {
		var fields = _getEffectFields(effect);
		var param = fields.param;
		var currVal = get(param);
		var isNumOp = ["incr", "decr", "mult"].indexOf(fields.op) >= 0;
		var conditionParts = condition.split(" ");
		var conditionParam = conditionParts[0];
		var conditionOp = conditionParts[1];
		var conditionTarget = parseInt(conditionParts[2]);

		// Don't allow relative operations on a value that doesn't exist.
		if (currVal === undefined && isNumOp) {
			return false;
		}
		
		change(effect);
		var wouldBeTrue = isTrue(condition);
		var valAfterEffect = get(param);
		set(param, currVal);

		if (!wouldBeTrue && conditionParam === param && isNumOp) {
			// Check if this operation would move the state closer to the condition we're looking for. i.e. if effect is "incr x 1", condition is "x eq 5", and get(x) is 1, we should also return true.

			var lrgrOp = fields.op === "incr" || fields.op === "mult";
			var fieldsVal = parseInt(fields.val);
			var conditionOpLteOrEq = conditionOp === "lte" || conditionOp === "eq";

			// If this operation will make the value larger...
			if ((lrgrOp && fieldsVal > 0) || (!lrgrOp && fieldsVal < 0)) {
				// ... and we're not exceeding the constraint specified in the conditional operator, we're closer.
				if ((valAfterEffect <= conditionTarget && conditionOpLteOrEq) || (valAfterEffect < conditionTarget && conditionOp === "lt")) {
					wouldBeTrue = true;
				} else if (conditionOp === "gte" || conditionOp === "gt") {
					wouldBeTrue = true;
				}
			// If this operation will make the value smaller...
			} else {
				// ... and we're not smaller than the constraint specified in the conditional operator, we're closer.
				if ((valAfterEffect >= conditionTarget && conditionOpLteOrEq) || (valAfterEffect > conditionTarget && conditionOp === "lt")) {
					wouldBeTrue = true;
				} else if (conditionOp === "lte" || conditionOp === "lt") {
					wouldBeTrue = true;
				}
			}
		}

		return wouldBeTrue;
	}

	// Same as above, except returns true of any effects in the passed in array would make the given condition true
	var wouldAnyMakeMoreTrue = function(effectArray, condition) {
		if (!condition) return false; // TODO: fix so never called this way.
		for (var i = 0; i < effectArray.length; i++) {
			if (wouldMakeMoreTrue(effectArray[i], condition)) {
				return true;
			}
		}
		return false;
	}

	var getBlackboard = function() {
		return blackboard;
	}

	return {
		get: get,
		set: set,
		remove: remove,
		reset: reset,
		change: change,
		isTrue: isTrue,
		wouldMakeMoreTrue: wouldMakeMoreTrue,
		wouldAnyMakeMoreTrue: wouldAnyMakeMoreTrue,
		getBlackboard: getBlackboard
	}
});