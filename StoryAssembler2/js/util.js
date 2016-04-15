define([], function() {
	"use strict";
	var _iterators = {};

	/* Function: iterator
	Given a key, returns a number that starts at 1 and increases by 1 each time the function is called for the same key.
	
	Parameters:
	key - a string
	
	Returns:
	number (integer)
	*/	
	var iterator = function (key) {
		if (_iterators[key] === undefined) {
			_iterators[key] = 0;
		}
		_iterators[key] += 1;
		return _iterators[key];
	}

	/* Function: oneOf
	Returns a random entry from an array, or undefined if the array is empty or not an array.
	
	Parameters:
	arr - an array of anything
	
	Returns:
	an entry from a random position in arr.
	*/
	var oneOf = function (arr) {
		return arr[randomNumber(arr.length) - 1];
	}

	/* Function: randomNumber
	Returns a random integer from 1 to max. Return 1 if max <= 1 or not a number.
	
	Parameters:
	max - an integer, the highest number that might be returned.
	
	Returns:
	number (integer) between 1 and max.
	*/	
	var randomNumber = function (max) {
		if (max <= 1 || typeof max !== "number") {
			return 1;
		}
		return Math.floor(Math.random() * Math.round(max)) + 1;
	}

	return {
		iterator: iterator,
		oneOf: oneOf,
		randomNumber: randomNumber
	}
});