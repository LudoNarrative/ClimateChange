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
		"HealthBar" : "../lib/healthbarstandalone",

		"globalData" : "../StoryAssembler/data/global.json",
		"travelData" : "../StoryAssembler/data/travel.json", 
		"workerData" : "../StoryAssembler/data/worker.json", 
		"lectureData" : "../StoryAssembler/data/lecture.json", 
		"dinnerData" : "../StoryAssembler/data/dinner.json",
		"generalistData" : "../StoryAssembler/data/generalist.json",


		"undergradDinnerData_talon" : "../StoryAssembler/data/undergradDinnerData-talon.json",
		"undergradDinnerData_irapopor" : "../StoryAssembler/data/undergradDinnerData-irapopor.json",
		"undergradDinnerData_sgadsby" : "../StoryAssembler/data/undergradDinnerData-sgadsby.json",

		"undergradDean_sgadsby" : "../StoryAssembler/data/undergradDean-sgadsby.json",
		"undergradDean_talon" : "../StoryAssembler/data/undergradDean-talon.json",
		"undergradDean_irapopor" : "../StoryAssembler/data/undergradDean-irapopor.json",

		"undergradLecture_kply" : "../StoryAssembler/data/undergradLecture-kply.json",
		"undergradLecture_sjsherma" : "../StoryAssembler/data/undergradLecture-sjsherma.json",

		"undergradTravel_sjsherma" :  "../StoryAssembler/data/undergradTravel-sjsherma.json",
		"undergradTravel_kply" : "../StoryAssembler/data/undergradTravel-kply.json",

		"undergradFamilyDinner_sgadsby" : "../StoryAssembler/data/undergrad_familyDinner_sgadsby.json",
		"undergradFamilyDinner_talon" : "../StoryAssembler/data/undergrad_familyDinner_talon.json",
		"undergradFamilyDinner_irapopor" : "../StoryAssembler/data/undergrad_familyDinner_irapopor.json",

		"undergradUN_irapopor" : "../StoryAssembler/data/undergradUN-irapopor.json",
		"undergradUN_kply" : "../StoryAssembler/data/undergradUN-kply.json",
		"undergradUN_talon" : "../StoryAssembler/data/undergradUN-talon.json",

		"undergradBeach_sjsherma" : "../StoryAssembler/data/undergradBeach-sjsherma.json",
		"undergradBeach_madreed" : "../StoryAssembler/data/undergradBeach-madreed.json",
		"undergradBeach_sgadsby" : "../StoryAssembler/data/undergradBeach-sgadsby.json",

		"undergradFaculty_sjsherma" : "../StoryAssembler/data/undergradFaculty-sjsherma.json",
		"undergradFaculty_madreed" : "../StoryAssembler/data/undergradFaculty-madreed.json",
		"undergradFaculty_kply" : "../StoryAssembler/data/undergradFaculty-kply.json",


		"sjsherma_testfile" : "../StoryAssembler/data/sjsherma-testfile.json",
		"kply_testfile" : "../StoryAssembler/data/kply-testfile.json",
		"irapopor_testfile" : "../StoryAssembler/data/irapopor-testfile.json",
		"talon_testfile" : "../StoryAssembler/data/talon-testfile.json",
		"sgadsby_testfile" : "../StoryAssembler/data/sgadsby-testfile.json",
		"madreed_testfile" : "../StoryAssembler/data/madreed-testfile.json",


		"finalDinner" : "../StoryAssembler/data/final/finalDinner.json",
		"finalLecture" : "../StoryAssembler/data/knobs/lecture.json",
		"finalDean" : "../StoryAssembler/data/final/finalDean.json",
		"finalTravel" : "../StoryAssembler/data/final/finalTravel.json",
		"finalFamilyDinner" : "../StoryAssembler/data/final/finalFamilyDinner.json",
		"finalUN" : "../StoryAssembler/data/final/finalUN.json",
		"finalBeach" : "../StoryAssembler/data/final/finalBeach.json",
		"finalFaculty" : "../StoryAssembler/data/final/finalFaculty.json",


		"newExampleData" : "../StoryAssembler/data/newExampleData.json",

		"Coordinator" : "../Coordinator/Coordinator",
		"Display" : "Display",
		"avatars" : "../assets/avatars/avatars.json",

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