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

	return {
		get: get,
		set: set
	}
});