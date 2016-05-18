/* global requirejs */

requirejs.config({
	paths: {
		"domReady": "../lib/domReady",
		"text": "../lib/text",
		"underscore": "../lib/underscore-1.8.3.min",

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
	["State", "Display", "ChunkLibrary", "Wishlist", "StoryAssembler", "text!../data/exampleData/Example1.json", "text!../data/exampleData/Example2.json", "util", "domReady!"],
	function(State, Display, ChunkLibrary, Wishlist, StoryAssembler, Example1Data, Example2Data) {

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
		},
		"Example 2": {
			wishlist: [
				{ condition: "introMechanics eq true" },
				{ condition: "beat eq 1" },
				{ condition: "beat eq 2" },
				{ condition: "beat eq 3" },
				{ condition: "beat eq 4" },
			],
			dataFile: Example2Data,
			startState: [
				"set initialized true", 
				"set friendName Emma",
				"set career 0",

			]
		}
	};

	var makeLink = function(id, content, target) {
		var el = document.createElement("a");
		el.href = target;
		el.onclick = function() {
			loadExample(id);
		}
		el.innerHTML = content;
		var p = document.createElement("p");
		p.appendChild(el);
		return p;
	}

	var loadExample = function(id) {
		var example = examples[id];
		example.startState.forEach(function(command) {
			State.change(command);
		});

		var data = JSON.parse(example.dataFile);
		ChunkLibrary.add(data);

		var wishlist = Wishlist.create(example.wishlist, State);
		// wishlist.logOn();

		document.getElementsByTagName("body")[0].innerHTML = "";
		StoryAssembler.beginScene(wishlist, ChunkLibrary, State, Display);
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
