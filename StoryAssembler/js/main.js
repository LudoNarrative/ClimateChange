requirejs.config({
	paths: {
		"domReady": "../lib/domReady",
	}
});

requirejs(["domReady!"], function() {
	console.log("main.js loaded.");
});
