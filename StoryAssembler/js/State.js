/* 	State Module

	Stores information about the world that the story generator might wish to access or modify.
*/

/* global define */

define([], function() {
	"use strict";

	var blackboard = {};

	var get = function(key) {
		return blackboard[key];
	}

	var set = function(key, value) {
		blackboard[key] = value;
	}

	/* Currently handles PARAM op VALUE, true, or false
	op can be eq, geq, leq, gt, lt
	*/
	var isTrue = function(condition) {
		condition = "" + condition; // coerce to string
		var conditionParts = condition.replace(/\s\s+/g, " ").split(" ");
		if (conditionParts.length !== 3) {
			if (conditionParts[0] === "true") {
				return true;
			} else if (conditionParts[0] === "false") {
				return false;
			} else {
				throw new Error("Expected condition in the form 'PARAM OP VALUE' but saw '" + condition + "' which seems to have " + conditionParts.length + " parts.");
			}
		}
		var param = conditionParts[0];
		var op = conditionParts[1].toLowerCase();
		var value = conditionParts[2];
		if (value === "true") value = true;
		if (value === "false") value = false;
		console.log("param, op, value", param, op, value);

		var valOfParam = get(param);
		if (op !== "eq" && isNaN(parseFloat(valOfParam))) {
			throw new Error("Tried to perform op '" + op + "' on param '" + param + "' (" + valOfParam + ") but that does not appear to be a number.");
		}
		switch(op) {
			case "eq":
				console.log("valOfParam, typeof valOfParam, value, typeof value", valOfParam, typeof valOfParam, value, typeof value);
				return valOfParam == value;
			case "geq":
			case "gte":
				return valOfParam >= value;
			case "leq":
			case "lte":
				return valOfParam <= value;
			case "gt":
				return valOfParam > value;
			case "lt":
				return valOfParam < value;
			default:
				throw new Error("Found invalid op '" + op + "' in condition '" + condition + "' (valid ops are: eq, geq, leq, gt, lt)");

		}
	}

	/*
	 * Makes a change to the state based on a recognized command.
	 *
	 * Currently handles:
	 *  - @@set PARAM VALUE@@: Sets a variable to a number or string.
	 *  - @@incr PARAM@@:   Increments a numeric variable by one.
	 *  - @@incr PARAM x@@: Increments a numeric variable by x.
	 *  - @@decr PARAM@@:   Decrements a numeric variable by one.
	 *  - @@decr PARAM x@@: Decrements a numeric variable by x.
	 *  - @@mult PARAM x@@: Multiplies a numeric variable by x.
	 */
	var change = function(effect) {

		var expect = function(num) {
			if (params.length !== num) {
				throw new Error("Invalid number of params for op '" + op + "' (found " + params.length + ", expected " + num + ") in effect '" + effect + "'");
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
			var oldVal = get(params[0]);
			if (oldVal === undefined) {
				set(params[0], 0);
				oldVal = 0;
			}
			expectNum(oldVal);
			expectNum(params[1]);
		}

		var params = effect.replace(/\s\s+/g, " ").split(" ");
		var op = params.splice(0, 1)[0];
		switch(op) {
			case "set":
				expect(2);
				set(params[0], params[1]);
				break;
			case "incr":
				if (!params[1]) params[1] = 1;
				validateNumberParams();
				set(params[0], get(params[0]) + parseFloat(params[1]));
				break;
			case "decr":
				if (!params[1]) params[1] = 1;
				validateNumberParams();
				set(params[0], get(params[0]) - parseFloat(params[1]));
				break;
			case "mult":
				validateNumberParams();
				set(params[0], get(params[0]) * parseFloat(params[1]));
				break;
			default:
				throw new Error("Invalid op '" + op + "' in effect '" + effect + "'");
		}
	}

	return {
		get: get,
		set: set,
		change: change,
		isTrue: isTrue
	}
});