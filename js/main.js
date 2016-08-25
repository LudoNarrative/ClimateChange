requirejs.config({
	paths: {
		"domReady": "../StoryAssembler/lib/domReady",
		"text": "../StoryAssembler/lib/text",
		"underscore": "../StoryAssembler/lib/underscore-1.8.3.min",

		"util": "../StoryAssembler/js/util",
		"StoryAssembler": "../StoryAssembler/js/StoryAssembler",
		"StoryDisplay": "../StoryAssembler/js/Display",
		"State": "../StoryAssembler/js/State",
		"Wishlist" : "../StoryAssembler/js/Wishlist",
		"Condition": "../StoryAssembler/js/Condition",
		"Request": "../StoryAssembler/js/Request",
		"Want": "../StoryAssembler/js/Want",
		"Validate": "../StoryAssembler/js/Validate",
		"ChunkLibrary": "../StoryAssembler/js/ChunkLibrary",
		"BestPath": "../StoryAssembler/js/BestPath",
		"Templates": "../StoryAssembler/js/Templates",
		"Character": "../StoryAssembler/js/Character",
		"Hanson": "../StoryAssembler/js/Hanson",

		"globalData" : "../StoryAssembler/data/global.json",
		"travelData" : "../StoryAssembler/data/travel2.json", 
		"workerData" : "../StoryAssembler/data/worker2.json", 
		"lectureData" : "../StoryAssembler/data/lecture2.json", 
		"dinnerData" : "../StoryAssembler/data/dinner2.json",

		"Coordinator" : "../Coordinator/Coordinator",
		"Display" : "Display",

		"Phaser" : "../lib/phaser",
		"jQuery": "../lib/jquery-3.0.0.min",
		"jQueryUI": "../lib/jquery-ui.min",
		"jsonEditor": "../lib/jsonEditor/jsoneditor",

		"Game" : "../GameGenerator/js/game",
		"AspPhaserGenerator" : "../asp-phaser-generator/index",
		"translateAsp" : '../asp-phaser-generator/src/asp-to-cygnus',
		"rensa" : '../asp-phaser-generator/src/brain',
		"ctp" : '../asp-phaser-generator/src/cygnus-to-phaser-brain',
		"translatePhaserBrain" : '../asp-phaser-generator/src/phaser-brain-to-code'
	},

	shim: {
		"jQueryUI": {
			export: "$",
			deps: ["jQuery"]
		}
	}
});

requirejs(
	["State", "StoryDisplay", "Display", "Coordinator", "ChunkLibrary", "Wishlist", "StoryAssembler", "Character", "Game", "AspPhaserGenerator", "util", "domReady!"],
	function(State, StoryDisplay, Display, Coordinator, ChunkLibrary, Wishlist, StoryAssembler, Character, Game, AspPhaserGenerator) {

	Coordinator.init();


});