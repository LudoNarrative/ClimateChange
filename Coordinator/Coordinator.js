define(["Display", "StoryDisplay", "State", "ChunkLibrary", "Wishlist", "StoryAssembler", "Character","Game", "Hanson", "text!travelData", "text!workerData", "text!lectureData", "text!dinnerData", "text!generalistData", "text!newExampleData", "text!undergradDinnerData_talon", "text!undergradDinnerData_irapopor", "text!undergradDinnerData_sgadsby", "text!undergradDean_sgadsby", "text!undergradDean_talon", "text!undergradDean_irapopor", "text!undergradLecture_kply", "text!undergradLecture_sjsherma", "text!undergradTravel_sjsherma", "text!undergradTravel_kply", "text!undergradFamilyDinner_sgadsby", "text!undergradFamilyDinner_talon","text!undergradFamilyDinner_irapopor", "text!undergradUN_kply", "text!undergradUN_talon", "text!undergradUN_irapopor", "text!undergradBeach_madreed", "text!undergradBeach_sjsherma", "text!undergradBeach_sgadsby", "text!undergradFaculty_kply", "text!undergradFaculty_madreed", "text!undergradFaculty_sjsherma", "text!sjsherma_testfile","text!madreed_testfile", "text!talon_testfile","text!sgadsby_testfile","text!kply_testfile","text!irapopor_testfile", "text!finalDinner", "text!finalLecture", "text!finalDean", "text!finalTravel", "text!finalFamilyDinner", "text!finalUN", "text!finalBeach", "text!finalFaculty", "text!globalData"], function(Display, StoryDisplay, State, ChunkLibrary, Wishlist, StoryAssembler, Character, Game, Hanson, travelData, workerData, lectureData, dinnerData, generalistData, newExampleData, undergradDinnerData_talon, undergradDinnerData_irapopor, undergradDinnerData_sgadsby, undergradDean_sgadsby, undergradDean_talon, undergradDean_irapopor, undergradLecture_kply, undergradLecture_sjsherma, undergradTravel_sjsherma, undergradTravel_kply, undergradFamilyDinner_sgadsby, undergradFamilyDinner_talon, undergradFamilyDinner_irapopor, undergradUN_kply, undergradUN_talon, undergradUN_irapopor, undergradBeach_madreed, undergradBeach_sjsherma, undergradBeach_sgadsby, undergradFaculty_kply, undergradFaculty_madreed, undergradFaculty_sjsherma, sjsherma_testfile, madreed_testfile, talon_testfile, sgadsby_testfile, kply_testfile, irapopor_testfile, finalDinner, finalLecture, finalDean, finalTravel, finalFamilyDinner, finalUN, finalBeach, finalFaculty, globalData) {

	/*
		Initializing function
	*/
	var init = function() {

		//selectable scenes from main menu
		var scenes = ["dinner", "dinner_argument", "generalist", "lecture", "travel", "worker", "newExample", "undergradDinner", "undergradLecture", "undergradDean", "undergradTravel", "undergradFamilyDinner", "undergradUN", "undergradBeach", "undergradFaculty", "sereneTest", "ianTest", "kevinTest", "mattTest", "summerTest", "talonTest", "finalDinner", "finalLecture", "finalTravel", "finalDean", "finalFamilyDinner", "finalBeach", "finalUN", "finalFaculty"];

		//var finalScenes = ["finalDinner", "finalLecture", "finalTravel", "finalDean", "finalFamilyDinner", "finalBeach", "finalUN", "finalFaculty"];

		//scenes played when you hit Begin
		var playGameScenes = ["finalDinner", "finalLecture", "finalTravel", "finalDean", "finalFamilyDinner", "finalBeach", "finalUN", "finalFaculty"];
		State.set("scenes", playGameScenes);
		Display.initTitleScreen(this, State, scenes, playGameScenes);		//start up UI

	}

	//cleans all variables out of state that aren't supposed to cross over between scenes
	var cleanState = function(id) {
		State.set("characters", []);			//get rid of extraneous characters
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
		var levelDataArray = [];

		//load the levelDataArray with all the dataFiles for both the level, and the global fragments file
		for (var x=0; x < story.dataFiles.length; x++) { levelDataArray.push(HanSON.parse(require(story.dataFiles[x]))); }
		levelDataArray.push(HanSON.parse(globalData));

		ChunkLibrary.reset();
		for (var x=0; x < levelDataArray.length; x++) { ChunkLibrary.add(levelDataArray[x]); }		//add in fragments from all files

		var wishlist = Wishlist.create(story.wishlist, State);
		wishlist.logOn();

		if (story.characters) {
			Character.init(State);
			for (var key in story.characters) {
				Character.add(key, story.characters[key]);
			}
		}
		State.set("mode", story.mode);
		State.set("storyUIvars", story.UIvars);
		StoryAssembler.beginScene(wishlist, ChunkLibrary, State, StoryDisplay, Display, Character);
		StoryDisplay.addVarChangers(story.UIvars, StoryAssembler.clickChangeState);		//add controls to change variable values in story (in diagnostics panel)
	}

	//returns index of next scene
	//available scenes: ["finalDinner", "finalLecture", "finalTravel", "finalDean", "finalFamilyDinner", "finalBeach", "finalUN", "finalFaculty"]
	var getNextScene = function(currentScene) {
		switch(currentScene) {
			case "finalDinner":
				return 1;
			case "finalLecture": {
				if (State.get('composure') > 5) {
					return 2;
				}
				else { return 3; }
			}
			case "finalDean": {
				return 4;
			}
			case "finalTravel":
				return 4;
			case "finalFamilyDinner": {
				if (State.get('academicEnthusiasm' > 8)) {			//UN branch
					return 6;
				}
				if (State.get('academicEnthusiasm') > 4 && State.get('academicEnthusiasm') < 9) {		//senior faculty branch
					return 6;
				}
				if (State.get('academicEnthusiasm') < 5) {				//beach
					return 5;
				}
			}
			case "finalBeach": 		//this should return epilogue eventually
				return 0;
			case "finalUN": 		//this should return epilogue eventually
				return 0;

			case "finalFaculty": 		//this should return epilogue eventually
				return 0;
		}
	}


	//returns specs for stories. If id == "all", will return all of them (for populating a menu)
	var getStorySpec = function(id) {

		var storySpec = [
		{
			id: "newExample",
			characters: {
				"protagonist" : {name: "Emma", nickname: "Em", gender: "female" },
				"char1" : {name: "Simon", nickname: "Simon", gender: "male" },
				"char2" : {name: "Eliza", nickname: "Liz", gender: "female" },
				"char3" : {name: "Michael", nickname: "Mike", gender: "male" },
				"char4" : {name: "Julia", nickname: "Jul", gender: "female" }
			},
			wishlist: [
				{ condition: "establishScene eq true"},
				{ condition: "introductions eq 2"}
			],
			dataFiles: ["text!newExampleData"],
			startState: [
				"set establishScene false",
				"set introductions 0"
			],
			UIvars: [
				"introductions"
			],
			mode: {
				type: "dialogue"
			}
		},
		{
			id: "travel",
			characters: {
				"emma" : {name: "Emma", nickname: "Em", gender: "female" }
			},
			wishlist: [
				{ condition: "establishScene eq true"},
				{ condition: "articlesRead eq 4" },
				{ condition: "endScene eq true" }
			],
			dataFiles: ["text!travelData"],
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
			],
			mode: {
				type: "narration"				//can be "narration", "dialogue", or "monologue"
			}
		},
		{
			id: "worker",
			characters: {
				"emma": {name: "Emma", nickname: "Em", gender: "female"},
				"rick" : {name: "Rick", nickname: "Rick", gender: "male"}
			},
			wishlist: [
				//{ condition: "reinforceSpecialty eq true" },		//this is triggered by grammars
				{ condition: "establishSpeciesMigration eq true" },
				{ condition: "confrontPlayerBeliefs eq true" },
				{ condition: "establishScene eq true"},
				{ condition: "endScene eq true" }
			],
			dataFiles: ["text!workerData"],
			startState: [
				"set confidence 1",
				"set optimism 0",
				"set specialty shrimp",
				"set emotional 0",
				"set serious chill",
				"set percent 0",			//this is what percent is current uncovered
				"set requiredPercent 0",
			],
			UIvars: [
				"confidence",
				"optimism"
			],
			mode: {
				type: "dialogue",
				initiator: "rick",
				respondent: "emma"
			}
		},
		{
			id: "lecture",
			characters: {
				"emma": {name: "Professor Banks", nickname: "Emma", gender: "female"},
				"franklin": {name: "Franklin", nickname: "Franklin", gender: "male"},
				"elika": {name: "Elika", nickname: "Elika", gender: "female"},
				"miguel": {name: "Miguel", nickname: "Miguel", gender: "male"}
			},
			wishlist: [
				{ condition: "droppedKnowledge eq 1", order: "first"},
				{ condition: "establishLecture eq true", order: "first"},
				{ condition: "callOnStudent eq true", persistent: true},
				{ condition: "giveLecture eq true", persistent: true },
				//{ condition: "reinforceSpecialty eq true" },		//this is triggered by grammars
				//{ condition: "demonstrateConfidence eq true" },	//need to write some confidence-hinging options
				{ condition: "establishSpecialtyInfo eq true" },
				{ condition: "respondToQuestion eq true" },
				{ condition: "classOver eq true", persistent: true }
			],
			dataFiles: ["text!lectureData"],
			startState: [
				"set career shrimp",
				"set questionsLeft 3",
				"set confidence 5",
				"set droppedKnowledge 0",
				"set calledFranklin false",
				"set calledElika false",
				"set calledShy false"
			],
			UIvars: [
				"confidence"
			],
			mode: {
				type: "monologue",
				initiator: "emma",
			}
		},
		{
			/*
				currently these wishlist items all proceed sequentially
			*/
			id: "generalist",
			characters: {
				"protagonist": {name: "Emma", nickname: "Em", gender: "female"},
				"ally": {name: "Zanita", nickname: "Z", gender: "female"},
				"antagonist": {name: "Shelly", nickname: "Shelly", gender: "female"}
			},
			wishlist: [
				{ condition: "setSetting eq true", order: "first" },		//debug item to let us mash settings together
				{ condition: "establishSpecialtyInfo eq true" },
				{ condition: "establishSetting eq true" },
				//{ condition: "establishAllyBackstory eq true" },
				//{ condition: "establishProtagRegrets eq true" },
				{ condition: "establishProtagBackstory eq true", persistent: true },
				{ condition: "setupChallenge eq true" },
				{ condition: "respondToChallenge eq true"},
				{ condition: "droppedKnowledge gte 2", persistent: true },
			],
			dataFiles: ["text!generalistData"],
			startState: [
				"set career unpicked",
				"set droppedKnowledge 0",
				"set confidence 5",
				"set patience 5",
				"set argue false",

			],
			UIvars: [
				"confidence",
				"patience",
				"career"
			],
			mode: {
				type: "dialogue",
				initiator: "ally",
				responder: "protagonist"
			}
		},
		{
			/*
				currently these wishlist items all proceed sequentially
			*/
			id: "dinner_argument",
			characters: {
				"protagonist": {name: "Emma", nickname: "Em", gender: "female"},
				"ally": {name: "Zanita", nickname: "Z", gender: "female"},
				"antagonist": {name: "Shelly", nickname: "Shelly", gender: "female"}
			},
			wishlist: [
				{ condition: "provokeArgument eq true"},
				{ condition: "establishSpecialtyInfo eq true" },
				{ condition: "establishSetting eq true" },
				{ condition: "establishAllyBackstory eq true" },
				{ condition: "establishProtagRegrets eq true" },
				{ condition: "establishEmmaBackstory eq true" },
				{ condition: "provokeConfidenceChoice eq true" },
				{ condition: "allyReassuresProtag eq true"},
				{ condition: "droppedKnowledge gte 1", persistent: true },
			],
			dataFiles: ["text!dinnerData"],
			startState: [
				"set career unpicked",
				"set droppedKnowledge 0",
				"set confidence 5",
				"set patience 5",
				"set argue true"
			],
			UIvars: [
				"confidence",
				"patience",
				"career"
			],
			mode: {
				type: "dialogue",
				initiator: "ally",
				responder: "protagonist"
			}
		},
		{
			/*
				currently these wishlist items all proceed sequentially
			*/
			id: "dinner",
			characters: {
				"protagonist": {name: "Emma", nickname: "Em", gender: "female"},
				"ally": {name: "Zanita", nickname: "Z", gender: "female"},
				"antagonist": {name: "Shelly", nickname: "Shelly", gender: "female"}
			},
			wishlist: [
				{ condition: "establishSpecialtyInfo eq true" },
				{ condition: "establishSetting eq true" },
				{ condition: "establishAllyBackstory eq true" },
				{ condition: "establishProtagRegrets eq true" },
				{ condition: "establishProtagBackstory eq true" },
				{ condition: "provokeConfidenceChoice eq true" },
				{ condition: "allyReassuresProtag eq true"},
		//		{ condition: "droppedKnowledge gte 2", persistent: true },
			],
			dataFiles: ["text!dinnerData"],
			startState: [
				"set career unpicked",
				"set droppedKnowledge 0",
				"set confidence 5",
				"set patience 5",
				"set argue false"
			],
			UIvars: [
				{
					"varName" : "confidence",
					"label" : "Confidence",
					"characters" : ["protagonist"],
					"affectedBy" : "both",
					"range" : [0,10]
				},
				{
					"varName" : "patience",
					"label" : "Patience",
					"characters" : ["protagonist"],
					"affectedBy" : "both",
					"range" : [0,10]
				},
				{
					"varName" : "career",
					"label" : "Career",
					"characters" : ["protagonist"],
					"affectedBy" : "both",
					"range" : [0,10]
				}
			],
			mode: {
				type: "dialogue",
				initiator: "ally",
				responder: "protagonist"
			}
		},
		{
			/*
				currently these wishlist items all proceed sequentially
			*/
			id: "undergradDinner",
			characters: {
				"protagonist": {name: "Emma", nickname: "Em", gender: "female"},
				"academicFriend": {name: "Zanita", nickname: "Z", gender: "female"},
				"nonAcademicFriend": {name: "Shelly", nickname: "Shelly", gender: "female"}
			},
			wishlist: [
				{ condition: "establishFriends eq true"},
				{ condition: "establishSettingDinner eq true"},
				{ condition: "establishDefenseTomorrow eq true"},
				{ condition: "EmmaDefenseFeeling eq true" },
				{ condition: "EmmaJobFutureBeat eq true" },
				{ condition: "EmmaClassTypeBeat eq true" },
				{ condition: "friendIsInAcademia eq true" },
				{ condition: "friendIsNotInAcademia eq true"},
				{ condition: "tension gte 4"},
				{ condition: "friendTensionRelieved eq true"},
				{ condition: "checkinWithDisagreer eq true"},
				{ condition: "inactivityIsBad eq true"},
				{ condition: "outro eq true", order: "last"},
			],
			//if you just want to use one file, uncomment this and comment out the big block below
			//dataFiles: ["text!undergradDinnerData_irapopor"],

			dataFiles: [
				"text!undergradDinnerData_talon",
				"text!undergradDinnerData_irapopor",
				"text!undergradDinnerData_sgadsby"],

			startState: [
				"set establishFriends false",
				"set establishSettingDinner false",
				"set establishDefenseTomorrow false",
				"set EmmaDefenseFeeling false",
				"set EmmaJobFutureBeat false",
				"set EmmaClassTypeBeat false",
				"set friendIsInAcademia false",
				"set friendIsNotInAcademia false",
				"set friendTension 0",
				"set friendTensionRelieved false",
				"set checkinWithDisagreer false",
				"set inactivityIsBad false",
				"set outro false",

				"set academicFriendRelationship 5",			//on a scale between 1 to 10 (1 bad, 10 best)
				"set nonAcademicFriendRelationship 5",		//on a scale between 1 to 10 (1 bad, 10 best)
				"set confidence 5",				//scale of 1 to 10, 10 highest
				"set academicEnthusiasm 5",		//scale of 1 to 10, 10 highest
				"set friendTension 0",			//scale of 1 to 10, ten is high tension
				"set tension 0"
			],
			UIvars: [
				{
					"varName" : "confidence",
					"label" : "Confidence",
					"characters" : ["protagonist"],
					"affectedBy" : "both",
					"range" : [0,10]
				},
				{
					"varName" : "academicEnthusiasm",
					"label" : "Academic Enthusiasm",
					"characters" : ["protagonist"],
					"affectedBy" : "narrative",
					"range" : [0,10]
				},
				{
					"varName" : "academicFriendRelationship",
					"label" : "Friendliness",
					"characters" : ["academicFriend"],
					"affectedBy" : "narrative",
					"range" : [0,10]
				},
				{
					"varName" : "nonAcademicFriendRelationship",
					"label" : "Friendliness",
					"characters" : ["nonAcademicFriend"],
					"affectedBy" : "narrative",
					"range" : [0,10]
				},
				{
					"varName" : "friendTension",
					"label" : "Tension",
					"characters" : ["protagonist", "academicFriend", "nonAcademicFriend"],
					"affectedBy" : "both",
					"range" : [0,10]
				}
			],
			mode: {
				type: "dialogue",
				initiator: "ally",
				responder: "protagonist"
			}
		},

		//undergrad lecture scene
		{
			/*
				currently these wishlist items all proceed sequentially
			*/
			id: "undergradLecture",
			characters: {
				"protagonist": {name: "Emma", nickname: "Em", gender: "female"},
				"skepticStudent": {name: "Franklin", nickname: "Franklin", gender: "male"},
				"shyStudent": {name: "Aiden", nickname: "Aiden", gender: "non-binary"},
				"enthusiasticStudent": {name: "Élika", nickname: "Élika", gender: "female"},
			},
			wishlist: [
				{ condition: "establishScene eq true" },
				{ condition: "establishDetails eq true" },
				{ condition: "establishComposure eq true" },
				{ condition: "establishStudents eq true" },
				{ condition: "enthusiasticStudent eq true"},
				{ condition: "skepticalStudent eq true"},
				{ condition: "shyStudent eq true"},
				{ condition: "talkToStudent gte 3" },
				{ condition: "followUp eq true" },
				{ condition: "lectureEnd eq true" },

			],
			//if you just want to use one file, uncomment this and comment out the big block below
			//dataFiles: ["text!undergradLecture-sjsherma"],

			dataFiles: [
				"text!undergradLecture_kply",
				"text!undergradLecture_sjsherma"
			],

			startState: [
				"set establishScene false",
				"set establishDetails false",
				"set establishComposure false",
				"set establishStudents false",
				"set enthusiasticStudent false",
				"set skepticalStudent false",
				"set shyStudent false",
				"set talkToStudent 0",
				"set followUp false",
				"set lectureEnd false",
				"set roomObjects 0",

				"set composure 10",
				"set curiosity 3",
				"set hope 5",
				"set optimism 7",

				"set questionsLeft 4",
			],
			UIvars: [
			{
					"varName" : "composure",
					"label" : "Composure",
					"characters" : ["protagonist"],
					"affectedBy" : "both",
					"range" : [0,10]
				},
				{
					"varName" : "curiosity",
					"label" : "Curiosity",
					"characters" : ["skepticStudent"],
					"affectedBy" : "both",
					"range" : [0,10]
				},
				{
					"varName" : "hope",
					"label" : "Hope",
					"characters" : ["shyStudent"],
					"affectedBy" : "both",
					"range" : [0,10]
				},
				{
					"varName" : "optimism",
					"label" : "Optimism",
					"characters" : ["enthusiasticStudent"],
					"affectedBy" : "both",
					"range" : [0,10]
				},
			],
			mode: {
				type: "monologue",
				initiator: "protagonist",
				responder: "protagonist",
			}
		},

		//undergrad dean scene
		{
			/*
				currently these wishlist items all proceed sequentially
			*/
			id: "undergradDean",
			characters: {
				"protagonist": {name: "Emma", gender: "female"},
				"authorityFigure": {name: "Dean Smith", gender: "male"}
			},
			wishlist: [
				{ condition: "sceneSet eq true"},
				{ condition: "troubleWithLecture eq true"},
				{ condition: "reasonForTrouble eq true"},
				{ condition: "pathChoiceMade eq true"},
				{ condition: "deanReaction eq true"},
			],
			//if you just want to use one file, uncomment this and comment out the big block below
			//dataFiles: ["text!undergradDean_sgadsby"],

			dataFiles: [
				"text!undergradDean_talon",
				"text!undergradDean_irapopor",
				"text!undergradDean_sgadsby"
			],

			startState: [
				"set sceneSet false",
				"set troubleWithLecture false",
				"set reasonForTrouble false",
				"set pathChoiceMade false",
				"set deanReaction false",
				"set tension 0",

				"set confidence 5",
				"set academicEnthusiasm 0",			//global stat
				"set curiosity 5",	//global stat
				"set hope 5",	//global stat
				"set optimism 5",	//global stat
				"set composure 5"
			],
			UIvars: [
				{
					"varName" : "tension",
					"label" : "Tension",
					"characters" : ["protagonist","authorityFigure"],
					"affectedBy" : "both",
					"range" : [0,10]
				}

			],
			mode: {
				type: "dialogue",
				initiator: "authorityFigure",
				responder: "protagonist"
			}
		},
		//undergrad travel scene
		{
			/*
				currently these wishlist items all proceed sequentially
			*/
			id: "undergradTravel",
			characters: {
				"protagonist": {name: "Emma", gender: "female"},
				"passenger": {name: "Phil", gender: "male"}
			},
			wishlist: [
				{ condition: "onAPlane eq true", persistent: true},
				{ condition: "reminisce eq true", persistent: true},
				{ condition: "talkExposition eq true", persistent: true},
				{ condition: "talksGiven gte 3"},
				{ condition: "dealWithSomeone eq true"},
				{ condition: "readSomething eq true"},
				{ condition: "acceptOrDeclineSomething eq true", persistent: true},
				{ condition: "outroForLanding eq true", persistent: true},
				{ condition: "goHome eq true"},
			],
			//if you just want to use one file, uncomment this and comment out the big block below
			dataFiles: ["text!undergradTravel_kply","text!undergradTravel_sjsherma"],
/*
			dataFiles: [
				"text!undergradDean_talon",
				"text!undergradDean_irapopor",
				"text!undergradDean_sgadsby"
			],
*/
			startState: [
				"set onAPlane false",
				"set reminisce false",
				"set talkExposition false",
				"set dealWithSomeone false",
				"set readSomething false",
				"set acceptOrDeclineSomething false",
				"set outroForLanding false",
				"set talksGiven 0",

				"set academicEnthusiasm 0",			//global stat
				"set curiosity 5",	//global stat
				"set hope 5",	//global stat
				"set optimism 5",	//global stat

				"set composure 5",
				"set carbonFootprint 0",
				"set fame 0"
			],
			UIvars: [
				{
					"varName" : "carbonFootprint",
					"label" : "Carbon Footprint",
					"characters" : ["protagonist"],
					"affectedBy" : "both",
					"range" : [0,10]
				},
				{
					"varName" : "composure",
					"label" : "Composure",
					"characters" : ["protagonist"],
					"affectedBy" : "both",
					"range" : [0,10]
				},
				{
					"varName" : "fame",
					"label" : "Fame",
					"characters" : ["protagonist"],
					"affectedBy" : "both",
					"range" : [0,10]
				}
			],
			mode: {
				type: "narration"
			}
		},
		//undergrad family dinner scene
		{
			/*
				currently these wishlist items all proceed sequentially
			*/
			id: "undergradFamilyDinner",
			characters: {
				"protagonist": {name: "Emma", gender: "female"},
				"dad": {name: "Dad", gender: "male"},
				"mom": {name: "Mom", gender: "female"}
			},
			wishlist: [
				{ condition: "familyIsFamily eq true"},
				{ condition: "atDinner eq true"},
				{ condition: "establishDinnerQuality eq true"},
				{ condition: "familyAsksSubject eq true"},
				{ condition: "dadChallenges eq true"},
				{ condition: "momChallenges eq true"},
				{ condition: "emmaDefends eq true"},
				{ condition: "otherParentDefends eq true"},
				{ condition: "parentsOfferSupport eq true"}
			],
			//if you just want to use one file, uncomment this and comment out the big block below
			dataFiles: ["text!undergradFamilyDinner_sgadsby", "text!undergradFamilyDinner_talon", "text!undergradFamilyDinner_irapopor"],
/*


			dataFiles: [
				"text!undergradDean_talon",
				"text!undergradDean_irapopor",
				"text!undergradDean_sgadsby"
			],
*/
			startState: [
				"set familyIsFamily false",
				"set atDinner false",
				"set establishDinnerQuality false",
				"set familyAsksSubject false",
				"set dadChallenges false",
				"set momChallenges false",
				"set emmaDefends false",
				"set otherParentDefends false",
				"set parentsOfferSupport false",

				"set academicEnthusiasm 0",			//global stat
				"set curiosity 5",	//global stat
				"set hope 5",	//global stat
				"set optimism 5",	//global stat

				"set confidence 5",
				"set hope 5",
				"set tension 5"
			],
			UIvars: [
				{
					"varName" : "confidence",
					"label" : "Confidence",
					"characters" : ["protagonist"],
					"affectedBy" : "both",
					"range" : [0,10]
				},
				{
					"varName" : "tension",
					"label" : "Tension",
					"characters" : ["protagonist", "dad", "mom"],
					"affectedBy" : "both",
					"range" : [0,10]
				}

			],
			mode: {
				type: "dialogue",
				initiator: "mom",
				responder: "protagonist"
			}
		},
		//undergrad UN scene scene
		{
			/*
				currently these wishlist items all proceed sequentially
			*/
			id: "undergradUN",
			characters: {
				"protagonist": {name: "Emma", gender: "female"},
				"UN1": {name: "Mikkel Retna", gender: "male"},
				"UN2": {name: "Kurt Branegan", gender: "male"}
			},
			wishlist: [
				{ condition: "atUNMeeting eq true"},
				{ condition: "representingResearchGroup eq true"},
				{ condition: "looksOverCommittee eq true"},
				{ condition: "introducesResearch eq true"},
				{ condition: "presentFacts eq true"},
				{ condition: "factsLooped eq 6"},
				{ condition: "kurtInterrupts eq true"},
				{ condition: "lostTrainOfThought eq true"},
				{ condition: "callForLocalAction eq true"},
				{ condition: "endingArgument eq true"},
				{ condition: "emmaReflection eq true"},
				{ condition: "inHallway eq true"}
			],
			//if you just want to use one file, uncomment this and comment out the big block below
			dataFiles: ["text!undergradUN_kply", "text!undergradUN_talon", "text!undergradUN_irapopor"],
/*


			dataFiles: [
				"text!undergradDean_talon",
				"text!undergradDean_irapopor",
				"text!undergradDean_sgadsby"
			],
*/
			startState: [
				"set atUNMeeting false",
				"set representingResearchGroup false",
				"set looksOverCommittee false",
				"set introducesResearch false",
				"set presentFacts false",
				"set kurtInterrupts false",
				"set lostTrainOfThought false",
				"set callForLocalAction false",
				"set endingArgument false",
				"set emmaReflection false",
				"set inHallway false",

				"set academicEnthusiasm 0",			//global stat
				"set curiosity 5",	//global stat
				"set hope 5",	//global stat
				"set optimism 5",	//global stat

				"set confidence 5",
				"set persuasion 0",
				"set composure 0",

				"set charactersIntroduced 0",
				"set factsPresented 0"
			],
			UIvars: [
				{
					"varName" : "confidence",
					"label" : "Confidence",
					"characters" : ["protagonist"],
					"affectedBy" : "both",
					"range" : [0,10]
				},
				{
					"varName" : "persuasion",
					"label" : "Persuasion",
					"characters" : ["UN1", "UN2"],
					"affectedBy" : "both",
					"range" : [0,10]
				},
				{
					"varName" : "composure",
					"label" : "Composure",
					"characters" : ["protagonist"],
					"affectedBy" : "both",
					"range" : [0,10]
				}

			],
			mode: {
				type: "narration"
			}
		},
		//undergrad Beach scene
		{
			/*
				currently these wishlist items all proceed sequentially
			*/
			id: "undergradBeach",
			characters: {
				"protagonist": {name: "Emma", gender: "female"},
				"volunteer": {name: "Rodrigo", gender: "male"}
			},
			wishlist: [
				{ condition: "onABeach eq true"},
				{ condition: "talkAboutSpecies eq true"},
				{ condition: "talkAboutUNPlan eq true"},
				{ condition: "rodrigoSaysPointless eq true"},
				{ condition: "emmaPositiveRejoinder eq true"},
				{ condition: "emmaNegativeRejoinder eq true"},
				{ condition: "rodrigoSadKnowledge eq true"},
				{ condition: "emmaPositiveSpin eq true"},
				{ condition: "emmaNegativeSpin eq true"},
				{ condition: "rodrigoSaysJob eq true"},
				{ condition: "sceneOutro eq true"}
			],
			//if you just want to use one file, uncomment this and comment out the big block below
			dataFiles: ["text!undergradBeach_madreed", "text!undergradBeach_sgadsby", "text!undergradBeach_sjsherma"],
/*


			dataFiles: [
				"text!undergradDean_talon",
				"text!undergradDean_irapopor",
				"text!undergradDean_sgadsby"
			],
*/
			startState: [
				"set onABeach false",
				"set talkAboutSpecies false",
				"set talkAboutUNPlan false",
				"set rodrigoSaysPointless false",
				"set emmaPositiveRejoinder false",
				"set emmaNegativeRejoinder false",
				"set rodrigoSadKnowledge false",
				"set emmaPositiveSpin false",
				"set emmaNegativeSpin false",
				"set rodrigoSaysJob false",
				"set sceneOutro false",

				"set academicEnthusiasm 0",			//global stat
				"set curiosity 5",	//global stat
				"set hope 5",	//global stat
				"set optimism 5",	//global stat

				"set patience 5",
				"set optimism 0",
				"set progression 0"
			],
			UIvars: [
				{
					"varName" : "patience",
					"label" : "Patience",
					"characters" : ["protagonist", "volunteer"],
					"affectedBy" : "both",
					"range" : [0,10]
				},
				{
					"varName" : "optimism",
					"label" : "Optimism",
					"characters" : ["protagnoist", "volunteer"],
					"affectedBy" : "both",
					"range" : [0,10]
				},
				{
					"varName" : "progression",
					"label" : "Progression",
					"characters" : ["protagonist"],
					"affectedBy" : "game",
					"range" : [0,10]
				}

			],
			mode: {
				type: "narration"
			}
		},
		//undergrad Faculty scene
		{
			/*
				currently these wishlist items all proceed sequentially
			*/
			id: "undergradFaculty",
			characters: {
				"protagonist": {name: "Emma", gender: "female"},
				"defendee": {name: "Emma's former student", gender: "male"}
			},
			wishlist: [
				{ condition: "establishSetting eq true"},
				{ condition: "establishAudience eq true"},
				{ condition: "establishClimateChangeEffects eq true"},
				{ condition: "studentGivesPresentation eq true"},
				{ condition: "emmaAsksQuestion eq true"},
				{ condition: "audienceAsksQuestion eq true"},
				{ condition: "facultyDeliberation eq true"},
				{ condition: "congratsToStudent eq true"}
			],
			//if you just want to use one file, uncomment this and comment out the big block below
			dataFiles: ["text!undergradFaculty_madreed", "text!undergradFaculty_kply", "text!undergradFaculty_sjsherma"],
/*


			dataFiles: [
				"text!undergradDean_talon",
				"text!undergradDean_irapopor",
				"text!undergradDean_sgadsby"
			],
*/
			startState: [
				"set establishSetting false",
				"set establishAudience false",
				"set establishClimateChangeEffects false",
				"set studentGivesPresentation false",
				"set emmaAsksQuestion false",
				"set audienceAsksQuestion false",
				"set facultyDeliberation false",
				"set congratsToStudent false",

				"set academicEnthusiasm 0",			//global stat
				"set curiosity 5",	//global stat
				"set hope 5",	//global stat
				"set optimism 5",	//global stat

				"set patience 5",
				"set optimism 0",
				"set progression 0"
			],
			UIvars: [

			],
			mode: {
				type: "narration"
			}
		},
		//SERENE TEST -- Serene, use this area to add wishlist items
		{
			/*
				currently these wishlist items all proceed sequentially
			*/
			id: "sereneTest",
			characters: {
				"protagonist": {name: "Emma", gender: "female"},
				"defendee": {name: "Emma's former student", gender: "male"}
			},
			wishlist: [
				{ condition: "establishSetting eq true"},
				{ condition: "establishAudience eq true"},
				{ condition: "establishClimateChangeEffects eq true"},
				{ condition: "studentGivesPresentation eq true"},
				{ condition: "emmaAsksQuestion eq true"},
				{ condition: "audienceAsksQuestion eq true"},
				{ condition: "facultyDeliberation eq true"},
				{ condition: "congratsToStudent eq true"}
			],
			//if you just want to use one file, uncomment this and comment out the big block below
			dataFiles: ["text!sjsherma_testfile"],

			startState: [
				"set establishSetting false",
				"set establishAudience false",
				"set establishClimateChangeEffects false",
				"set studentGivesPresentation false",
				"set emmaAsksQuestion false",
				"set audienceAsksQuestion false",
				"set facultyDeliberation false",
				"set congratsToStudent false",

				"set academicEnthusiasm 0",			//global stat
				"set curiosity 5",	//global stat
				"set hope 5",	//global stat
				"set optimism 5",	//global stat

				"set patience 5",
				"set optimism 0",
				"set progression 0"
			],
			UIvars: [

			],
			mode: {
				type: "narration"
			}
		},
		//IAN TEST -- Ian, use this area to add wishlist items
		{
			/*
				currently these wishlist items all proceed sequentially
			*/
			id: "ianTest",
			characters: {
				"protagonist": {name: "Emma", gender: "female"},
				"UN1": {name: "Mikkel Retna", gender: "male"},
				"UN2": {name: "Kurt Branegan", gender: "male"}
			},
			wishlist: [
				{ condition: "atUNMeeting eq true"}
			],
			//if you just want to use one file, uncomment this and comment out the big block below
			dataFiles: ["text!irapopor_testfile"],
/*


			dataFiles: [
				"text!undergradDean_talon",
				"text!undergradDean_irapopor",
				"text!undergradDean_sgadsby"
			],
*/
			startState: [
				"set atUNMeeting false",
				"set representingResearchGroup false",
				"set looksOverCommittee false",
				"set introducesResearch false",
				"set presentFacts false",
				"set kurtInterrupts false",
				"set lostTrainOfThought false",
				"set callForLocalAction false",
				"set endingArgument false",
				"set emmaReflection false",
				"set inHallway false",

				"set academicEnthusiasm 0",			//global stat
				"set curiosity 5",	//global stat
				"set hope 5",	//global stat
				"set optimism 5",	//global stat

				"set confidence 5",
				"set persuasion 0",
				"set composure 0"
			],
			UIvars: [
				{
					"varName" : "confidence",
					"label" : "Confidence",
					"characters" : ["protagonist"],
					"affectedBy" : "both",
					"range" : [0,10]
				},
				{
					"varName" : "persuasion",
					"label" : "Persuasion",
					"characters" : ["UN1", "UN2"],
					"affectedBy" : "both",
					"range" : [0,10]
				},
				{
					"varName" : "composure",
					"label" : "Composure",
					"characters" : ["protagonist"],
					"affectedBy" : "both",
					"range" : [0,10]
				}

			],
			mode: {
				type: "narration"
			}
		},
		//KEVIN TEST -- Kevin, use this area to add wishlist items
		{
			/*
				currently these wishlist items all proceed sequentially
			*/
			id: "kevinTest",
			characters: {
				"protagonist": {name: "Emma", gender: "female"},
				"UN1": {name: "Mikkel Retna", gender: "male"},
				"UN2": {name: "Kurt Branegan", gender: "male"}
			},
			wishlist: [
				{ condition: "atUNMeeting eq true"}
			],
			//if you just want to use one file, uncomment this and comment out the big block below
			dataFiles: ["text!kply_testfile"],
/*


			dataFiles: [
				"text!undergradDean_talon",
				"text!undergradDean_irapopor",
				"text!undergradDean_sgadsby"
			],
*/
			startState: [
				"set atUNMeeting false",
				"set representingResearchGroup false",
				"set looksOverCommittee false",
				"set introducesResearch false",
				"set presentFacts false",
				"set kurtInterrupts false",
				"set lostTrainOfThought false",
				"set callForLocalAction false",
				"set endingArgument false",
				"set emmaReflection false",
				"set inHallway false",

				"set academicEnthusiasm 0",			//global stat
				"set curiosity 5",	//global stat
				"set hope 5",	//global stat
				"set optimism 5",	//global stat

				"set confidence 5",
				"set persuasion 0",
				"set composure 0"
			],
			UIvars: [
				{
					"varName" : "confidence",
					"label" : "Confidence",
					"characters" : ["protagonist"],
					"affectedBy" : "both",
					"range" : [0,10]
				},
				{
					"varName" : "persuasion",
					"label" : "Persuasion",
					"characters" : ["UN1", "UN2"],
					"affectedBy" : "both",
					"range" : [0,10]
				},
				{
					"varName" : "composure",
					"label" : "Composure",
					"characters" : ["protagonist"],
					"affectedBy" : "both",
					"range" : [0,10]
				}

			],
			mode: {
				type: "narration"
			}
		},
		//TALON TEST -- Talon, use this area to add wishlist items
		{
			/*
				currently these wishlist items all proceed sequentially
			*/
			id: "talonTest",
			characters: {
				"protagonist": {name: "Emma", gender: "female"},
				"UN1": {name: "Mikkel Retna", gender: "male"},
				"UN2": {name: "Kurt Branegan", gender: "male"}
			},
			wishlist: [
				{ condition: "atUNMeeting eq true"}
			],
			//if you just want to use one file, uncomment this and comment out the big block below
			dataFiles: ["text!talon_testfile"],
/*


			dataFiles: [
				"text!undergradDean_talon",
				"text!undergradDean_irapopor",
				"text!undergradDean_sgadsby"
			],
*/
			startState: [
				"set atUNMeeting false",
				"set representingResearchGroup false",
				"set looksOverCommittee false",
				"set introducesResearch false",
				"set presentFacts false",
				"set kurtInterrupts false",
				"set lostTrainOfThought false",
				"set callForLocalAction false",
				"set endingArgument false",
				"set emmaReflection false",
				"set inHallway false",

				"set academicEnthusiasm 0",			//global stat
				"set curiosity 5",	//global stat
				"set hope 5",	//global stat
				"set optimism 5",	//global stat

				"set confidence 5",
				"set persuasion 0",
				"set composure 0"
			],
			UIvars: [
				{
					"varName" : "confidence",
					"label" : "Confidence",
					"characters" : ["protagonist"],
					"affectedBy" : "both",
					"range" : [0,10]
				},
				{
					"varName" : "persuasion",
					"label" : "Persuasion",
					"characters" : ["UN1", "UN2"],
					"affectedBy" : "both",
					"range" : [0,10]
				},
				{
					"varName" : "composure",
					"label" : "Composure",
					"characters" : ["protagonist"],
					"affectedBy" : "both",
					"range" : [0,10]
				}

			],
			mode: {
				type: "narration"
			}
		},
		//SUMMER TEST -- Summer, use this area to add wishlist items
		{
			/*
				currently these wishlist items all proceed sequentially
			*/
			id: "summerTest",
			characters: {
				"protagonist": {name: "Emma", gender: "female"},
				"volunteer": {name: "Rodrigo", gender: "male"}
			},
			wishlist: [
				{ condition: "onABeach eq true"}
			],
			//if you just want to use one file, uncomment this and comment out the big block below
			dataFiles: ["text!sgadsby_testfile"],
/*


			dataFiles: [
				"text!undergradDean_talon",
				"text!undergradDean_irapopor",
				"text!undergradDean_sgadsby"
			],
*/
			startState: [
				"set onABeach false",
				"set talkAboutSpecies false",
				"set talkAboutUNPlan false",
				"set rodrigoSaysPointless false",
				"set emmaPositiveRejoinder false",
				"set emmaNegativeRejoinder false",
				"set rodrigoSadKnowledge false",
				"set emmaPositiveSpin false",
				"set emmaNegativeSpin false",
				"set rodrigoSaysJob false",
				"set sceneOutro false",

				"set academicEnthusiasm 0",			//global stat
				"set curiosity 5",	//global stat
				"set hope 5",	//global stat
				"set optimism 5",	//global stat

				"set patience 5",
				"set optimism 0",
				"set progression 0"
			],
			UIvars: [
				{
					"varName" : "patience",
					"label" : "Patience",
					"characters" : ["protagonist", "volunteer"],
					"affectedBy" : "both",
					"range" : [0,10]
				},
				{
					"varName" : "optimism",
					"label" : "Optimism",
					"characters" : ["protagnoist", "volunteer"],
					"affectedBy" : "both",
					"range" : [0,10]
				},
				{
					"varName" : "progression",
					"label" : "Progression",
					"characters" : ["protagonist"],
					"affectedBy" : "game",
					"range" : [0,10]
				}

			],
			mode: {
				type: "narration"
			}
		},
		//MATT TEST -- Matt, use this area to add wishlist items
		{
			/*
				currently these wishlist items all proceed sequentially
			*/
			id: "mattTest",
			characters: {
				"protagonist": {name: "Emma", gender: "female"},
				"volunteer": {name: "Rodrigo", gender: "male"}
			},
			wishlist: [
				{ condition: "onABeach eq true"}
			],
			//if you just want to use one file, uncomment this and comment out the big block below
			dataFiles: ["text!madreed_testfile"],
/*


			dataFiles: [
				"text!undergradDean_talon",
				"text!undergradDean_irapopor",
				"text!undergradDean_sgadsby"
			],
*/
			startState: [
				"set onABeach false",
				"set talkAboutSpecies false",
				"set talkAboutUNPlan false",
				"set rodrigoSaysPointless false",
				"set emmaPositiveRejoinder false",
				"set emmaNegativeRejoinder false",
				"set rodrigoSadKnowledge false",
				"set emmaPositiveSpin false",
				"set emmaNegativeSpin false",
				"set rodrigoSaysJob false",
				"set sceneOutro false",

				"set academicEnthusiasm 0",			//global stat
				"set curiosity 5",	//global stat
				"set hope 5",	//global stat
				"set optimism 5",	//global stat

				"set patience 5",
				"set optimism 0",
				"set progression 0"
			],
			UIvars: [
				{
					"varName" : "patience",
					"label" : "Patience",
					"characters" : ["protagonist", "volunteer"],
					"affectedBy" : "both",
					"range" : [0,10]
				},
				{
					"varName" : "optimism",
					"label" : "Optimism",
					"characters" : ["protagnoist", "volunteer"],
					"affectedBy" : "both",
					"range" : [0,10]
				},
				{
					"varName" : "progression",
					"label" : "Progression",
					"characters" : ["protagonist"],
					"affectedBy" : "game",
					"range" : [0,10]
				}
			],
			mode: {
				type: "narration"
			}
		},
		//---------FINAL SCENES START HERE
		{
			id: "finalDinner",
			characters: {
				"protagonist": {name: "Emma", nickname: "Em", gender: "female"},
				"academicFriend": {name: "Zanita", nickname: "Z", gender: "female"},
				"nonAcademicFriend": {name: "Shelly", nickname: "Shelly", gender: "female"}
			},
			wishlist: [
				{ condition: "establishFriends eq true"},
				{ condition: "establishSettingDinner eq true"},
				{ condition: "establishDefenseTomorrow eq true"},
				{ condition: "EmmaDefenseFeeling eq true" },
				{ condition: "EmmaJobFutureBeat eq true" },
				{ condition: "EmmaClassTypeBeat eq true" },
				{ condition: "friendIsInAcademia eq true" },
				{ condition: "friendIsNotInAcademia eq true"},
				{ condition: "tension gte 4"},
				{ condition: "friendTensionRelieved eq true"},
				{ condition: "checkinWithDisagreer eq true"},
				{ condition: "inactivityIsBad eq true"},
				{ condition: "outro eq true", order: "last"},
			],
			dataFiles: [
				"text!finalDinner"
			],

			startState: [
				"set establishFriends false",
				"set establishSettingDinner false",
				"set establishDefenseTomorrow false",
				"set EmmaDefenseFeeling false",
				"set EmmaJobFutureBeat false",
				"set EmmaClassTypeBeat false",
				"set friendIsInAcademia false",
				"set friendIsNotInAcademia false",
				"set friendTension 0",
				"set friendTensionRelieved false",
				"set checkinWithDisagreer false",
				"set inactivityIsBad false",
				"set outro false",

				"set academicFriendRelationship 5",			//on a scale between 1 to 10 (1 bad, 10 best)
				"set nonAcademicFriendRelationship 5",		//on a scale between 1 to 10 (1 bad, 10 best)
				"set confidence 5",				//scale of 1 to 10, 10 highest
				"set academicEnthusiasm 5",		//scale of 1 to 10, 10 highest
				"set friendTension 0",			//scale of 1 to 10, ten is high tension
				"set tension 0"
			],
			UIvars: [
				{
					"varName" : "confidence",
					"label" : "Confidence",
					"characters" : ["protagonist"],
					"affectedBy" : "both",
					"range" : [0,10]
				},
				{
					"varName" : "academicEnthusiasm",
					"label" : "Academic Enthusiasm",
					"characters" : ["protagonist"],
					"affectedBy" : "narrative",
					"range" : [0,10]
				},
				{
					"varName" : "academicFriendRelationship",
					"label" : "Friendliness",
					"characters" : ["academicFriend"],
					"affectedBy" : "narrative",
					"range" : [0,10]
				},
				{
					"varName" : "nonAcademicFriendRelationship",
					"label" : "Friendliness",
					"characters" : ["nonAcademicFriend"],
					"affectedBy" : "narrative",
					"range" : [0,10]
				},
				{
					"varName" : "friendTension",
					"label" : "Tension",
					"characters" : ["protagonist", "academicFriend", "nonAcademicFriend"],
					"affectedBy" : "both",
					"range" : [0,10]
				}
			],
			mode: {
				type: "dialogue",
				initiator: "ally",
				responder: "protagonist"
			}
		},

		//final lecture scene
		{
			id: "finalLecture",
			characters: {
				"protagonist": {name: "Emma", nickname: "Em", gender: "female"},
				"skepticStudent": {name: "Franklin", nickname: "Franklin", gender: "male"},
				"shyStudent": {name: "Aiden", nickname: "Aiden", gender: "non-binary"},
				"enthusiasticStudent": {name: "Élika", nickname: "Élika", gender: "female"},
			},
			wishlist: [
				{ condition: "establishScene eq true" },
				{ condition: "establishDetails eq true" },
				{ condition: "establishComposure eq true" },
				{ condition: "establishStudents eq true" },
				{ condition: "enthusiasticStudent eq true"},
				{ condition: "skepticalStudent eq true"},
				{ condition: "shyStudent eq true"},
				{ condition: "talkToStudent gte 3" },
				{ condition: "followUp eq true" },
				{ condition: "lectureEnd eq true" },

			],
			dataFiles: [
				"text!finalLecture"
			],

			startState: [
				"set establishScene false",
				"set establishDetails false",
				"set establishComposure false",
				"set establishStudents false",
				"set enthusiasticStudent false",
				"set skepticalStudent false",
				"set shyStudent false",
				"set talkToStudent 0",
				"set followUp false",
				"set lectureEnd false",
				"set roomObjects 0",

				"set composure 10",
				"set curiosity 3",
				"set hope 5",
				"set optimism 7",

				"set questionsLeft 4",
			],
			UIvars: [
			{
					"varName" : "composure",
					"label" : "Composure",
					"characters" : ["protagonist"],
					"affectedBy" : "both",
					"range" : [0,10]
				},
				{
					"varName" : "curiosity",
					"label" : "Curiosity",
					"characters" : ["skepticStudent"],
					"affectedBy" : "both",
					"range" : [0,10]
				},
				{
					"varName" : "hope",
					"label" : "Hope",
					"characters" : ["shyStudent"],
					"affectedBy" : "both",
					"range" : [0,10]
				},
				{
					"varName" : "optimism",
					"label" : "Optimism",
					"characters" : ["enthusiasticStudent"],
					"affectedBy" : "both",
					"range" : [0,10]
				},
			],
			mode: {
				type: "monologue",
				initiator: "protagonist",
				responder: "protagonist",
			}
		},

		//final dean scene
		{
			id: "finalDean",
			characters: {
				"protagonist": {name: "Emma", gender: "female"},
				"authorityFigure": {name: "Dean Smith", gender: "male"}
			},
			wishlist: [
				{ condition: "sceneSet eq true"},
				{ condition: "troubleWithLecture eq true"},
				{ condition: "reasonForTrouble eq true"},
				{ condition: "pathChoiceMade eq true"},
				{ condition: "deanReaction eq true"},
			],
			dataFiles: [
				"text!finalDean"
			],

			startState: [
				"set sceneSet false",
				"set troubleWithLecture false",
				"set reasonForTrouble false",
				"set pathChoiceMade false",
				"set deanReaction false",
				"set tension 0",

				"set confidence 5",
				"set academicEnthusiasm 0",			//global stat
				"set curiosity 5",	//global stat
				"set hope 5",	//global stat
				"set optimism 5",	//global stat
				"set composure 5"
			],
			UIvars: [
				{
					"varName" : "tension",
					"label" : "Tension",
					"characters" : ["protagonist","authorityFigure"],
					"affectedBy" : "both",
					"range" : [0,10]
				}

			],
			mode: {
				type: "dialogue",
				initiator: "authorityFigure",
				responder: "protagonist"
			}
		},
		//final travel scene
		{
			id: "finalTravel",
			characters: {
				"protagonist": {name: "Emma", gender: "female"},
				"passenger": {name: "Phil", gender: "male"}
			},
			wishlist: [
				{ condition: "onAPlane eq true", persistent: true},
				{ condition: "reminisce eq true", persistent: true},
				{ condition: "talkExposition eq true", persistent: true},
				{ condition: "talksGiven gte 3"},
				{ condition: "dealWithSomeone eq true"},
				{ condition: "readSomething eq true"},
				{ condition: "acceptOrDeclineSomething eq true", persistent: true},
				{ condition: "outroForLanding eq true", persistent: true},
				{ condition: "goHome eq true"},
			],
			dataFiles: [
				"text!finalTravel"
			],
			startState: [
				"set onAPlane false",
				"set reminisce false",
				"set talkExposition false",
				"set dealWithSomeone false",
				"set readSomething false",
				"set acceptOrDeclineSomething false",
				"set outroForLanding false",
				"set talksGiven 0",

				"set academicEnthusiasm 0",			//global stat
				"set curiosity 5",	//global stat
				"set hope 5",	//global stat
				"set optimism 5",	//global stat

				"set composure 5",
				"set carbonFootprint 0",
				"set fame 0"
			],
			UIvars: [
				{
					"varName" : "carbonFootprint",
					"label" : "Carbon Footprint",
					"characters" : ["protagonist"],
					"affectedBy" : "both",
					"range" : [0,10]
				},
				{
					"varName" : "composure",
					"label" : "Composure",
					"characters" : ["protagonist"],
					"affectedBy" : "both",
					"range" : [0,10]
				},
				{
					"varName" : "fame",
					"label" : "Fame",
					"characters" : ["protagonist"],
					"affectedBy" : "both",
					"range" : [0,10]
				}
			],
			mode: {
				type: "narration"
			}
		},
		//final family dinner scene
		{
			id: "finalFamilyDinner",
			characters: {
				"protagonist": {name: "Emma", gender: "female"},
				"dad": {name: "Dad", gender: "male"},
				"mom": {name: "Mom", gender: "female"}
			},
			wishlist: [
				{ condition: "familyIsFamily eq true"},
				{ condition: "atDinner eq true"},
				{ condition: "establishDinnerQuality eq true"},
				{ condition: "familyAsksSubject eq true"},
				{ condition: "dadChallenges eq true"},
				{ condition: "momChallenges eq true"},
				{ condition: "emmaDefends eq true"},
				{ condition: "otherParentDefends eq true"},
				{ condition: "parentsOfferSupport eq true"}
			],
			dataFiles: [
				"text!finalFamilyDinner"
			],
			startState: [
				"set familyIsFamily false",
				"set atDinner false",
				"set establishDinnerQuality false",
				"set familyAsksSubject false",
				"set dadChallenges false",
				"set momChallenges false",
				"set emmaDefends false",
				"set otherParentDefends false",
				"set parentsOfferSupport false",

				"set academicEnthusiasm 0",			//global stat
				"set curiosity 5",	//global stat
				"set hope 5",	//global stat
				"set optimism 5",	//global stat

				"set confidence 5",
				"set hope 5",
				"set tension 5"
			],
			UIvars: [
				{
					"varName" : "confidence",
					"label" : "Confidence",
					"characters" : ["protagonist"],
					"affectedBy" : "both",
					"range" : [0,10]
				},
				{
					"varName" : "tension",
					"label" : "Tension",
					"characters" : ["protagonist", "dad", "mom"],
					"affectedBy" : "both",
					"range" : [0,10]
				}

			],
			mode: {
				type: "dialogue",
				initiator: "mom",
				responder: "protagonist"
			}
		},
		//final UN scene
		{
			id: "finalUN",
			characters: {
				"protagonist": {name: "Emma", gender: "female"},
				"UN1": {name: "Mikkel Retna", gender: "male"},
				"UN2": {name: "Kurt Branegan", gender: "male"}
			},
			wishlist: [
				{ condition: "atUNMeeting eq true"},
				{ condition: "representingResearchGroup eq true"},
				{ condition: "looksOverCommittee eq true"},
				{ condition: "introducesResearch eq true"},
				{ condition: "presentFacts eq true"},
				{ condition: "factsLooped eq 6"},
				{ condition: "kurtInterrupts eq true"},
				{ condition: "lostTrainOfThought eq true"},
				{ condition: "callForLocalAction eq true"},
				{ condition: "endingArgument eq true"},
				{ condition: "emmaReflection eq true"},
				{ condition: "inHallway eq true"}
			],
			dataFiles: [
				"text!finalUN"
			],
			startState: [
				"set atUNMeeting false",
				"set representingResearchGroup false",
				"set looksOverCommittee false",
				"set introducesResearch false",
				"set presentFacts false",
				"set kurtInterrupts false",
				"set lostTrainOfThought false",
				"set callForLocalAction false",
				"set endingArgument false",
				"set emmaReflection false",
				"set inHallway false",

				"set academicEnthusiasm 0",			//global stat
				"set curiosity 5",	//global stat
				"set hope 5",	//global stat
				"set optimism 5",	//global stat

				"set confidence 5",
				"set persuasion 0",
				"set composure 0",

				"set charactersIntroduced 0",
				"set factsPresented 0"
			],
			UIvars: [
				{
					"varName" : "confidence",
					"label" : "Confidence",
					"characters" : ["protagonist"],
					"affectedBy" : "both",
					"range" : [0,10]
				},
				{
					"varName" : "persuasion",
					"label" : "Persuasion",
					"characters" : ["UN1", "UN2"],
					"affectedBy" : "both",
					"range" : [0,10]
				},
				{
					"varName" : "composure",
					"label" : "Composure",
					"characters" : ["protagonist"],
					"affectedBy" : "both",
					"range" : [0,10]
				}

			],
			mode: {
				type: "narration"
			}
		},
		//final Beach scene
		{
			id: "finalBeach",
			characters: {
				"protagonist": {name: "Emma", gender: "female"},
				"volunteer": {name: "Rodrigo", gender: "male"}
			},
			wishlist: [
				{ condition: "onABeach eq true"},
				{ condition: "talkAboutSpecies eq true"},
				{ condition: "talkAboutUNPlan eq true"},
				{ condition: "rodrigoSaysPointless eq true"},
				{ condition: "emmaPositiveRejoinder eq true"},
				{ condition: "emmaNegativeRejoinder eq true"},
				{ condition: "rodrigoSadKnowledge eq true"},
				{ condition: "emmaPositiveSpin eq true"},
				{ condition: "emmaNegativeSpin eq true"},
				{ condition: "rodrigoSaysJob eq true"},
				{ condition: "sceneOutro eq true"}
			],
			dataFiles: [
				"text!finalBeach"
			],
			startState: [
				"set onABeach false",
				"set talkAboutSpecies false",
				"set talkAboutUNPlan false",
				"set rodrigoSaysPointless false",
				"set emmaPositiveRejoinder false",
				"set emmaNegativeRejoinder false",
				"set rodrigoSadKnowledge false",
				"set emmaPositiveSpin false",
				"set emmaNegativeSpin false",
				"set rodrigoSaysJob false",
				"set sceneOutro false",

				"set academicEnthusiasm 0",			//global stat
				"set curiosity 5",	//global stat
				"set hope 5",	//global stat
				"set optimism 5",	//global stat

				"set patience 5",
				"set optimism 0",
				"set progression 0"
			],
			UIvars: [
				{
					"varName" : "patience",
					"label" : "Patience",
					"characters" : ["protagonist", "volunteer"],
					"affectedBy" : "both",
					"range" : [0,10]
				},
				{
					"varName" : "optimism",
					"label" : "Optimism",
					"characters" : ["protagnoist", "volunteer"],
					"affectedBy" : "both",
					"range" : [0,10]
				},
				{
					"varName" : "progression",
					"label" : "Progression",
					"characters" : ["protagonist"],
					"affectedBy" : "game",
					"range" : [0,10]
				}

			],
			mode: {
				type: "narration"
			}
		},
		//final Faculty scene
		{
			id: "finalFaculty",
			characters: {
				"protagonist": {name: "Emma", gender: "female"},
				"defendee": {name: "Emma's former student", gender: "male"}
			},
			wishlist: [
				{ condition: "establishSetting eq true"},
				{ condition: "establishAudience eq true"},
				{ condition: "establishClimateChangeEffects eq true"},
				{ condition: "studentGivesPresentation eq true"},
				{ condition: "emmaAsksQuestion eq true"},
				{ condition: "audienceAsksQuestion eq true"},
				{ condition: "facultyDeliberation eq true"},
				{ condition: "congratsToStudent eq true"}
			],
			dataFiles: [
				"text!finalFaculty"
			],
			startState: [
				"set establishSetting false",
				"set establishAudience false",
				"set establishClimateChangeEffects false",
				"set studentGivesPresentation false",
				"set emmaAsksQuestion false",
				"set audienceAsksQuestion false",
				"set facultyDeliberation false",
				"set congratsToStudent false",

				"set academicEnthusiasm 0",			//global stat
				"set curiosity 5",	//global stat
				"set hope 5",	//global stat
				"set optimism 5",	//global stat

				"set patience 5",
				"set optimism 0",
				"set progression 0"
			],
			UIvars: [

			],
			mode: {
				type: "narration"
			}
		}

		]

		if (id == "all") { return storySpec; }
		else { return storySpec.filter(function(v) { return v.id === id; })[0]; }
	}

	var loadSceneIntro = function(id) {

		var sceneScreens = [
			{
				id : "newExample",
				text : "<p>This is an introduction for an example scene!</p>"
			},
			{
				id : "dinner",
				text : "<p>You are Emma Richards, a PhD student who studies the ocean.</p><p>Tomorrow, you'll be defending your thesis. Your friends have decided to throw a dinner party for you.</p><p>Choose what Emma says, but keep an eye on the task you're performing, too!</p>"
			},
			{
				id : "dinner_argument",
				text : "<p>You are Emma Richards, a PhD student who studies the ocean.</p><p>Tomorrow, you'll be defending your thesis. Your friends have decided to throw a dinner party for you.</p><p>However, your nerves may be getting in the way of your personal relationship with your best friend.<p>Choose what Emma says, but keep an eye on the task you're performing, too!</p>"
			},
			{
				id : "generalist",
				text : "<p>This is a version of the dinner scene done with more general chunks to test authoring.</p>"
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
			{
				id : "undergradDinner",
				text : "<p>You are Emma Richards, a PhD student who studies the ocean.</p><p>Tomorrow, you'll be defending your thesis. Your friends have decided to throw a dinner party for you.</p><p>Choose what Emma says, but keep an eye on the task you're performing, too!</p>"
			},
			{
				id : "undergradLecture",
				text : "<p>Time for your first lecture! Choose what to say to the students and answer any questions that they may have about climate change. Careful though, a bad performance may lead to an unhappy dean!</p>"
			},
			{
				id : "undergradDean",
				text : "<p>You've been having a somewhat rough time with your lectures. It looks like your superiors are starting to notice as Dean Smith has called you to come meet with him in private.</p><p>Choose what Emma says, but make sure to keep your cool or your job might be in jeoprardy!</p>"
			},
			{
				id : "undergradTravel",
				text : "<p>Your accomplishments in the academic field has set you on a plane to travel all over the world, delivering talks about climate change. Aim for fame, but keep an eye on your global footprint!</p>"
			},
			{
				id : "undergradFamilyDinner",
				text : "<p>You are going out to dinner with your parents. It's been a while since you've had a chance to sit down with them and tell them about what you have been up to.</p><p>Can you keep the tension low while staying true to your beliefs?</p>"
			},
			{
				id : "undergradUN",
				text : "<p>TODO: Scene description</p>"
			},
			{
				id : "undergradBeach",
				text : "<p>TODO: Scene description</p>"
			},
			{
				id : "undergradFaculty",
				text : "<p>TODO: Scene description</p>"
			},
			{
				id : "sereneTest",
				text : "<p>TODO: Scene description</p>"
			},
			{
				id : "mattTest",
				text : "<p>TODO: Scene description</p>"
			},
			{
				id : "talonTest",
				text : "<p>TODO: Scene description</p>"
			},
			{
				id : "summerTest",
				text : "<p>TODO: Scene description</p>"
			},
			{
				id : "kevinTest",
				text : "<p>TODO: Scene description</p>"
			},
			{
				id : "ianTest",
				text : "<p>TODO: Scene description</p>"
			},
			{
				id : "finalDinner",
				text : "<p>You are Emma Richards, a PhD student who studies the ocean.</p><p>Tomorrow, you'll be defending your thesis. Your friends have decided to throw a dinner party for you.</p><p>Choose what Emma says, but keep an eye on the task you're performing, too!</p>"
			},
			{
				id : "finalLecture",
				text : "<p>Time for your first lecture! Choose what to say to the students and answer any questions that they may have about climate change. Careful though, a bad performance may lead to an unhappy dean!</p>"
			},
			{
				id : "finalDean",
				text : "<p>You've been having a somewhat rough time with your lectures. It looks like your superiors are starting to notice as Dean Smith has called you to come meet with him in private.</p><p>Choose what Emma says, but make sure to keep your cool or your job might be in jeoprardy!</p>"
			},
			{
				id : "finalTravel",
				text : "<p>Your accomplishments in the academic field has set you on a plane to travel all over the world, delivering talks about climate change. Aim for fame, but keep an eye on your global footprint!</p>"
			},
			{
				id : "finalFamilyDinner",
				text : "<p>You are going out to dinner with your parents. It's been a while since you've had a chance to sit down with them and tell them about what you have been up to.</p><p>Can you keep the tension low while staying true to your beliefs?</p>"
			},
			{
				id : "finalUN",
				text : "<p>TODO: Scene description</p>"
			},
			{
				id : "finalBeach",
				text : "<p>TODO: Scene description</p>"
			},
			{
				id : "finalFaculty",
				text : "<p>TODO: Scene description</p>"
			},


		]
		var sceneText = sceneScreens.filter(function(v) { return v.id === id; })[0].text;
		Display.setSceneIntro(sceneText);
	};

	//loads background, for now this is based on scene id
	var loadBackground = function(id) {
		var sceneBgs = [
			{
				id : "newExample",
				src : "lecturehall.png"
			},
			{
				id : "dinner",
				src : "lecturehall.png"
			},
			{
				id : "dinner_argument",
				src : "lecturehall.png"
			},
			{
				id : "generalist",
				src : "lecturehall.png"
			},
			{
				id : "lecture",
				src : "lecturehall.png"
			},
			{
				id : "worker",
				src : "beach.png"
			},
			{
				id : "travel",
				src : "airplane.png"
			},
			{
				id : "undergradDinner",
				src : "dinner.png"
			},
			{
				id : "undergradLecture",
				src : "lecturehall.png"
			},
			{
				id : "undergradDean",
				src : "office.png"
			},
			{
				id : "undergradTravel",
				src : "airplane.png"
			},
			{
				id : "undergradFamilyDinner",
				src : "dinner.png"
			},
			{
				id : "undergradUN",
				src : "UNroom.png"
			},
			{
				id : "undergradBeach",
				src : "beach.png"
			},
			{
				id : "undergradFaculty",
				src : "lecturehall.png"
			},
			{
				id : "sereneTest",
				src : "lecturehall.png"
			},
			{
				id : "mattTest",
				src : "lecturehall.png"
			},
			{
				id : "ianTest",
				src : "lecturehall.png"
			},
			{
				id : "summerTest",
				src : "lecturehall.png"
			},
			{
				id : "kevinTest",
				src : "lecturehall.png"
			},
			{
				id : "talonTest",
				src : "lecturehall.png"
			},
			{
				id : "finalDinner",
				src : "dinner.png"
			},
			{
				id : "finalLecture",
				src : "lecturehall.png"
			},
			{
				id : "finalDean",
				src : "office.png"
			},
			{
				id : "finalTravel",
				src : "airplane.png"
			},
			{
				id : "finalFamilyDinner",
				src : "dinner.png"
			},
			{
				id : "finalUN",
				src : "UNroom.png"
			},
			{
				id : "finalBeach",
				src : "beach.png"
			},
			{
				id : "finalFaculty",
				src : "lecturehall.png"
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
				sceneId : "newExample",
				characters: [
					{
						id: "happy",
						src: "happy.png",
						state: ["introductions gt 0"]
					},
				]
			},
			{
				sceneId : "dinner",
				characters: [
					{
						id: "protagonist",
						graphics: "char3",
						age: "20s",
						states: [	//happy, neutral, upset
							{ state: ["default"], tag: "happy"}
						]
					},
					{
						id: "ally",
						graphics: "char12",
						age: "20s",
						states: [	//happy, neutral, upset, confused
							{ state: ["default"], tag: "happy" }
						]
					},
					{
						id: "antagonist",
						graphics: "char7",
						age: "20s",
						states: [	//happy, neutral, confused
							{ state: ["default"], tag: "happy" }
						]
					}
				]
			},
			{
				sceneId : "dinner_argument",
				characters: [
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
				sceneId : "generalist",
				characters: [
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
				sceneId : "lecture",
				characters: [
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
				sceneId : "worker",
				characters: [
					{
						id: "happy",
						src: "happy.png",
						state: ["confidence gt 0"]
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
				sceneId : "travel",
				characters: [
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
				sceneId : "undergradDinner",
				characters: [
					{
						id: "protagonist",
						graphics: "char3",
						age: "20s",
						states: [	//happy, neutral, upset
							{ state: ["default"], tag: "neutral"},
							{ state: ["tension gte 2"], tag: "upset"}
						]
					},
					{
						id: "academicFriend",
						graphics: "char12",
						age: "20s",
						states: [	//happy, neutral, upset, confused
							{ state: ["default"], tag: "happy" }
						]
					},
					{
						id: "nonAcademicFriend",
						graphics: "char7",
						age: "20s",
						states: [	//happy, neutral, confused
							{ state: ["default"], tag: "happy" }
						]
					}
				]

			},
			{
				sceneId : "undergradLecture",
				characters: [
					{
						id: "protagonist",
						graphics: "char3",
						age: "20s",
						states: [	//happy, neutral, upset
							{ state: ["default"], tag: "happy"}
						]
					},
					{
						id: "skepticStudent",
						graphics: "char9",
						age: "20s",
						states: [	//happy, neutral, upset
							{ state: ["default"], tag: "happy" }
						]
					},
					{
						id: "shyStudent",
						graphics: "char8",
						age: "20s",
						states: [	//happy, neutral, upset
							{ state: ["default"], tag: "happy" }
						]
					},
					{
						id: "enthusiasticStudent",
						graphics: "char2",
						age: "20s",
						states: [	//happy, neutral, upset
							{ state: ["default"], tag: "happy" }
						]
					}
				]
			},
			{
				sceneId : "undergradDean",
				characters: [
					{
						id: "protagonist",
						graphics: "char3",
						age: "20s",
						states: [	//happy, neutral, upset
							{ state: ["default"], tag: "happy"}
						]
					},
					{
						id: "authorityFigure",
						graphics: "char1",
						age: "50s",
						states: [	//"happy", "neutral", "disappointed"
							{ state: ["default"], tag: "happy" }
						]
					}
				]
			},
			{
				sceneId : "undergradTravel",
				characters: [
					{
						id: "protagonist",
						graphics: "char3",
						age: "20s",
						states: [	//happy, neutral, upset
							{ state: ["default"], tag: "happy"}
						]
					},
					{
						id: "passenger",
						graphics: "char9",
						age: "40s",
						states: [	//happy, neutral, upset
							{ state: ["default"], tag: "happy" }
						]
					}
				]
			},
			{
				sceneId : "undergradFamilyDinner",
				characters: [
					{
						id: "protagonist",
						graphics: "char3",
						age: "40s",
						states: [	//happy, neutral, upset
							{ state: ["default"], tag: "happy"}
						]
					},
					{
						id: "dad",
						graphics: "char4",
						age: "40s",
						states: [	//happy, neutral, upset
							{ state: ["default"], tag: "happy" }
						]
					},
					{
						id: "mom",
						graphics: "char5",
						age: "50s",
						states: [	//happy, neutral, upset
							{ state: ["default"], tag: "happy" }
						]
					}
				]
			},
			{
				sceneId : "undergradUN",
				characters: [
					{
						id: "protagonist",
						graphics: "char3",
						age: "40s",
						states: [	//happy, neutral, upset
							{ state: ["confidence gte 7"], tag: "happy"},
							{ state: ["composure gte 7"], tag: "happy"},
							{ state: ["confidence lte 3"], tag: "upset"},
							{ state: ["composure lte 3"], tag: "upset"},
							{ state: ["default"], tag: "happy"}
						]
					},
					{
						id: "UN1",
						graphics: "char11",
						age: "40s",
						states: [	//neutral, smug, upset
							{ state: ["default"], tag: "neutral" },
							{ state: ["persuasion gte 8"], tag: "smug"},
							{ state: ["persuasion lte 3"], tag: "upset"}

						]
					},
					{
						id: "UN2",
						graphics: "char10",
						age: "30s",
						states: [	//neutral, smug, upset
							{ state: ["persuasion lte 3"], tag: "smug"},
							{ state: ["persuasion gte 8"], tag: "upset"},
							{ state: ["default"], tag: "neutral" }
						]
					}
				]
			},
			{
				sceneId : "undergradBeach",
				characters: [
					{
						id: "protagonist",
						graphics: "char3",
						age: "40s",
						states: [	//happy, neutral, upset
							{ state: ["default"], tag: "neutral"},
							{ state: ["patience lt 3"], tag: "upset"},
							{ state: ["patience gte 5"], tag: "happy"},

						],
					},
					{
						id: "volunteer",
						graphics: "char6",
						age: "20s",
						states: [	//happy, neutral, upset, confused
							{ state: ["patience lt 3"], tag: "upset"},
							{ state: ["default"], tag: "neutral" },
						],
					},
				],
			},
			{
				sceneId : "undergradFaculty",
				characters: [
					{
						id: "protagonist",
						graphics: "char3",
						age: "40s",
						states: [	//happy, neutral, upset
							{ state: ["default"], tag: "neutral"}

						],
					},
					{
						id: "defendee",
						graphics: "char6",
						age: "20s",
						states: [
							{ state: ["default"], tag: "neutral" }
						],
					},
				],
			},
			{
				sceneId : "sereneTest",
				characters: [
					{
						id: "protagonist",
						graphics: "char3",
						age: "20s",
						states: [	//happy, neutral, upset
							{ state: ["default"], tag: "happy"}
						]
					},
					{
						id: "passenger",
						graphics: "char12",
						age: "20s",
						states: [	//happy, neutral, upset, confused
							{ state: ["default"], tag: "happy" }
						]
					}
				]
			},
			{
				sceneId : "ianTest",
				characters: [
					{
						id: "protagonist",
						graphics: "char3",
						age: "20s",
						states: [	//happy, neutral, upset
							{ state: ["default"], tag: "happy"}
						]
					},
					{
						id: "UN1",
						graphics: "char11",
						age: "40s",
						states: [	//happy, neutral, upset, confused
							{ state: ["default"], tag: "neutral" }
						]
					},
					{
						id: "UN2",
						graphics: "char10",
						age: "30s",
						states: [	//happy, neutral, upset, confused
							{ state: ["default"], tag: "neutral" }
						]
					}
				]
			},
			{
				sceneId : "talonTest",
				characters: [
					{
						id: "protagonist",
						graphics: "char3",
						age: "20s",
						states: [	//happy, neutral, upset
							{ state: ["default"], tag: "happy"}
						]
					},
					{
						id: "UN1",
						graphics: "char11",
						age: "40s",
						states: [	//happy, neutral, upset, confused
							{ state: ["default"], tag: "neutral" }
						]
					},
					{
						id: "UN2",
						graphics: "char10",
						age: "30s",
						states: [	//happy, neutral, upset, confused
							{ state: ["default"], tag: "neutral" }
						]
					}
				]
			},
			{
				sceneId : "kevinTest",
				characters: [
					{
						id: "protagonist",
						graphics: "char3",
						age: "20s",
						states: [	//happy, neutral, upset
							{ state: ["default"], tag: "happy"}
						]
					},
					{
						id: "UN1",
						graphics: "char11",
						age: "40s",
						states: [	//happy, neutral, upset, confused
							{ state: ["default"], tag: "neutral" }
						]
					},
					{
						id: "UN2",
						graphics: "char10",
						age: "30s",
						states: [	//happy, neutral, upset, confused
							{ state: ["default"], tag: "neutral" }
						]
					}
				]
			},
			{
				sceneId : "summerTest",
				characters: [
					{
						id: "protagonist",
						graphics: "char3",
						age: "20s",
						states: [	//happy, neutral, upset
							{ state: ["default"], tag: "happy"}
						]
					},
					{
						id: "volunteer",
						graphics: "char6",
						age: "20s",
						states: [	//happy, neutral, upset, confused
							{ state: ["default"], tag: "happy" }
						]
					}
				]
			},
			{
				sceneId : "mattTest",
				characters: [
					{
						id: "protagonist",
						graphics: "char3",
						age: "20s",
						states: [	//happy, neutral, upset
							{ state: ["default"], tag: "happy"}
						]
					},
					{
						id: "volunteer",
						graphics: "char6",
						age: "20s",
						states: [	//happy, neutral, upset, confused
							{ state: ["default"], tag: "happy" }
						]
					}
				]
			},
			{
				sceneId : "finalDinner",
				characters: [
					{
						id: "protagonist",
						graphics: "char3",
						age: "20s",
						states: [	//happy, neutral, upset
							{ state: ["default"], tag: "neutral"},
							{ state: ["tension gte 2"], tag: "upset"}
						]
					},
					{
						id: "academicFriend",
						graphics: "char12",
						age: "20s",
						states: [	//happy, neutral, upset, confused
							{ state: ["default"], tag: "happy" }
						]
					},
					{
						id: "nonAcademicFriend",
						graphics: "char7",
						age: "20s",
						states: [	//happy, neutral, confused
							{ state: ["default"], tag: "happy" }
						]
					}
				]

			},
			{
				sceneId : "finalLecture",
				characters: [
					{
						id: "protagonist",
						graphics: "char3",
						age: "20s",
						states: [	//happy, neutral, upset
							{ state: ["default"], tag: "happy"}
						]
					},
					{
						id: "skepticStudent",
						graphics: "char9",
						age: "20s",
						states: [	//happy, neutral, upset
							{ state: ["default"], tag: "happy" }
						]
					},
					{
						id: "shyStudent",
						graphics: "char8",
						age: "20s",
						states: [	//happy, neutral, upset
							{ state: ["default"], tag: "happy" }
						]
					},
					{
						id: "enthusiasticStudent",
						graphics: "char2",
						age: "20s",
						states: [	//happy, neutral, upset
							{ state: ["default"], tag: "happy" }
						]
					}
				]
			},
			{
				sceneId : "finalDean",
				characters: [
					{
						id: "protagonist",
						graphics: "char3",
						age: "20s",
						states: [	//happy, neutral, upset
							{ state: ["default"], tag: "happy"}
						]
					},
					{
						id: "authorityFigure",
						graphics: "char1",
						age: "50s",
						states: [	//"happy", "neutral", "disappointed"
							{ state: ["default"], tag: "happy" }
						]
					}
				]
			},
			{
				sceneId : "finalTravel",
				characters: [
					{
						id: "protagonist",
						graphics: "char3",
						age: "20s",
						states: [	//happy, neutral, upset
							{ state: ["default"], tag: "happy"}
						]
					},
					{
						id: "passenger",
						graphics: "char9",
						age: "40s",
						states: [	//happy, neutral, upset
							{ state: ["default"], tag: "happy" }
						]
					}
				]
			},
			{
				sceneId : "finalFamilyDinner",
				characters: [
					{
						id: "protagonist",
						graphics: "char3",
						age: "40s",
						states: [	//happy, neutral, upset
							{ state: ["default"], tag: "happy"}
						]
					},
					{
						id: "dad",
						graphics: "char4",
						age: "40s",
						states: [	//happy, neutral, upset
							{ state: ["default"], tag: "happy" }
						]
					},
					{
						id: "mom",
						graphics: "char5",
						age: "50s",
						states: [	//happy, neutral, upset
							{ state: ["default"], tag: "happy" }
						]
					}
				]
			},
			{
				sceneId : "finalUN",
				characters: [
					{
						id: "protagonist",
						graphics: "char3",
						age: "40s",
						states: [	//happy, neutral, upset
							{ state: ["confidence gte 7"], tag: "happy"},
							{ state: ["composure gte 7"], tag: "happy"},
							{ state: ["confidence lte 3"], tag: "upset"},
							{ state: ["composure lte 3"], tag: "upset"},
							{ state: ["default"], tag: "happy"}
						]
					},
					{
						id: "UN1",
						graphics: "char11",
						age: "40s",
						states: [	//neutral, smug, upset
							{ state: ["default"], tag: "neutral" },
							{ state: ["persuasion gte 8"], tag: "smug"},
							{ state: ["persuasion lte 3"], tag: "upset"}

						]
					},
					{
						id: "UN2",
						graphics: "char10",
						age: "30s",
						states: [	//neutral, smug, upset
							{ state: ["persuasion lte 3"], tag: "smug"},
							{ state: ["persuasion gte 8"], tag: "upset"},
							{ state: ["default"], tag: "neutral" }
						]
					}
				]
			},
			{
				sceneId : "finalBeach",
				characters: [
					{
						id: "protagonist",
						graphics: "char3",
						age: "40s",
						states: [	//happy, neutral, upset
							{ state: ["default"], tag: "neutral"},
							{ state: ["patience lt 3"], tag: "upset"},
							{ state: ["patience gte 5"], tag: "happy"},

						],
					},
					{
						id: "volunteer",
						graphics: "char6",
						age: "20s",
						states: [	//happy, neutral, upset, confused
							{ state: ["patience lt 3"], tag: "upset"},
							{ state: ["default"], tag: "neutral" },
						],
					},
				],
			},
			{
				sceneId : "finalFaculty",
				characters: [
					{
						id: "protagonist",
						graphics: "char3",
						age: "40s",
						states: [	//happy, neutral, upset
							{ state: ["default"], tag: "neutral"}

						],
					},
					{
						id: "defendee",
						graphics: "char6",
						age: "20s",
						states: [
							{ state: ["default"], tag: "neutral" }
						],
					},
				],
			},
		];

		State.avatars = avatarSpec.filter(function(v) { return v.sceneId === id; })[0].characters;

		Display.setAvatars(State);
		Display.createStats();
	}

	//validates the backgrounds and character avatars for the given scene
	var validateArtAssets = function(id) {

		var sceneData = getStorySpec(id);

		for (char in sceneData.characters) {		//loop through to make sure each character has a default avatar
			var passed = false;
			for (var y=0; y < State.avatars.length; y++) {
				if (State.avatars[y].id == char) {
					for (var x=0; x < State.avatars[y].states.length; x++) {
						if (State.avatars[y].states[x].state == "default") {
							passed = true;
						}
					}
				}
			}
			if (!passed) {
				console.warn("Warning! No default avatar set for " + char + "!");
			}
		}
		//TODO: warn if there are characters in avatars that aren't in scene
		//TODO: warn if avatar depends on state var that is not a scene state var
	}

	/*
		This will eventually be replaced with more complex stuff before passing
		off to game.js
	*/
	var startGame = function(id) {
		var Game = require("Game");

		var gameResources = [
			{
				id: "newExample",
				aspFilepaths: ['asp-phaser-generator-2/test/fixtures/game-10_2_handModified.lp'],
				gameString : "var variables;function preload(){};function create(){};function update(){};function getAspGoals(){}"
			},
			{
				id: "undergradDinner",
				aspFilepaths: [
					"GameGenerator/ASP_cleaned/games/dinner_1.lp",
					"GameGenerator/ASP_cleaned/games/dinner_2.lp",
					"GameGenerator/ASP_cleaned/games/dinner_3.lp",
					"GameGenerator/ASP_cleaned/games/dinner_4.lp",
					"GameGenerator/ASP_cleaned/games/dinner_5.lp",
					"GameGenerator/ASP_cleaned/games/dinner_6.lp",
					"GameGenerator/ASP_cleaned/games/dinner_7.lp",
					"GameGenerator/ASP_cleaned/games/dinner_8.lp",
					"GameGenerator/ASP_cleaned/games/dinner_9.lp",
					"GameGenerator/ASP_cleaned/games/dinner_10.lp",
					"GameGenerator/ASP_cleaned/games/dinner_11.lp",
					"GameGenerator/ASP_cleaned/games/dinner_12.lp",
					"GameGenerator/ASP_cleaned/games/dinner_13.lp",
					"GameGenerator/ASP_cleaned/games/dinner_14.lp",
					"GameGenerator/ASP_cleaned/games/dinner_15.lp",
					"GameGenerator/ASP_cleaned/games/dinner_16.lp",
					"GameGenerator/ASP_cleaned/games/dinner_17.lp",
					"GameGenerator/ASP_cleaned/games/dinner_18.lp",
					"GameGenerator/ASP_cleaned/games/dinner_19.lp",
					"GameGenerator/ASP_cleaned/games/dinner_20.lp",
					"GameGenerator/ASP_cleaned/games/dinner_21.lp",
					"GameGenerator/ASP_cleaned/games/dinner_22.lp",
					"GameGenerator/ASP_cleaned/games/dinner_23.lp",
					"GameGenerator/ASP_cleaned/games/dinner_24.lp",
					"GameGenerator/ASP_cleaned/games/dinner_25.lp",
				],
				gameString : "var variables;function preload(){};function create(){};function update(){};function getAspGoals(){}"
			},
			{
				id: "undergradLecture",
				aspFilepaths: [
					"GameGenerator/ASP_cleaned/games/lecture_1.lp",
					"GameGenerator/ASP_cleaned/games/lecture_2.lp",
					"GameGenerator/ASP_cleaned/games/lecture_3.lp",
					"GameGenerator/ASP_cleaned/games/lecture_4.lp",
					"GameGenerator/ASP_cleaned/games/lecture_5.lp",
					"GameGenerator/ASP_cleaned/games/lecture_6.lp",
					"GameGenerator/ASP_cleaned/games/lecture_7.lp",
					"GameGenerator/ASP_cleaned/games/lecture_8.lp",
					"GameGenerator/ASP_cleaned/games/lecture_9.lp",
				    "GameGenerator/ASP_cleaned/games/lecture_10.lp",
					"GameGenerator/ASP_cleaned/games/lecture_11.lp",
					"GameGenerator/ASP_cleaned/games/lecture_12.lp",
					"GameGenerator/ASP_cleaned/games/lecture_13.lp",
					"GameGenerator/ASP_cleaned/games/lecture_14.lp",
					"GameGenerator/ASP_cleaned/games/lecture_15.lp",
					"GameGenerator/ASP_cleaned/games/lecture_16.lp",
					"GameGenerator/ASP_cleaned/games/lecture_17.lp",
					"GameGenerator/ASP_cleaned/games/lecture_18.lp",
					"GameGenerator/ASP_cleaned/games/lecture_19.lp",
					"GameGenerator/ASP_cleaned/games/lecture_20.lp",
					"GameGenerator/ASP_cleaned/games/lecture_21.lp",
					"GameGenerator/ASP_cleaned/games/lecture_22.lp",
					"GameGenerator/ASP_cleaned/games/lecture_23.lp",
					"GameGenerator/ASP_cleaned/games/lecture_24.lp",
					"GameGenerator/ASP_cleaned/games/lecture_25.lp",
				],
				gameString : "var variables;function preload(){};function create(){};function update(){};function getAspGoals(){}"
			},
			{
				id: "undergradDean",
				aspFilepaths: [
					"GameGenerator/ASP_cleaned/games/dean_1.lp",
					"GameGenerator/ASP_cleaned/games/dean_2.lp",
					"GameGenerator/ASP_cleaned/games/dean_3.lp",
					"GameGenerator/ASP_cleaned/games/dean_4.lp",
					"GameGenerator/ASP_cleaned/games/dean_5.lp",
					"GameGenerator/ASP_cleaned/games/dean_6.lp",
					"GameGenerator/ASP_cleaned/games/dean_7.lp",
					"GameGenerator/ASP_cleaned/games/dean_8.lp",
					"GameGenerator/ASP_cleaned/games/dean_9.lp",
					"GameGenerator/ASP_cleaned/games/dean_10.lp",
					"GameGenerator/ASP_cleaned/games/dean_11.lp",
					"GameGenerator/ASP_cleaned/games/dean_12.lp",
					"GameGenerator/ASP_cleaned/games/dean_13.lp",
					"GameGenerator/ASP_cleaned/games/dean_14.lp",
					"GameGenerator/ASP_cleaned/games/dean_15.lp",
					"GameGenerator/ASP_cleaned/games/dean_16.lp",
					"GameGenerator/ASP_cleaned/games/dean_17.lp",
					"GameGenerator/ASP_cleaned/games/dean_18.lp",
					"GameGenerator/ASP_cleaned/games/dean_19.lp",
					"GameGenerator/ASP_cleaned/games/dean_20.lp",
					"GameGenerator/ASP_cleaned/games/dean_21.lp",
					"GameGenerator/ASP_cleaned/games/dean_22.lp",
					"GameGenerator/ASP_cleaned/games/dean_23.lp",
					"GameGenerator/ASP_cleaned/games/dean_24.lp",
					"GameGenerator/ASP_cleaned/games/dean_25.lp",
				],
				gameString : "var variables;function preload(){};function create(){};function update(){};function getAspGoals(){}"
			},
			{
				id: "undergradTravel",
				aspFilepaths: ['asp-phaser-generator-2/test/fixtures/game-10_2_handModified.lp'],
				gameString : "var variables;function preload(){};function create(){};function update(){};function getAspGoals(){}"
			},
			{
				id: "undergradFamilyDinner",
				aspFilepaths: ['asp-phaser-generator-2/test/fixtures/game-10_2_handModified.lp'],
				gameString : "var variables;function preload(){};function create(){};function update(){};function getAspGoals(){}"
			},
			{
				id: "undergradUN",
				aspFilepaths: ['asp-phaser-generator-2/test/fixtures/games-5-18/lecture_test_10.lp'],
				gameString : "var variables;function preload(){};function create(){};function update(){};function getAspGoals(){}"
			},
			{
				id: "undergradBeach",
				aspFilepaths:  [
				    "GameGenerator/ASP_cleaned/games/lecture_1.lp",
					"GameGenerator/ASP_cleaned/games/lecture_2.lp",
					"GameGenerator/ASP_cleaned/games/lecture_3.lp",
					"GameGenerator/ASP_cleaned/games/lecture_4.lp",
					"GameGenerator/ASP_cleaned/games/lecture_5.lp",
					"GameGenerator/ASP_cleaned/games/lecture_6.lp",
					"GameGenerator/ASP_cleaned/games/lecture_7.lp",
					"GameGenerator/ASP_cleaned/games/lecture_8.lp",
					"GameGenerator/ASP_cleaned/games/lecture_9.lp",
					"GameGenerator/ASP_cleaned/games/lecture_10.lp",
					"GameGenerator/ASP_cleaned/games/lecture_11.lp",
					"GameGenerator/ASP_cleaned/games/lecture_12.lp",
					"GameGenerator/ASP_cleaned/games/lecture_13.lp",
					"GameGenerator/ASP_cleaned/games/lecture_14.lp",
					"GameGenerator/ASP_cleaned/games/lecture_15.lp",
					"GameGenerator/ASP_cleaned/games/lecture_16.lp",
					"GameGenerator/ASP_cleaned/games/lecture_17.lp",
					"GameGenerator/ASP_cleaned/games/lecture_18.lp",
					"GameGenerator/ASP_cleaned/games/lecture_19.lp",
					"GameGenerator/ASP_cleaned/games/lecture_20.lp",
					"GameGenerator/ASP_cleaned/games/lecture_21.lp",
					"GameGenerator/ASP_cleaned/games/lecture_22.lp",
					"GameGenerator/ASP_cleaned/games/lecture_23.lp",
					"GameGenerator/ASP_cleaned/games/lecture_24.lp",
					"GameGenerator/ASP_cleaned/games/lecture_25.lp",
				],
				gameString : "var variables;function preload(){};function create(){};function update(){};function getAspGoals(){}"
			},
			{
				id: "undergradFaculty",
				aspFilepaths: [
					"GameGenerator/ASP_cleaned/games/dean_1.lp",
					"GameGenerator/ASP_cleaned/games/dean_2.lp",
					"GameGenerator/ASP_cleaned/games/dean_3.lp",
					"GameGenerator/ASP_cleaned/games/dean_4.lp",
					"GameGenerator/ASP_cleaned/games/dean_5.lp",
					"GameGenerator/ASP_cleaned/games/dean_6.lp",
					"GameGenerator/ASP_cleaned/games/dean_7.lp",
					"GameGenerator/ASP_cleaned/games/dean_8.lp",
					"GameGenerator/ASP_cleaned/games/dean_9.lp",
					"GameGenerator/ASP_cleaned/games/dean_10.lp",
					"GameGenerator/ASP_cleaned/games/dean_11.lp",
					"GameGenerator/ASP_cleaned/games/dean_12.lp",
					"GameGenerator/ASP_cleaned/games/dean_13.lp",
					"GameGenerator/ASP_cleaned/games/dean_14.lp",
					"GameGenerator/ASP_cleaned/games/dean_15.lp",
					"GameGenerator/ASP_cleaned/games/dean_16.lp",
					"GameGenerator/ASP_cleaned/games/dean_17.lp",
					"GameGenerator/ASP_cleaned/games/dean_18.lp",
					"GameGenerator/ASP_cleaned/games/dean_19.lp",
					"GameGenerator/ASP_cleaned/games/dean_20.lp",
					"GameGenerator/ASP_cleaned/games/dean_21.lp",
					"GameGenerator/ASP_cleaned/games/dean_22.lp",
					"GameGenerator/ASP_cleaned/games/dean_23.lp",
					"GameGenerator/ASP_cleaned/games/dean_24.lp",
					"GameGenerator/ASP_cleaned/games/dean_25.lp",
				],
				gameString : "var variables;function preload(){};function create(){};function update(){};function getAspGoals(){}"
			},
			{
				id: "sereneTest",
				aspFilepaths: ['asp-phaser-generator-2/test/fixtures/game-10_2_handModified.lp'],
				gameString : "var variables;function preload(){};function create(){};function update(){};function getAspGoals(){}"
			},
			{
				id: "talonTest",
				aspFilepaths: ['asp-phaser-generator-2/test/fixtures/game-10_2_handModified.lp'],
				gameString : "var variables;function preload(){};function create(){};function update(){};function getAspGoals(){}"
			},
			{
				id: "ianTest",
				aspFilepaths: ['asp-phaser-generator-2/test/fixtures/game-10_2_handModified.lp'],
				gameString : "var variables;function preload(){};function create(){};function update(){};function getAspGoals(){}"
			},
			{
				id: "kevinTest",
				aspFilepaths: ['asp-phaser-generator-2/test/fixtures/game-10_2_handModified.lp'],
				gameString : "var variables;function preload(){};function create(){};function update(){};function getAspGoals(){}"
			},
			{
				id: "summerTest",
				aspFilepaths: ['asp-phaser-generator-2/test/fixtures/game-10_2_handModified.lp'],
				gameString : "var variables;function preload(){};function create(){};function update(){};function getAspGoals(){}"
			},
			{
				id: "mattTest",
				aspFilepaths: ['asp-phaser-generator-2/test/fixtures/game-10_2_handModified.lp'],
				gameString : "var variables;function preload(){};function create(){};function update(){};function getAspGoals(){}"
			},
			{
				id: "dinner",
    				aspFilepaths: [
						"GameGenerator/ASP_cleaned/games/dinner_1.lp",
						"GameGenerator/ASP_cleaned/games/dinner_2.lp",
						"GameGenerator/ASP_cleaned/games/dinner_3.lp",
						"GameGenerator/ASP_cleaned/games/dinner_4.lp",
						"GameGenerator/ASP_cleaned/games/dinner_5.lp",
						"GameGenerator/ASP_cleaned/games/dinner_6.lp",
						"GameGenerator/ASP_cleaned/games/dinner_7.lp",
						"GameGenerator/ASP_cleaned/games/dinner_8.lp",
						"GameGenerator/ASP_cleaned/games/dinner_9.lp",
						"GameGenerator/ASP_cleaned/games/dinner_10.lp",
						"GameGenerator/ASP_cleaned/games/dinner_11.lp",
						"GameGenerator/ASP_cleaned/games/dinner_12.lp",
						"GameGenerator/ASP_cleaned/games/dinner_13.lp",
						"GameGenerator/ASP_cleaned/games/dinner_14.lp",
						"GameGenerator/ASP_cleaned/games/dinner_15.lp",
						"GameGenerator/ASP_cleaned/games/dinner_16.lp",
						"GameGenerator/ASP_cleaned/games/dinner_17.lp",
						"GameGenerator/ASP_cleaned/games/dinner_18.lp",
						"GameGenerator/ASP_cleaned/games/dinner_19.lp",
						"GameGenerator/ASP_cleaned/games/dinner_20.lp",
						"GameGenerator/ASP_cleaned/games/dinner_21.lp",
						"GameGenerator/ASP_cleaned/games/dinner_22.lp",
						"GameGenerator/ASP_cleaned/games/dinner_23.lp",
						"GameGenerator/ASP_cleaned/games/dinner_24.lp",
						"GameGenerator/ASP_cleaned/games/dinner_25.lp",
				],
				gameString : "var variables;function preload(){};function create(){};function update(){};function getAspGoals(){}"
			},
			{
				id: "dinner_argument",
				aspFilepaths: ['asp-phaser-generator-2/test/fixtures/game-10_2_handModified.lp'],
				gameString : "var variables; var gridSize; var gridLinesHorizontal; var gridLinesVertical; var grid; var gridIdx; var addedEntities; var low; var medium; var mid; var high; var goals; var e1; var e2; var r1; function preload(){ 	game.load.image('e1','assets/sprites/circle.png');	game.load.image('e2','assets/sprites/circle.png'); };function create(){ 	variables={'confidence':'5','optimism':'2','difficulty':'3'}; 	gridSize=30; 	gridLinesHorizontal=Math.floor((game.width-1)/gridSize); 	gridLinesVertical=Math.floor((game.height-1)/gridSize); 	grid=initGrid(); 	gridIdx=0; 	addedEntities={}; 	low=1; 	medium=6; 	mid=medium; 	high=11; 	goals=[];	e1=game.add.physicsGroup(); 	addedEntities['e1']=e1; 	initEntityProperties(e1);	e2=game.add.physicsGroup(); 	addedEntities['e2']=e2; 	initEntityProperties(e2); 	r1=high;	var x=190;var y=160;for (var ii = 0; ii < 1; ii++){ 		x+=(Math.random() * 30) - 15; 		y+=(Math.random() * 30) - 15; 		addedEntities['e1'].create(x,y,'e1'); 		updateGrid(); 		initEntityProperties(addedEntities['e1']); 	} 	var x=50;var y=160;for (var ii = 0; ii < 1; ii++){ 		x+=(Math.random() * 30) - 15; 		y+=(Math.random() * 30) - 15; 		addedEntities['e2'].create(x,y,'e2'); 		updateGrid(); 		initEntityProperties(addedEntities['e2']); 	} 	var x=300;var y=160;for (var ii = 0; ii < 1; ii++){ 		x+=(Math.random() * 30) - 15; 		y+=(Math.random() * 30) - 15; 		addedEntities['e2'].create(x,y,'e2'); 		updateGrid(); 		initEntityProperties(addedEntities['e2']); 	} 	game.time.events.loop(Phaser.Timer.SECOND*10, t1_t1Listener, this);	addedEntities['e2'].forEach(function(item){item.body.immovable=true;}, this); }function update(){ 	for(var k in addedEntities) {if (addedEntities.hasOwnProperty(k)) { 		var entity = addedEntities[k]; 		entity.forEach(function(item) { 		item.body.velocity.x *= 0.9; 		item.body.velocity.y *= 0.9; 		}, this); 	}}	addedEntities['e1'].forEach(function(item){ 		item.inputEnabled=true; 		item.input.enableDrag(true); 	}, this);	r1=r1-low*this.game.time.elapsed/10000.0;	game.physics.arcade.overlap(addedEntities['e2'],addedEntities['e1'],o1OverlapHandler,null, this); 	if(r1<=0){ 		changeMode('narrative_progression'); }	addedEntities['e1'].forEach(function(item){item.tint=0xffffff;}, this); 	addedEntities['e2'].forEach(function(item){item.tint=0x0000ff;}, this); 	game.physics.arcade.collide(e1,e1,null,null,this);	for(var k in addedEntities) {if (addedEntities.hasOwnProperty(k)) { 		var entity = addedEntities[k]; 		entity.forEach(function(item) { 		item.body.velocity.clamp(-300,300); 			if(item.x>game.width){item.x=game.width;}if (item.x<0){item.x=0;} if (item.y>game.height){item.y=game.height;}if (item.y<0){item.y=0;} 		}, this); 	}}        setVariable('patience',r1); };function render(){}; function t1_t1Listener(){	var x=190;var y=160;for (var ii = 0; ii < 1; ii++){ 		x+=(Math.random() * 30) - 15; 		y+=(Math.random() * 30) - 15; 		addedEntities['e1'].create(x,y,'e1'); 		updateGrid(); 		initEntityProperties(addedEntities['e1']); 	} } function o1OverlapHandler(e1,e2){ 	e2.destroy();	r1=r1+low;};function setVariable(varName,value){	variables[varName]=value;	State.set(varName, value.toFixed(1));	Display.setAvatar(State);	Display.setStats('storyStats');};function getVariable(varName){ 	return variables[varName]; };function getRandomPoint(){ 	var x=game.rnd.integerInRange(0,game.world.width-1); 	var y=game.rnd.integerInRange(0,game.world.height-1); 	return new Phaser.Point(x,y); };function initGrid(){ 	grid=[]; 	for(var i=0;i<gridLinesHorizontal;i++){for(var j=0;j<gridLinesVertical;j++){grid.push(new Phaser.Point(i*gridSize,j*gridSize));}} 	shuffle(grid); 	return grid; };function updateGrid(sprite){ 	gridIdx++; 	if(gridIdx===grid.length){gridIdx=0;shuffle(grid);} };function shuffle(a){ 	var j,x,i; 	for(i=a.length;i;i--){j=Math.floor(Math.random()*i);x=a[i-1];a[i-1]=a[j];a[j]=x;} };function move_towards(e,dir){ 	e.body.velocity.x += dir.x; 	e.body.velocity.y += dir.y; };function move_away(e,dir){ 	e.body.velocity.x -= dir.x; 	e.body.velocity.y -= dir.y; };function moves(e,x,y){ 	e.body.velocity.x += x; 	e.body.velocity.y += y; };function move_forward(e,amount){ 	var newV = game.physics.arcade.velocityFromRotation(e.rotation,amount); 	e.body.velocity.x += newV.x; 	e.body.velocity.y += newV.y; };function move_left(e,amount){ 	var newV = game.physics.arcade.velocityFromRotation(e.rotation-Math.PI*0.5,amount); 	e.body.velocity.x += newV.x; 	e.body.velocity.y += newV.y; };function move_right(e,amount){ 	var newV = game.physics.arcade.velocityFromRotation(e.rotation+Math.PI*0.5,amount); 	e.body.velocity.x += newV.x; 	e.body.velocity.y += newV.y; };function move_backward(e,amount){ 	var newV = game.physics.arcade.velocityFromRotation(e.rotation-Math.PI,amount); 	e.body.velocity.x += newV.x; 	e.body.velocity.y += newV.y; };function initEntityProperties(group){ 	group.forEach(function(item) { 	item.body.collideWorldBounds = true; 	item.anchor.x = 0.5; 	item.anchor.y = 0.5; 	item.rotation = 0; 	if (!item.body.velocity.hasOwnProperty('x')){item.body.velocity.x=0;} 	if (!item.body.velocity.hasOwnProperty('y')){item.body.velocity.y=0;} 	if (!item.body.hasOwnProperty('angularVelocity')){item.body.angularVelocity=0;} 	}, this); };function changeMode(newMode){ 	if(newMode==='game_win'){mode = 'win'; game.world.removeAll(); displayText('CLEARED');} 	else if(newMode==='game_loss'){mode='loss'; game.stage.backgroundColor = '#400';} };function displayText(t){ 	var style = { font: 'bold 32px Arial', fill: '#fff', boundsAlignH: 'center', boundsAlignV: 'middle'}; 	text = game.add.text(0, 0, t, style); };function getAspGoals(){ 	if (goals === undefined || goals.length == 0){return ['No ASP goals.'];} 	else{return goals;} };goals=['Prevent:[r1] le [0]','Maintain r1'];"
			},
			{
				id: "generalist",
				aspFilepaths: ['asp-phaser-generator-2/test/fixtures/game-10_2_handModified.lp'],
				gameString : "var variables; var gridSize; var gridLinesHorizontal; var gridLinesVertical; var grid; var gridIdx; var addedEntities; var low; var medium; var mid; var high; var goals; var e1; var e2; var r1; function preload(){ 	game.load.image('e1','assets/sprites/circle.png');	game.load.image('e2','assets/sprites/circle.png'); };function create(){ 	variables={'confidence':'5','optimism':'2','difficulty':'3'}; 	gridSize=30; 	gridLinesHorizontal=Math.floor((game.width-1)/gridSize); 	gridLinesVertical=Math.floor((game.height-1)/gridSize); 	grid=initGrid(); 	gridIdx=0; 	addedEntities={}; 	low=1; 	medium=6; 	mid=medium; 	high=11; 	goals=[];	e1=game.add.physicsGroup(); 	addedEntities['e1']=e1; 	initEntityProperties(e1);	e2=game.add.physicsGroup(); 	addedEntities['e2']=e2; 	initEntityProperties(e2); 	r1=high;	var x=190;var y=160;for (var ii = 0; ii < 1; ii++){ 		x+=(Math.random() * 30) - 15; 		y+=(Math.random() * 30) - 15; 		addedEntities['e1'].create(x,y,'e1'); 		updateGrid(); 		initEntityProperties(addedEntities['e1']); 	} 	var x=50;var y=160;for (var ii = 0; ii < 1; ii++){ 		x+=(Math.random() * 30) - 15; 		y+=(Math.random() * 30) - 15; 		addedEntities['e2'].create(x,y,'e2'); 		updateGrid(); 		initEntityProperties(addedEntities['e2']); 	} 	var x=300;var y=160;for (var ii = 0; ii < 1; ii++){ 		x+=(Math.random() * 30) - 15; 		y+=(Math.random() * 30) - 15; 		addedEntities['e2'].create(x,y,'e2'); 		updateGrid(); 		initEntityProperties(addedEntities['e2']); 	} 	game.time.events.loop(Phaser.Timer.SECOND*10, t1_t1Listener, this);	addedEntities['e2'].forEach(function(item){item.body.immovable=true;}, this); }function update(){ 	for(var k in addedEntities) {if (addedEntities.hasOwnProperty(k)) { 		var entity = addedEntities[k]; 		entity.forEach(function(item) { 		item.body.velocity.x *= 0.9; 		item.body.velocity.y *= 0.9; 		}, this); 	}}	addedEntities['e1'].forEach(function(item){ 		item.inputEnabled=true; 		item.input.enableDrag(true); 	}, this);	r1=r1-low*this.game.time.elapsed/10000.0;	game.physics.arcade.overlap(addedEntities['e2'],addedEntities['e1'],o1OverlapHandler,null, this); 	if(r1<=0){ 		changeMode('narrative_progression'); }	addedEntities['e1'].forEach(function(item){item.tint=0xffffff;}, this); 	addedEntities['e2'].forEach(function(item){item.tint=0x0000ff;}, this); 	game.physics.arcade.collide(e1,e1,null,null,this);	for(var k in addedEntities) {if (addedEntities.hasOwnProperty(k)) { 		var entity = addedEntities[k]; 		entity.forEach(function(item) { 		item.body.velocity.clamp(-300,300); 			if(item.x>game.width){item.x=game.width;}if (item.x<0){item.x=0;} if (item.y>game.height){item.y=game.height;}if (item.y<0){item.y=0;} 		}, this); 	}}        setVariable('patience',r1); };function render(){}; function t1_t1Listener(){	var x=190;var y=160;for (var ii = 0; ii < 1; ii++){ 		x+=(Math.random() * 30) - 15; 		y+=(Math.random() * 30) - 15; 		addedEntities['e1'].create(x,y,'e1'); 		updateGrid(); 		initEntityProperties(addedEntities['e1']); 	} } function o1OverlapHandler(e1,e2){ 	e2.destroy();	r1=r1+low;};function setVariable(varName,value){	variables[varName]=value;	State.set(varName, value.toFixed(1));	Display.setAvatar(State);	Display.setStats('storyStats');};function getVariable(varName){ 	return variables[varName]; };function getRandomPoint(){ 	var x=game.rnd.integerInRange(0,game.world.width-1); 	var y=game.rnd.integerInRange(0,game.world.height-1); 	return new Phaser.Point(x,y); };function initGrid(){ 	grid=[]; 	for(var i=0;i<gridLinesHorizontal;i++){for(var j=0;j<gridLinesVertical;j++){grid.push(new Phaser.Point(i*gridSize,j*gridSize));}} 	shuffle(grid); 	return grid; };function updateGrid(sprite){ 	gridIdx++; 	if(gridIdx===grid.length){gridIdx=0;shuffle(grid);} };function shuffle(a){ 	var j,x,i; 	for(i=a.length;i;i--){j=Math.floor(Math.random()*i);x=a[i-1];a[i-1]=a[j];a[j]=x;} };function move_towards(e,dir){ 	e.body.velocity.x += dir.x; 	e.body.velocity.y += dir.y; };function move_away(e,dir){ 	e.body.velocity.x -= dir.x; 	e.body.velocity.y -= dir.y; };function moves(e,x,y){ 	e.body.velocity.x += x; 	e.body.velocity.y += y; };function move_forward(e,amount){ 	var newV = game.physics.arcade.velocityFromRotation(e.rotation,amount); 	e.body.velocity.x += newV.x; 	e.body.velocity.y += newV.y; };function move_left(e,amount){ 	var newV = game.physics.arcade.velocityFromRotation(e.rotation-Math.PI*0.5,amount); 	e.body.velocity.x += newV.x; 	e.body.velocity.y += newV.y; };function move_right(e,amount){ 	var newV = game.physics.arcade.velocityFromRotation(e.rotation+Math.PI*0.5,amount); 	e.body.velocity.x += newV.x; 	e.body.velocity.y += newV.y; };function move_backward(e,amount){ 	var newV = game.physics.arcade.velocityFromRotation(e.rotation-Math.PI,amount); 	e.body.velocity.x += newV.x; 	e.body.velocity.y += newV.y; };function initEntityProperties(group){ 	group.forEach(function(item) { 	item.body.collideWorldBounds = true; 	item.anchor.x = 0.5; 	item.anchor.y = 0.5; 	item.rotation = 0; 	if (!item.body.velocity.hasOwnProperty('x')){item.body.velocity.x=0;} 	if (!item.body.velocity.hasOwnProperty('y')){item.body.velocity.y=0;} 	if (!item.body.hasOwnProperty('angularVelocity')){item.body.angularVelocity=0;} 	}, this); };function changeMode(newMode){ 	if(newMode==='game_win'){mode = 'win'; game.world.removeAll(); displayText('CLEARED');} 	else if(newMode==='game_loss'){mode='loss'; game.stage.backgroundColor = '#400';} };function displayText(t){ 	var style = { font: 'bold 32px Arial', fill: '#fff', boundsAlignH: 'center', boundsAlignV: 'middle'}; 	text = game.add.text(0, 0, t, style); };function getAspGoals(){ 	if (goals === undefined || goals.length == 0){return ['No ASP goals.'];} 	else{return goals;} };goals=['Prevent:[r1] le [0]','Maintain r1'];"
			},
			{
				id: "lecture",
				aspFilepaths: ['asp-phaser-generator-2/test/fixtures/game-10_2_handModified.lp'],
				gameString: "var variables;var gridSize;var gridLinesHorizontal;var gridLinesVertical;var grid;var gridIdx;var addedEntities;var low;var medium;var mid;var high;var goals;var e1;var e2;var r1;function preload(){	game.load.image('e1','assets/sprites/square.png');	game.load.image('e2','assets/sprites/circle.png');};function create(){	variables={'confidence':'5','optimism':'2','difficulty':'3'};	gridSize=30;	gridLinesHorizontal=Math.floor((game.width-1)/gridSize);	gridLinesVertical=Math.floor((game.height-1)/gridSize);	grid=initGrid();	gridIdx=0;	addedEntities={};	low=1;	medium=6;	mid=medium;	high=11;	goals=[];	e1=game.add.physicsGroup();	addedEntities['e1']=e1;	initEntityProperties(e1);	e2=game.add.physicsGroup();	addedEntities['e2']=e2;	initEntityProperties(e2);	r1=high;	var x=190;var y=160;for (var ii = 0; ii < 1; ii++){		x+=(Math.random() * 30) - 15;		y+=(Math.random() * 30) - 15;		addedEntities['e1'].create(x,y,'e1');		updateGrid();		initEntityProperties(addedEntities['e1']);	}	var x=50;var y=50;for (var ii = 0; ii < 3; ii++){		x+=(Math.random() * 30) - 15;		y+=(Math.random() * 30) - 15;		addedEntities['e2'].create(x,y,'e2');		updateGrid();		initEntityProperties(addedEntities['e2']);	}	var x=300;var y=50;for (var ii = 0; ii < 3; ii++){		x+=(Math.random() * 30) - 15;		y+=(Math.random() * 30) - 15;		addedEntities['e2'].create(x,y,'e2');		updateGrid();		initEntityProperties(addedEntities['e2']);	}	var x=50;var y=250;for (var ii = 0; ii < 3; ii++){		x+=(Math.random() * 30) - 15;		y+=(Math.random() * 30) - 15;		addedEntities['e2'].create(x,y,'e2');		updateGrid();		initEntityProperties(addedEntities['e2']);	}	var x=300;var y=250;for (var ii = 0; ii < 3; ii++){		x+=(Math.random() * 30) - 15;		y+=(Math.random() * 30) - 15;		addedEntities['e2'].create(x,y,'e2');		updateGrid();		initEntityProperties(addedEntities['e2']);	}	game.input.onDown.add(o3PressedHandler, this);	game.time.events.loop(Phaser.Timer.SECOND*3, t2_t2Listener, this);	game.input.onDown.add(o1PressedHandler, this);	game.time.events.loop(Phaser.Timer.SECOND*5, t1_t1Listener, this);	addedEntities['e1'].forEach(function(item){item.angle = Math.random() * (360-0) + 0;}, this);	addedEntities['e2'].forEach(function(item){item.angle = Math.random() * (360-0) + 0;}, this);};function update(){	for(var k in addedEntities) {if (addedEntities.hasOwnProperty(k)) {		var entity = addedEntities[k];		entity.forEach(function(item) {		item.body.velocity.x *= 0.95;		item.body.velocity.y *= 0.95;		}, this);	}}	r1=r1-high*this.game.time.elapsed/10000.0;	if(r1<=0){		changeMode('game_loss');		}	addedEntities['e1'].forEach(function(item) {		move_forward(item,1);}, this);	addedEntities['e2'].forEach(function(item) {		move_forward(item,1);}, this);	addedEntities['e1'].forEach(function(item){item.tint=0x00ff00;}, this);	addedEntities['e2'].forEach(function(item){item.tint=0x0000ff;}, this);	game.physics.arcade.collide(e1,e1,null,null,this);	game.physics.arcade.collide(e2,e2,null,null,this);	for(var k in addedEntities) {if (addedEntities.hasOwnProperty(k)) {		var entity = addedEntities[k];		entity.forEach(function(item) {		item.body.velocity.clamp(-300,300);			if(item.x>game.width){item.x=game.width;}if (item.x<0){item.x=0;} if (item.y>game.height){item.y=game.height;}if (item.y<0){item.y=0;}		}, this);	}}    setVariable('confidence',r1);};function render(){};function o3OverlapHandler(e1,e2){	r1=r1+low;  };function t2_t2Listener(){	addedEntities['e2'].forEach(function(item){item.angle = Math.random() * (360-0) + 0;}, this);};function o1OverlapHandler(e1,e2){	r1=r1-medium;};function t1_t1Listener(){	addedEntities['e1'].forEach(function(item){item.angle = Math.random() * (360-0) + 0;}, this);};function setVariable(varName,value){	variables[varName]=value;	State.set(varName, value.toFixed(1));	Display.setAvatar(State);	Display.setStats('storyStats');};function getVariable(varName){	return variables[varName];};function getRandomPoint(){	var x=game.rnd.integerInRange(0,game.world.width-1);	var y=game.rnd.integerInRange(0,game.world.height-1);	return new Phaser.Point(x,y);};function initGrid(){	grid=[];	for(var i=0;i<gridLinesHorizontal;i++){for(var j=0;j<gridLinesVertical;j++){grid.push(new Phaser.Point(i*gridSize,j*gridSize));}}	shuffle(grid);	return grid;};function updateGrid(sprite){	gridIdx++;	if(gridIdx===grid.length){gridIdx=0;shuffle(grid);}};function shuffle(a){	var j,x,i;	for(i=a.length;i;i--){j=Math.floor(Math.random()*i);x=a[i-1];a[i-1]=a[j];a[j]=x;}};function move_towards(e,dir){	e.body.velocity.x += dir.x;	e.body.velocity.y += dir.y;};function move_away(e,dir){	e.body.velocity.x -= dir.x;	e.body.velocity.y -= dir.y;};function moves(e,x,y){	e.body.velocity.x += x;	e.body.velocity.y += y;};function move_forward(e,amount){	var newV = game.physics.arcade.velocityFromRotation(e.rotation,amount);	e.body.velocity.x += newV.x;	e.body.velocity.y += newV.y;};function move_left(e,amount){	var newV = game.physics.arcade.velocityFromRotation(e.rotation-Math.PI*0.5,amount);	e.body.velocity.x += newV.x;	e.body.velocity.y += newV.y;};function move_right(e,amount){	var newV = game.physics.arcade.velocityFromRotation(e.rotation+Math.PI*0.5,amount);	e.body.velocity.x += newV.x;	e.body.velocity.y += newV.y;};function move_backward(e,amount){	var newV = game.physics.arcade.velocityFromRotation(e.rotation-Math.PI,amount);	e.body.velocity.x += newV.x;	e.body.velocity.y += newV.y;};function initEntityProperties(group){	group.forEach(function(item) {	item.body.collideWorldBounds = true;	item.anchor.x = 0.5;	item.anchor.y = 0.5;	item.rotation = 0;	if (!item.body.velocity.hasOwnProperty('x')){item.body.velocity.x=0;}	if (!item.body.velocity.hasOwnProperty('y')){item.body.velocity.y=0;}	if (!item.body.hasOwnProperty('angularVelocity')){item.body.angularVelocity=0;}	}, this);};function changeMode(newMode){	if(newMode==='game_win'){mode = 'win'; game.world.removeAll(); displayText('CLEARED');}	else if(newMode==='game_loss'){mode='loss'; game.stage.backgroundColor = '#400';}};function displayText(t){	var style = { font: 'bold 32px Arial', fill: '#fff', boundsAlignH: 'center', boundsAlignV: 'middle'};	text = game.add.text(0, 0, t, style);};function getAspGoals(){	if (goals === undefined || goals.length == 0){return ['No ASP goals.'];}	else{return goals;}};function o3PressedHandler(){    if  (!game.physics.arcade.overlap(addedEntities['e1'], addedEntities['e2'], null, null, this)){        o3OverlapHandler();    }};function o1PressedHandler(){	game.physics.arcade.overlap(addedEntities['e1'], addedEntities['e2'], o1OverlapHandler, null, this);};goals=['Prevent:[r1] le [0]','Maintain r1'];"
			},
			{
				id: "worker",
				aspFilepaths: ['asp-phaser-generator-2/test/fixtures/game-10_2_handModified.lp'],
				gameString: "var variables;var gridSize;var gridLinesHorizontal;var gridLinesVertical;var grid;var gridIdx;var addedEntities;var low;var medium;var mid;var high;var goals;var e1;var e2;var r1;var r2;function preload(){game.load.image('e1','assets/sprites/pentagon.png');game.load.image('e2','assets/sprites/triangle.png');};function create(){variables={'confidence':'5','optimism':'2','difficulty':'3'};gridSize=30;gridLinesHorizontal=Math.floor((game.width-1)/gridSize);gridLinesVertical=Math.floor((game.height-1)/gridSize);grid=initGrid();gridIdx=0;addedEntities={};low=1;medium=6;mid=medium;high=11;goals=[];r1=medium;r2=medium;e1=addAtRandomPoint('e1');addedEntities['e1']=e1;initEntityProperties('e1');e2=addAtRandomPoint('e2');addedEntities['e2']=e2;initEntityProperties('e2');e1.inputEnabled=true;e1.events.onInputDown.add(e1ClickListener,this);};function update(){r2=r2+high;r1=r1-medium;if(r1<=low){}if(Phaser.Point.distance(new Phaser.Point(e1.x,e1.y),new Phaser.Point(e2.x,e2.y)) < game.width*0.1 && r2>=0){r1=r1-high;}if(Phaser.Point.distance(new Phaser.Point(e1.x,e1.y),new Phaser.Point(e2.x,e2.y)) < game.width*0.1 && r2<=0){r1=r1+r2;}var tempPoint = new Phaser.Point(game.input.mousePointer.x-e2.x,game.input.mousePointer.y-e2.y);tempPoint.normalize();move_away(e2, tempPoint);var tempPoint = new Phaser.Point(e1.x-e2.x,e1.y-e2.y);tempPoint.normalize();move_away(e2, tempPoint);e1.body.gravity.y = mid;for(var k in addedEntities) {if (addedEntities.hasOwnProperty(k)) {var entity = addedEntities[k];entity.directionChange.clamp(0,1);entity.x+=entity.directionChange.x;entity.y+=entity.directionChange.y;if(entity.x>game.width){entity.x=game.width;}if (entity.x<0){entity.x=0;} if (entity.y>game.height){entity.y=game.height;}if (entity.y<0){entity.y=0;}}}};function render(){};function e1ClickListener(){e2=addAtRandomPoint('e2');addedEntities['e2']=e2;initEntityProperties('e2');r1=r1-r2;r2=r2-high;};function setVariable(varName,value){variables[varName]=value;State.set(varName, value);StoryAssembler.refreshNarrative();Display.setAvatar(State);};function getVariable(varName){return variables[varName];};function getRandomPoint(){var x=game.rnd.integerInRange(0,game.world.width-1);var y=game.rnd.integerInRange(0,game.world.height-1);return new Phaser.Point(x,y);};function initGrid(){grid=[];for(var i=0;i<gridLinesHorizontal;i++){for(var j=0;j<gridLinesVertical;j++){grid.push(new Phaser.Point(i*gridSize,j*gridSize));}}shuffle(grid);return grid;};function addAtRandomPoint(sprite){var spawned=addAtPos(grid[gridIdx], sprite);gridIdx++;if(gridIdx===grid.length){gridIdx=0;shuffle(grid);}return spawned;};function addAtPos(point,sprite){return game.add.sprite(point.x,point.y,sprite);};function shuffle(a){var j,x,i;for(i=a.length;i;i--){j=Math.floor(Math.random()*i);x=a[i-1];a[i-1]=a[j];a[j]=x;}};function move_towards(e,dir){e.directionChange.x += dir.x;e.directionChange.y += dir.y;};function move_away(e,dir){e.directionChange.x -= dir.x;e.directionChange.y -= dir.y;};function move(e,x,y){e.directionChange.x += x;e.directionChange.y += y;};function initEntityProperties(eName){game.physics.arcade.enable(addedEntities[eName]);addedEntities[eName].body.collideWorldBounds = true;if (!addedEntities[eName].body.velocity.hasOwnProperty('x')){addedEntities[eName].body.velocity.x=0;}if (!addedEntities[eName].body.velocity.hasOwnProperty('y')){addedEntities[eName].body.velocity.y=0;}if (!addedEntities[eName].body.hasOwnProperty('angularVelocity')){addedEntities[eName].body.angularVelocity=0;}if (!addedEntities[eName].hasOwnProperty('directionChange')){addedEntities[eName].directionChange=new Phaser.Point(0,0);}};function changeMode(newMode){if(newMode==='game_win'){mode = 'win'; game.world.removeAll(); displayText('CLEARED');}else if(newMode==='game_loss'){mode='loss'; game.stage.backgroundColor = '#400';}};function displayText(t){var style = { font: 'bold 32px Arial', fill: '#fff', boundsAlignH: 'center', boundsAlignV: 'middle'};text = game.add.text(0, 0, t, style);};function getAspGoals(){if (goals === undefined || goals.length == 0){return ['No ASP goals.'];}else{return goals;}};goals=['Prevent:[r1] le [low]','Maintain r1'];"
			},
			{
				id: "travel",
				aspFilepaths: ['asp-phaser-generator-2/test/fixtures/game-10_2_handModified.lp'],
				gameString: "var variables;var gridSize;var gridLinesHorizontal;var gridLinesVertical;var grid;var gridIdx;var addedEntities;var low;var medium;var mid;var high;var goals;var e1;var e2;var r1;var r2;function preload(){game.load.image('e1','assets/sprites/square.png');game.load.image('e2','assets/sprites/circle.png');};function create(){variables={'confidence':'5','optimism':'2','difficulty':'3'};gridSize=30;gridLinesHorizontal=Math.floor((game.width-1)/gridSize);gridLinesVertical=Math.floor((game.height-1)/gridSize);grid=initGrid();gridIdx=0;addedEntities={};low=1;medium=6;mid=medium;high=11;goals=[];r1=low;r2=high;e1=addAtRandomPoint('e1');addedEntities['e1']=e1;initEntityProperties('e1');e2=addAtRandomPoint('e2');addedEntities['e2']=e2;initEntityProperties('e2');};function update(){r2=r2+r1;r1=r1-r2;if(Phaser.Point.distance(new Phaser.Point(e1.x,e1.y),new Phaser.Point(e2.x,e2.y)) < game.width*0.1 && r1<=low){r2=r2-low;}if(r1<=0){}if(Phaser.Point.distance(new Phaser.Point(e1.x,e1.y),new Phaser.Point(e2.x,e2.y)) < game.width*0.1 && r2>=high){r1=r1+r2;}if(!game.input.activePointer.leftButton.isDown){e1=addAtRandomPoint('e1');addedEntities['e1']=e1;initEntityProperties('e1');r2=r2+low;r1=r1-high;}var tempPoint = new Phaser.Point(game.input.mousePointer.x-e1.x,game.input.mousePointer.y-e1.y);tempPoint.normalize();move_away(e1, tempPoint);var tempPoint = new Phaser.Point(e1.x-e2.x,e1.y-e2.y);tempPoint.normalize();move_away(e2, tempPoint);e1.body.gravity.y = mid;e2.body.gravity.y = mid;for(var k in addedEntities) {if (addedEntities.hasOwnProperty(k)) {var entity = addedEntities[k];entity.directionChange.clamp(0,1);entity.x+=entity.directionChange.x;entity.y+=entity.directionChange.y;if(entity.x>game.width){entity.x=game.width;}if (entity.x<0){entity.x=0;} if (entity.y>game.height){entity.y=game.height;}if (entity.y<0){entity.y=0;}}}};function render(){};function setVariable(varName,value){variables[varName]=value;State.set(varName, value);StoryAssembler.refreshNarrative();Display.setAvatar(State);};function getVariable(varName){return variables[varName];};function getRandomPoint(){var x=game.rnd.integerInRange(0,game.world.width-1);var y=game.rnd.integerInRange(0,game.world.height-1);return new Phaser.Point(x,y);};function initGrid(){grid=[];for(var i=0;i<gridLinesHorizontal;i++){for(var j=0;j<gridLinesVertical;j++){grid.push(new Phaser.Point(i*gridSize,j*gridSize));}}shuffle(grid);return grid;};function addAtRandomPoint(sprite){var spawned=addAtPos(grid[gridIdx], sprite);gridIdx++;if(gridIdx===grid.length){gridIdx=0;shuffle(grid);}return spawned;};function addAtPos(point,sprite){return game.add.sprite(point.x,point.y,sprite);};function shuffle(a){var j,x,i;for(i=a.length;i;i--){j=Math.floor(Math.random()*i);x=a[i-1];a[i-1]=a[j];a[j]=x;}};function move_towards(e,dir){e.directionChange.x += dir.x;e.directionChange.y += dir.y;};function move_away(e,dir){e.directionChange.x -= dir.x;e.directionChange.y -= dir.y;};function move(e,x,y){e.directionChange.x += x;e.directionChange.y += y;};function initEntityProperties(eName){game.physics.arcade.enable(addedEntities[eName]);addedEntities[eName].body.collideWorldBounds = true;if (!addedEntities[eName].body.velocity.hasOwnProperty('x')){addedEntities[eName].body.velocity.x=0;}if (!addedEntities[eName].body.velocity.hasOwnProperty('y')){addedEntities[eName].body.velocity.y=0;}if (!addedEntities[eName].body.hasOwnProperty('angularVelocity')){addedEntities[eName].body.angularVelocity=0;}if (!addedEntities[eName].hasOwnProperty('directionChange')){addedEntities[eName].directionChange=new Phaser.Point(0,0);}};function changeMode(newMode){if(newMode==='game_win'){mode = 'win'; game.world.removeAll(); displayText('CLEARED');}else if(newMode==='game_loss'){mode='loss'; game.stage.backgroundColor = '#400';}};function displayText(t){var style = { font: 'bold 32px Arial', fill: '#fff', boundsAlignH: 'center', boundsAlignV: 'middle'};text = game.add.text(0, 0, t, style);};function getAspGoals(){if (goals === undefined || goals.length == 0){return ['No ASP goals.'];}else{return goals;}};goals=['Prevent:[r1] le [0]','Maintain r1'];"
			},
			{
				id: "finalDinner",
				aspFilepaths: [
					"GameGenerator/ASP_cleaned/games/dinner_1.lp",
					"GameGenerator/ASP_cleaned/games/dinner_2.lp",
					"GameGenerator/ASP_cleaned/games/dinner_3.lp",
					"GameGenerator/ASP_cleaned/games/dinner_4.lp",
					"GameGenerator/ASP_cleaned/games/dinner_5.lp",
					"GameGenerator/ASP_cleaned/games/dinner_6.lp",
					"GameGenerator/ASP_cleaned/games/dinner_7.lp",
					"GameGenerator/ASP_cleaned/games/dinner_8.lp",
					"GameGenerator/ASP_cleaned/games/dinner_9.lp",
					"GameGenerator/ASP_cleaned/games/dinner_10.lp",
					"GameGenerator/ASP_cleaned/games/dinner_11.lp",
					"GameGenerator/ASP_cleaned/games/dinner_12.lp",
					"GameGenerator/ASP_cleaned/games/dinner_13.lp",
					"GameGenerator/ASP_cleaned/games/dinner_14.lp",
					"GameGenerator/ASP_cleaned/games/dinner_15.lp",
					"GameGenerator/ASP_cleaned/games/dinner_16.lp",
					"GameGenerator/ASP_cleaned/games/dinner_17.lp",
					"GameGenerator/ASP_cleaned/games/dinner_18.lp",
					"GameGenerator/ASP_cleaned/games/dinner_19.lp",
					"GameGenerator/ASP_cleaned/games/dinner_20.lp",
					"GameGenerator/ASP_cleaned/games/dinner_21.lp",
					"GameGenerator/ASP_cleaned/games/dinner_22.lp",
					"GameGenerator/ASP_cleaned/games/dinner_23.lp",
					"GameGenerator/ASP_cleaned/games/dinner_24.lp",
					"GameGenerator/ASP_cleaned/games/dinner_25.lp",
				],
				gameString : "var variables;function preload(){};function create(){};function update(){};function getAspGoals(){}"
			},
			{
				id: "finalLecture",
				aspFilepaths: [
					"GameGenerator/ASP_cleaned/games/lecture_1.lp",
					"GameGenerator/ASP_cleaned/games/lecture_2.lp",
					"GameGenerator/ASP_cleaned/games/lecture_3.lp",
					"GameGenerator/ASP_cleaned/games/lecture_4.lp",
					"GameGenerator/ASP_cleaned/games/lecture_5.lp",
					"GameGenerator/ASP_cleaned/games/lecture_6.lp",
					"GameGenerator/ASP_cleaned/games/lecture_7.lp",
					"GameGenerator/ASP_cleaned/games/lecture_8.lp",
					"GameGenerator/ASP_cleaned/games/lecture_9.lp",
				    "GameGenerator/ASP_cleaned/games/lecture_10.lp",
					"GameGenerator/ASP_cleaned/games/lecture_11.lp",
					"GameGenerator/ASP_cleaned/games/lecture_12.lp",
					"GameGenerator/ASP_cleaned/games/lecture_13.lp",
					"GameGenerator/ASP_cleaned/games/lecture_14.lp",
					"GameGenerator/ASP_cleaned/games/lecture_15.lp",
					"GameGenerator/ASP_cleaned/games/lecture_16.lp",
					"GameGenerator/ASP_cleaned/games/lecture_17.lp",
					"GameGenerator/ASP_cleaned/games/lecture_18.lp",
					"GameGenerator/ASP_cleaned/games/lecture_19.lp",
					"GameGenerator/ASP_cleaned/games/lecture_20.lp",
					"GameGenerator/ASP_cleaned/games/lecture_21.lp",
					"GameGenerator/ASP_cleaned/games/lecture_22.lp",
					"GameGenerator/ASP_cleaned/games/lecture_23.lp",
					"GameGenerator/ASP_cleaned/games/lecture_24.lp",
					"GameGenerator/ASP_cleaned/games/lecture_25.lp",
				],
				gameString : "var variables;function preload(){};function create(){};function update(){};function getAspGoals(){}"
			},
			{
				id: "finalDean",
				aspFilepaths: [
					"GameGenerator/ASP_cleaned/games/dean_1.lp",
					"GameGenerator/ASP_cleaned/games/dean_2.lp",
					"GameGenerator/ASP_cleaned/games/dean_3.lp",
					"GameGenerator/ASP_cleaned/games/dean_4.lp",
					"GameGenerator/ASP_cleaned/games/dean_5.lp",
					"GameGenerator/ASP_cleaned/games/dean_6.lp",
					"GameGenerator/ASP_cleaned/games/dean_7.lp",
					"GameGenerator/ASP_cleaned/games/dean_8.lp",
					"GameGenerator/ASP_cleaned/games/dean_9.lp",
					"GameGenerator/ASP_cleaned/games/dean_10.lp",
					"GameGenerator/ASP_cleaned/games/dean_11.lp",
					"GameGenerator/ASP_cleaned/games/dean_12.lp",
					"GameGenerator/ASP_cleaned/games/dean_13.lp",
					"GameGenerator/ASP_cleaned/games/dean_14.lp",
					"GameGenerator/ASP_cleaned/games/dean_15.lp",
					"GameGenerator/ASP_cleaned/games/dean_16.lp",
					"GameGenerator/ASP_cleaned/games/dean_17.lp",
					"GameGenerator/ASP_cleaned/games/dean_18.lp",
					"GameGenerator/ASP_cleaned/games/dean_19.lp",
					"GameGenerator/ASP_cleaned/games/dean_20.lp",
					"GameGenerator/ASP_cleaned/games/dean_21.lp",
					"GameGenerator/ASP_cleaned/games/dean_22.lp",
					"GameGenerator/ASP_cleaned/games/dean_23.lp",
					"GameGenerator/ASP_cleaned/games/dean_24.lp",
					"GameGenerator/ASP_cleaned/games/dean_25.lp",
				],
				gameString : "var variables;function preload(){};function create(){};function update(){};function getAspGoals(){}"
			},
			{
				id: "finalTravel",
				aspFilepaths: ['asp-phaser-generator-2/test/fixtures/game-10_2_handModified.lp'],
				gameString : "var variables;function preload(){};function create(){};function update(){};function getAspGoals(){}"
			},
			{
				id: "finalFamilyDinner",
				aspFilepaths: ['asp-phaser-generator-2/test/fixtures/game-10_2_handModified.lp'],
				gameString : "var variables;function preload(){};function create(){};function update(){};function getAspGoals(){}"
			},
			{
				id: "finalUN",
				aspFilepaths: ['asp-phaser-generator-2/test/fixtures/games-5-18/lecture_test_10.lp'],
				gameString : "var variables;function preload(){};function create(){};function update(){};function getAspGoals(){}"
			},
			{
				id: "finalBeach",
				aspFilepaths:  [
				    "GameGenerator/ASP_cleaned/games/lecture_1.lp",
					"GameGenerator/ASP_cleaned/games/lecture_2.lp",
					"GameGenerator/ASP_cleaned/games/lecture_3.lp",
					"GameGenerator/ASP_cleaned/games/lecture_4.lp",
					"GameGenerator/ASP_cleaned/games/lecture_5.lp",
					"GameGenerator/ASP_cleaned/games/lecture_6.lp",
					"GameGenerator/ASP_cleaned/games/lecture_7.lp",
					"GameGenerator/ASP_cleaned/games/lecture_8.lp",
					"GameGenerator/ASP_cleaned/games/lecture_9.lp",
					"GameGenerator/ASP_cleaned/games/lecture_10.lp",
					"GameGenerator/ASP_cleaned/games/lecture_11.lp",
					"GameGenerator/ASP_cleaned/games/lecture_12.lp",
					"GameGenerator/ASP_cleaned/games/lecture_13.lp",
					"GameGenerator/ASP_cleaned/games/lecture_14.lp",
					"GameGenerator/ASP_cleaned/games/lecture_15.lp",
					"GameGenerator/ASP_cleaned/games/lecture_16.lp",
					"GameGenerator/ASP_cleaned/games/lecture_17.lp",
					"GameGenerator/ASP_cleaned/games/lecture_18.lp",
					"GameGenerator/ASP_cleaned/games/lecture_19.lp",
					"GameGenerator/ASP_cleaned/games/lecture_20.lp",
					"GameGenerator/ASP_cleaned/games/lecture_21.lp",
					"GameGenerator/ASP_cleaned/games/lecture_22.lp",
					"GameGenerator/ASP_cleaned/games/lecture_23.lp",
					"GameGenerator/ASP_cleaned/games/lecture_24.lp",
					"GameGenerator/ASP_cleaned/games/lecture_25.lp",
				],
				gameString : "var variables;function preload(){};function create(){};function update(){};function getAspGoals(){}"
			},
			{
				id: "finalFaculty",
				aspFilepaths: [
					"GameGenerator/ASP_cleaned/games/dean_1.lp",
					"GameGenerator/ASP_cleaned/games/dean_2.lp",
					"GameGenerator/ASP_cleaned/games/dean_3.lp",
					"GameGenerator/ASP_cleaned/games/dean_4.lp",
					"GameGenerator/ASP_cleaned/games/dean_5.lp",
					"GameGenerator/ASP_cleaned/games/dean_6.lp",
					"GameGenerator/ASP_cleaned/games/dean_7.lp",
					"GameGenerator/ASP_cleaned/games/dean_8.lp",
					"GameGenerator/ASP_cleaned/games/dean_9.lp",
					"GameGenerator/ASP_cleaned/games/dean_10.lp",
					"GameGenerator/ASP_cleaned/games/dean_11.lp",
					"GameGenerator/ASP_cleaned/games/dean_12.lp",
					"GameGenerator/ASP_cleaned/games/dean_13.lp",
					"GameGenerator/ASP_cleaned/games/dean_14.lp",
					"GameGenerator/ASP_cleaned/games/dean_15.lp",
					"GameGenerator/ASP_cleaned/games/dean_16.lp",
					"GameGenerator/ASP_cleaned/games/dean_17.lp",
					"GameGenerator/ASP_cleaned/games/dean_18.lp",
					"GameGenerator/ASP_cleaned/games/dean_19.lp",
					"GameGenerator/ASP_cleaned/games/dean_20.lp",
					"GameGenerator/ASP_cleaned/games/dean_21.lp",
					"GameGenerator/ASP_cleaned/games/dean_22.lp",
					"GameGenerator/ASP_cleaned/games/dean_23.lp",
					"GameGenerator/ASP_cleaned/games/dean_24.lp",
					"GameGenerator/ASP_cleaned/games/dean_25.lp",
				],
				gameString : "var variables;function preload(){};function create(){};function update(){};function getAspGoals(){}"
			},
		];

		var gameSpec = gameResources.filter(function(v) { return v.id === id; })[0];		//grab all filepaths for our id
		Game.init(gameSpec, State, Display, this);
	}

	return {
		init : init,
		loadStoryMaterials : loadStoryMaterials,
		loadAvatars : loadAvatars,
		loadBackground : loadBackground,
		validateArtAssets : validateArtAssets,
		loadSceneIntro : loadSceneIntro,
		getNextScene : getNextScene,
		cleanState : cleanState,

		startGame : startGame,
		getStorySpec : getStorySpec
	}
});
