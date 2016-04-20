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

	/* Function: clone
	Creates a clone (non-reference version) of an array or object. Code courtesy A. Levy on Stackoverflow.
	
	Parameters:
	obj - the object to clone
	
	Returns:
	a new object identical to obj
	*/	
	var clone = function (obj) {
	    // Handle the 3 simple types, and null or undefined
	    if (null === obj || "object" !== typeof obj) return obj;

	    // Handle Array
	    if (obj instanceof Array) {
	        var copy = [];
	        for (var i = 0, len = obj.length; i < len; i++) {
	            copy[i] = clone(obj[i]);
	        }
	        return copy;
	    }

	    // Handle Object
	    if (obj instanceof Object) {
	        var copy = {};
	        for (var attr in obj) {
	            if (obj.hasOwnProperty(attr)) copy[attr] = clone(obj[attr]);
	        }
	        return copy;
	    }

	    throw new Error("Unable to copy obj! Its type isn't supported.");
	}

	var isArray = function(obj) {
		return toString.call(obj) === "[object Array]";
	}

	var removeFromStringList = function(list, itemToRemove) {
		var newList = clone(list);
		var pos = newList.indexOf(itemToRemove);
		if (pos < 0) return newList;
		newList.splice(pos, 1);
		return newList;
	}

	return {
		iterator: iterator,
		oneOf: oneOf,
		randomNumber: randomNumber,
		clone: clone,
		isArray: isArray,
		removeFromStringList: removeFromStringList
	}
});