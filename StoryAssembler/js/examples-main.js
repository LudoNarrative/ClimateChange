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

	// To Add A New Example:
	// - Create new definition in "examples" dictionary below
	// - Add data file to requirejs call above (both the filename and the variable name)

	var examples = {
		"Example 1": {
			wishlist: [
				{ condition: "greetedElika eq true" },
				{ condition: "demonstratedTrait eq true" },
			],
			dataFile: Example1Data,
			startState: ["set initialized true", "set friendName Elika"]
		}
	};

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
		var example = examples[id];
		example.startState.forEach(function(command) {
			State.change(command);
		});

		var data = JSON.parse(example.dataFile);
		ChunkLibrary.add(data);

		var wishlist = Wishlist.create(example.wishlist, State);

		document.getElementsByTagName("body")[0].innerHTML = "";
		StoryAssembler.beginScene(wishlist, ChunkLibrary, State);
	}

	// For each example, make a link to start it.
	for (var id in examples) {
		var body = document.getElementsByTagName("body")[0];
		var el = makeLink(id, id, "#");
		body.appendChild(el);
	};



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
