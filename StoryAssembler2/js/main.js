/* global requirejs */

requirejs.config({
	paths: {
		"domReady": "../lib/domReady",
		"text": "../lib/text",

		"util": "util",

		"StoryAssembler": "StoryAssembler",
		"Display": "Display",
		"State": "State",
		"Condition": "Condition",
		"Request": "Request",
		"Want": "Want",
		"Validate": "Validate",
		"ChunkLibrary": "ChunkLibrary",
		"BestPath": "BestPath",
		"Templates": "Templates"
	}
});

requirejs(
	["StoryAssembler", "State", "Wishlist", "ChunkLibrary", "text!../data/TestChunks.json", "domReady!"],
	function(StoryAssembler, State, Wishlist, ChunkLibrary, TestChunksFile) {

	// TODO: Remove old StoryAssembler
	
	console.log("SA2 main.js loaded.");

	State.set("initialized", true); // initial conditions
	State.set("friendName", "Elika"); // initial conditions

	var testChunks = JSON.parse(TestChunksFile);
	ChunkLibrary.add(testChunks);

	var testWishlist = Wishlist.create([
		{ condition: "greetedElika eq true" },
		{ condition: "demonstratedTrait eq true" },
	], State);
	// testWishlist.logOn();
	StoryAssembler.beginScene(testWishlist, ChunkLibrary, State);

});
