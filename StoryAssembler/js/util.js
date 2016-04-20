/* 	Utility Functions
*/
/* global define, toString */

define([], function() {

	/* Function: isArray
	Determines if the given object is an array.
	
	Parameters:
	obj - an object
	
	Returns:
	boolean - true if obj is an array.
	*/
	var isArray = function(obj) {
		return toString.call(obj) === "[object Array]";
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

	var randomInt = function (max) {
		if (max <= 1 || typeof max !== "number") {
			return 1;
		}
		return Math.floor(Math.random() * Math.round(max)) + 1;
	}

	var removeFromStringList = function(list, itemToRemove) {
		var newList = clone(list);
		var pos = newList.indexOf(itemToRemove);
		if (pos < 0) return newList;
		newList.splice(pos, 1);
		return newList;
	}

	// PUBLIC INTERFACE
	return {
		isArray: isArray,
		clone: clone,
		randomInt: randomInt,
		removeFromStringList: removeFromStringList
	}

});