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
		"travelData" : "../StoryAssembler/data/travel.json", 
		"workerData" : "../StoryAssembler/data/worker.json", 
		"lectureData" : "../StoryAssembler/data/lecture.json", 
		"dinnerData" : "../StoryAssembler/data/dinner.json",
		"generalistData" : "../StoryAssembler/data/generalist.json",
		//"undergradDinnerData" : "../StoryAssembler/data/undergradDinnerData.json",

		"undergradDinnerData_kevin" : "../StoryAssembler/data/undergradDinnerData-kevin.json",
		"undergradDinnerData_talon" : "../StoryAssembler/data/undergradDinnerData-talon.json",
		"undergradDinnerData_irapopor" : "../StoryAssembler/data/undergradDinnerData-irapopor.json",
		"undergradDinnerData_sgadsby" : "../StoryAssembler/data/undergradDinnerData-sgadsby.json",
		"undergradDinnerData_madreed" : "../StoryAssembler/data/undergradDinnerData-madreed.json",
		"undergradDinnerData_sjsherma" : "../StoryAssembler/data/undergradDinnerData-sjsherma.json",

		"undergradDean_sgadsby" : "../StoryAssembler/data/undergradDean-sgadsby.json",
		"undergradDean_talon" : "../StoryAssembler/data/undergradDean-talon.json",
		"undergradDean_irapopor" : "../StoryAssembler/data/undergradDean-irapopor.json",

		"undergradLecture_kply" : "../StoryAssembler/data/undergradLecture-kply.json",
		"undergradLecture_sjsherma" : "../StoryAssembler/data/undergradLecture-sjsherma.json",

		"travel_placeholder" : "../StoryAssembler/data/travel_placeholder.json",

		"newExampleData" : "../StoryAssembler/data/newExampleData.json",

		"Coordinator" : "../Coordinator/Coordinator",
		"Display" : "Display",

		"Phaser" : "../lib/phaser",
		"jQuery": "../lib/jquery-3.0.0.min",
		"jQueryUI": "../lib/jquery-ui.min",
		"jsonEditor": "../lib/jsonEditor/jsoneditor",

		"Game" : "../GameGenerator/js/game",
		"AspPhaserGenerator" : "../asp-phaser-generator-2/index",
		"translateAsp" : '../asp-phaser-generator-2/src/asp-to-cygnus-2',
		"rensa" : '../asp-phaser-generator-2/src/brain',
		"ctp" : '../asp-phaser-generator-2/src/cygnus-to-phaser-brain-2',
		"translatePhaserBrain" : '../asp-phaser-generator-2/src/phaser-brain-to-code-2'
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