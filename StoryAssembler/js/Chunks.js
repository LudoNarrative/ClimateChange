/* 	Chunks Module

*/

/* global define */

define([], function() {
	"use strict";

	// Stub to handle rendering NLG, mixins, etc.: currently just returns the text field unchanged.
	var render = function(chunk) {
		return chunk.text
	}

	// PUBLIC INTERFACE
	return {
		render: render
	}

});