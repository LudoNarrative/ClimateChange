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

	return {
		iterator: iterator
	}
});