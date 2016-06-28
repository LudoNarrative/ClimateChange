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
		"Templates": "Templates",
		"Character": "Character",
		"Hanson": "Hanson"
	}
});

requirejs(
	["State", "Display", "ChunkLibrary", "Wishlist", "StoryAssembler", "Character", "Hanson", "text!../data/exampleData/lecture.json", "text!../data/exampleData/Example1.json", "text!../data/exampleData/Example2.json", "text!../data/exampleData/charExampleData.json", "util", "domReady!"],
	function(State, Display, ChunkLibrary, Wishlist, StoryAssembler, Character, Hanson, lectureData, Example1Data, Example2Data, charExampleData) {

	// To Add A New Example:
	// - Create new definition in "examples" dictionary below
	// - Add data file to requirejs call above (both the filename and the variable name)

	var examples = {
		"Lecture scene": {
			wishlist: [
				{ condition: "callOnStudent eq true", persistent: true},
				{ condition: "establishLecture eq true"},
				{ condition: "giveLecture eq true", persistent: true },
				{ condition: "reinforceSpecialty eq true" },
				{ condition: "demonstrateConfidence eq true" },
				{ condition: "establishSpecialtyInfo eq true" },
				{ condition: "respondToQuestion eq true" },
				{ condition: "classOver eq true" }
			],
			dataFile: lectureData,
			startState: ["set specialty shrimp", "set questionsLeft 3"]
		},
		"Example: Simple Trait Demonstration": {
			wishlist: [
				{ condition: "greetedElika eq true" },
				{ condition: "demonstratedTrait eq true" },
			],
			dataFile: Example1Data,
			startState: ["set initialized true", "set friendName Elika"]
		},
		"Example: Dinner Scene (set DEFAULT_MAX_DEPTH to 5)": {
			wishlist: [
				{ condition: "introMechanics eq true" },
				{ condition: "beat eq 1" },
				{ condition: "beat eq 2" },
				{ condition: "beat eq 3" },
				{ condition: "beat eq 4" },
				{ condition: "beat eq 5" },
				{ condition: "beat eq 6" },
			],
			dataFile: Example2Data,
			startState: [
				"set initialized true", 
				"set friendName Emma",
				"set career 0",

			]
		},
		"Example: Character Mixins": {
			wishlist: [
				{ condition: "demonstratedTrait eq 1" }
			],
			startState: [ "set demonstratedTrait 0", "set speaker elika" ],
			dataFile: charExampleData,
			characters: {
				"anna": {name: "Anna", confident: true},
				"elika": {name: "Élika", forceful: true}
			}
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
		var data = HanSON.parse(example.dataFile);
		ChunkLibrary.add(data);

		var wishlist = Wishlist.create(example.wishlist, State);
		wishlist.logOn();
		if (example.characters) {
			Character.init(State);
			for (var key in example.characters) {
				Character.add(key, example.characters[key]);
			}
		}

		document.getElementsByTagName("body")[0].innerHTML = "";
		StoryAssembler.beginScene(wishlist, ChunkLibrary, State, Display, Character);
	}

	// For each example, make a link to start it.
	for (var id in examples) {
		var body = document.getElementsByTagName("body")[0];
		var el = makeLink(id, id, "#");
		body.appendChild(el);
	};


});
