console.log(window.location.pathname);

define(["Display", "StoryDisplay", "State", "ChunkLibrary", "Wishlist", "StoryAssembler", "Game", "Hanson", "text!travelData", "text!workerData", "text!lectureData", "text!dinnerData"], function(Display, StoryDisplay, State, ChunkLibrary, Wishlist, StoryAssembler, Character, Game, Hanson, travelData, workerData, lectureData, dinnerData) {
	
	/*
		Initializing function
	*/
	var init = function() {
		
		var scenes = ["dinner", "lecture", "travel", "worker" ];
		Display.initTitleScreen(this, State, scenes);		//start up UI

	}

	/*
		Loads the necessary materials for the story
	*/
	var loadStoryMaterials = function(id) {
		var example = getStorySpec(id);
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

		//TODO: display intro screen
		StoryAssembler.beginScene(wishlist, ChunkLibrary, State, StoryDisplay, Character);
	}

	var getStorySpec = function(id) {
		
		//var travelData = require("text!travelData");
		//"text!travelData", "text!workerData", "text!lectureData", "text!dinnerData"

		var storySpec = [
		{
			id: "travel",
			wishlist: [
				{ condition: "establishScene eq true"},
				{ condition: "articlesRead eq 4" },
				{ condition: "endScene eq true" }
			],
			dataFile: require("text!travelData"),
			startState: [
				"set specialty shrimp",
				"set cueOuttro false",
				"set articlesRead 0",
				"set confidence 0",
				"set reading 0",
				"set readFood 0",			//set by game
				"set readAirport 0",		//set by game
				"set readSpecies 0",		//set by game
				"set readRefugees 0"		//set by game
			]
		},
		{
			id: "worker",
			wishlist: [
				//{ condition: "reinforceSpecialty eq true" },		//this is triggered by grammars
				{ condition: "establishSpeciesMigration eq true" },
				{ condition: "confrontPlayerBeliefs eq true" },
				{ condition: "establishScene eq true"},
				{ condition: "endScene eq true" }
			],
			dataFile: require("text!workerData"),
			startState: [
				"set confidence 1",
				"set optimism 0",
				"set specialty shrimp",
				"set emotional 0",
				"set serious chill",
				"set requiredPercent 0",
			]
		},
		{
			id: "lecture",
			wishlist: [
				{ condition: "callOnStudent eq true", persistent: true},
				{ condition: "establishLecture eq true"},
				{ condition: "giveLecture eq true", persistent: true },
				//{ condition: "reinforceSpecialty eq true" },		//this is triggered by grammars
				//{ condition: "demonstrateConfidence eq true" },	//need to write some confidence-hinging options
				{ condition: "establishSpecialtyInfo eq true" },
				{ condition: "respondToQuestion eq true" },
				{ condition: "classOver eq true" }
			],
			dataFile: require("text!lectureData"),
			startState: [
				"set specialty shrimp", 
				"set questionsLeft 3",
				"set confidence 3"
			]
		},
		{
			/*
				currently these wishlist items all proceed sequentially
			*/
			id: "dinner",
			wishlist: [
				{ condition: "introMechanics eq true" },
				{ condition: "establishSpecialtyInfo eq true" },
				{ condition: "establishDinnerWithFriend eq true" },
				{ condition: "establishFriendBackstory eq true" },
				{ condition: "establishEmmaRegrets eq true" },
				{ condition: "establishEmmaBackstory eq true" },
				{ condition: "provokeConfidenceChoice eq true" },
				{ condition: "friendReassuresEmma eq true" },
			],
			dataFile: require("text!dinnerData"),
			startState: [
				"set initialized true", 
				"set friendName Emma",
				"set career 0",
				"set confidence 0"
			]
		}
		]

		return storySpec.filter(function(v) { return v.id === id; })[0];
	}

	/*
		Eventually this should return something different for each scene...for now we just use this
	*/
	var loadAvatars = function(id) {

		var avatars = [
			{
				id: "happy",
				src: "happy.png",
				state: ["confidence gt 4"]
			},
			{
				id: "worried",
				src: "worried.png",
				state: ["confidence eq 2"]
			},
			{
				id: "stressed",
				src: "stressed.png",
				state: ["confidence eq 0"]
			},
		];

		State.avatars = avatars;

		Display.setAvatar(State);
	}

	/*
		This will eventually be replaced with more complex stuff before passing
		off to game.js
	*/
	var startGame = function(id) {
		var Game = require("Game");
		Game.init(id, State, Display);
	}

	return {
		init : init,
		loadStoryMaterials : loadStoryMaterials,
		loadAvatars : loadAvatars,
		startGame : startGame
	}
});