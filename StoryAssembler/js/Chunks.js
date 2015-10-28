/* 	Chunks Module

*/

/* global define */

define([], function() {
	"use strict";

	var render = function(chunk) {
		return chunk.text
	}

	return {
		render: render
	}

});