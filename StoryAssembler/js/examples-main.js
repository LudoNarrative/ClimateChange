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
	["State", "ChunkLibrary", "Wishlist", "StoryAssembler", "text!../data/exampleData/Example1.json", "util", "domReady!"],
	function(State, ChunkLibrary, Wishlist, StoryAssembler, Example1Data) {

	var exampleWishlist = {};
	var exampleDataFile = {};
	var exampleStartState = {};

	var makeLink = function(id, content, target) {
		var el = document.createElement("a");
		el.href = target;
		el.onclick = function() {
			loadExample(id);
		}
		el.innerHTML = content;
		return el;
	}

	var loadExample = function(id) {
		exampleStartState[id].forEach(function(command) {
			State.change(command);
		});

		var data = JSON.parse(exampleDataFile[id]);
		ChunkLibrary.add(data);

		var wishlist = Wishlist.create(exampleWishlist[id], State);

		document.getElementsByTagName("body")[0].innerHTML = "";
		StoryAssembler.beginScene(wishlist, ChunkLibrary, State);
	}

	// For each example, make a link to start it.

	// EXAMPLE 1
	var id = 1;
	var body = document.getElementsByTagName("body")[0];
	var el = makeLink(id, "Example " + id, "#");
	body.appendChild(el);
	exampleWishlist[id] = [
		{ condition: "greetedElika eq true" },
		{ condition: "demonstratedTrait eq true" },
	];
	exampleDataFile[id] = Example1Data;
	exampleStartState[id] = ["set initialized true", "set friendName Elika"];




	// // TODO: Remove old StoryAssembler
	
	// console.log("SA2 main.js loaded.");


	// var testChunks = JSON.parse(TestChunksFile);
	// ChunkLibrary.add(testChunks);

	// var testWishlist = Wishlist.create([
	// 	{ condition: "greetedElika eq true" },
	// 	{ condition: "demonstratedTrait eq true" },
	// ], State);
	// // testWishlist.logOn();
	// StoryAssembler.beginScene(testWishlist, ChunkLibrary, State);

});
