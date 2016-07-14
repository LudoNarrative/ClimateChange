console.log(window.location.pathname);

define(["Display", "StoryDisplay", "State", "ChunkLibrary", "Wishlist", "StoryAssembler", "Game", "Hanson", "text!travelData", "text!workerData", "text!lectureData", "text!dinnerData"], function(Display, StoryDisplay, State, ChunkLibrary, Wishlist, StoryAssembler, Character, Game, Hanson, travelData, workerData, lectureData, dinnerData) {
	
	/*
		Initializing function
	*/
	var init = function() {
		
		var scenes = ["dinner", "lecture", "travel", "worker" ];	//order of scenes
		State.set("scenes", scenes);
		Display.initTitleScreen(this, State, scenes);		//start up UI

	}

	/*
		Loads the necessary materials for the story
	*/
	var loadStoryMaterials = function(id) {

		State.set("currentScene", id);
		var story = getStorySpec(id);
		story.startState.forEach(function(command) {
			State.change(command);
		});
		var data = HanSON.parse(story.dataFile);
		ChunkLibrary.add(data);

		var wishlist = Wishlist.create(story.wishlist, State);
		wishlist.logOn();
		if (story.characters) {
			Character.init(State);
			for (var key in story.characters) {
				Character.add(key, story.characters[key]);
			}
		}

		State.set("storyUIvars", story.UIvars);
		Display.setStats("storyStats");

		StoryAssembler.beginScene(wishlist, ChunkLibrary, State, StoryDisplay, Display, Character);
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
			],
			UIvars: [
				"articlesRead"
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
				"set percent 0",			/*this is what percent is current uncovered*/
				"set requiredPercent 0",
			],
			UIvars: [
				"confidence",
				"optimism"
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
			],
			UIvars: [
				"confidence"
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
			],
			UIvars: [
				"confidence",
				"career"
			]
		}
		]

		return storySpec.filter(function(v) { return v.id === id; })[0];
	}

	var loadSceneIntro = function(id) {

		var sceneScreens = [
			{
				id : "dinner",
				text : "<p>You are Emma Richards, a PhD student who studies the ocean.</p><p>Tomorrow, you'll be defending your thesis. Your friends have decided to throw a dinner party for you.</p><p>Choose what Emma says, but keep an eye on the task you're performing, too!</p>"
			},
			{
				id : "lecture",
				text : "<p>You were able to secure a job as an adjunct professor in Environmental Sciences.</p><p>Dr. Tennerson, a senior faculty member, as been sent to evaluate how the class is going.</p><p>Choose what Emma says, but make sure to keep your cool!</p>"
			},
			{
				id : "worker",
				text : "<p>After a few years struggling as a professor, you decided to apply your expertise to make a difference in a different way.</p><p>Choose what Emma says, but keep an eye on the task you're performing, too!</p>"
			},
			{
				id : "travel",
				text : "<p>As one of the foremost experts in your field, you spend much of your time traveling to conferences. You never dreamed you'd come so far, or your impact would be so great.</p>"
			},

		]
		var sceneText = sceneScreens.filter(function(v) { return v.id === id; })[0].text;
		Display.setSceneIntro(sceneText);
	};

	//loads background, for now this is based on scene id
	var loadBackground = function(id) {
		var sceneBgs = [
			{
				id : "dinner",
				src : "dinner.png"
			},
			{
				id : "lecture",
				src : "lecture.png"
			},
			{
				id : "worker",
				src : "beach.png"
			},
			{
				id : "travel",
				src : "travel.png"
			},

		]
		var sceneBg = sceneBgs.filter(function(v) { return v.id === id; })[0].src;
		return sceneBg;
	}

	/*
		Returns pre-defined list of avatars...hypothetically in the future we could use some metric to pull avatars based on their state gating...
	*/
	var loadAvatars = function(id) {
		var avatarSpec= [
			{
				id : "dinner",
				avatars: [
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
				]
			},
			{
				id : "lecture",
				avatars: [
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
				]
			},
			{
				id : "worker",
				avatars: [
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
				]
			},
			{
				id : "travel",
				avatars: [
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
				]
			}
		];

		State.avatars = avatarSpec.filter(function(v) { return v.id === id; })[0].avatars;

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
		loadSceneIntro : loadSceneIntro,
		loadBackground : loadBackground,
		startGame : startGame
	}
});