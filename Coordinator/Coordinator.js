define(["Display", "StoryDisplay", "State", "ChunkLibrary", "Wishlist", "StoryAssembler", "Character","Game", "Hanson", "text!travelData", "text!workerData", "text!lectureData", "text!dinnerData", "text!generalistData", "text!newExampleData", "text!undergradDinnerData_kevin",
	"text!undergradDinnerData_talon", "text!undergradDinnerData_irapopor", "text!undergradDinnerData_sgadsby", "text!undergradDinnerData_madreed", "text!undergradDinnerData_sjsherma", "text!undergradDean_sgadsby", "text!undergradDean_talon", "text!undergradDean_irapopor", "text!undergradLecture_kply", "text!undergradLecture_sjsherma", "text!undergradTravel_sjsherma", "text!undergradTravel_kply", "text!undergradFamilyDinner_sgadsby", "text!undergradFamilyDinner_talon","text!undergradFamilyDinner_irapopor", "text!globalData"], function(Display, StoryDisplay, State, ChunkLibrary, Wishlist, StoryAssembler, Character, Game, Hanson, travelData, workerData, lectureData, dinnerData, generalistData, newExampleData, undergradDinnerData_kevin, undergradDinnerData_talon, undergradDinnerData_irapopor, undergradDinnerData_sgadsby, undergradDinnerData_madreed, undergradDinnerData_sjsherma, undergradDean_sgadsby, undergradDean_talon, undergradDean_irapopor, undergradLecture_kply, undergradLecture_sjsherma, undergradTravel_sjsherma, undergradTravel_kply, undergradFamilyDinner_sgadsby, undergradFamilyDinner_talon, undergradFamilyDinner_irapopor, globalData) {

	/*
		Initializing function
	*/
	var init = function() {

		//var scenes = ["dinner", "lecture", "travel", "worker" ];	//order of scenes
		var scenes = ["dinner", "dinner_argument", "generalist", "lecture", "travel", "worker", "newExample", "undergradDinner", "undergradLecture", "undergradDean", "undergradTravel", "undergradFamilyDinner"];	//order of scenes
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
		Display.setStats("storyStats");
		StoryAssembler.beginScene(wishlist, ChunkLibrary, State, StoryDisplay, Display, Character);
		StoryDisplay.addVarChangers(story.UIvars, StoryAssembler.clickChangeState);		//add controls to change variable values in story (in diagnostics panel)
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
				{ condition: "friendTension gte 4"},
				{ condition: "friendTensionRelieved eq true"},
				{ condition: "checkinWithDisagreer eq true"},
				{ condition: "inactivityIsBad eq true", order: "first"},
				{ condition: "outro eq true", order: "last"},
			],
			//if you just want to use one file, uncomment this and comment out the big block below
			//dataFiles: ["text!undergradDinnerData_irapopor"],

			dataFiles: [
				"text!undergradDinnerData_kevin",
				"text!undergradDinnerData_talon",
				"text!undergradDinnerData_irapopor",
				"text!undergradDinnerData_sgadsby",
				"text!undergradDinnerData_madreed",
				"text!undergradDinnerData_sjsherma"],

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
				"set friendTension 0"			//scale of 1 to 10, ten is high tension
			],
			UIvars: [
				"confidence",
				"academicEnthusiasm",
				"friendTension",
				"academicFriendRelationship",
				"nonAcademicFriendRelationship"


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

				"set composure 10",
				"set curiosity 3",
				"set hope 5",
				"set optimism 7",

				"set questionsLeft 4",
			],
			UIvars: [
				"composure",
				"curiosity",
				"hope",
				"optimism",
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
				"tension"

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
				{ condition: "onAPlane eq true"},
				{ condition: "reminisce eq true"},
				{ condition: "talkExposition eq true"},
				{ condition: "dealWithSomeone eq true"},
				{ condition: "readSomething eq true"},
				{ condition: "acceptOrDeclineSomething eq true"},
				{ condition: "outroForLanding eq true"}
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

				"set academicEnthusiasm 0",			//global stat
				"set curiosity 5",	//global stat
				"set hope 5",	//global stat
				"set optimism 5",	//global stat
				
				"set composure 5",
				"set carbonFootprint 0",
				"set fame 0"
			],
			UIvars: [
				"carbonFootprint",
				"composure",
				"fame"

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
				"confidence",
				"hope",
				"tension"

			],
			mode: {
				type: "dialogue",
				initiator: "mom",
				responder: "protagonist"
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
				text : "<p>You were able to secure a job as an adjunct professor in Environmental Sciences.</p><p>Dr. Tennerson, a senior faculty member, as been sent to evaluate how the class is going.</p><p>Choose what Emma says, but make sure to keep your cool!</p>"
			},
			{
				id : "undergradDean",
				text : "<p>TODO: Scene description</p>"
			},
			{
				id : "undergradTravel",
				text : "<p>TODO: Scene description</p>"
			},
			{
				id : "undergradFamilyDinner",
				text : "<p>TODO: Scene description</p>"
			}


		]
		var sceneText = sceneScreens.filter(function(v) { return v.id === id; })[0].text;
		Display.setSceneIntro(sceneText);
	};

	//loads background, for now this is based on scene id
	var loadBackground = function(id) {
		var sceneBgs = [
			{
				id : "newExample",
				src : "dinner.png"
			},
			{
				id : "dinner",
				src : "dinner.png"
			},
			{
				id : "dinner_argument",
				src : "dinner.png"
			},
			{
				id : "generalist",
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
			{
				id : "undergradDinner",
				src : "travel.png"
			},
			{
				id : "undergradLecture",
				src : "lecture.png"
			},
			{
				id : "undergradDean",
				src : "lecture.png"
			},
			{
				id : "undergradTravel",
				src : "lecture.png"
			},
			{
				id : "undergradFamilyDinner",
				src : "lecture.png"
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
				id : "newExample",
				avatars: [
					{
						id: "happy",
						src: "happy.png",
						state: ["introductions gt 0"]
					},
				]
			},
			{
				id : "dinner",
				avatars: [
					{
						id: "happy",
						src: "happy.png",
						state: ["patience gt 9"]
					},
					{
						id: "worried",
						src: "worried.png",
						state: ["patience eq 8.9"]
					},
					{
						id: "stressed",
						src: "stressed.png",
						state: ["patience eq 8"]
					},
				]
			},
			{
				id : "dinner_argument",
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
				id : "generalist",
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
			},
			{
				id : "undergradDinner",
				avatars: [
					{
						id: "happy",
						src: "happy.png",
						state: ["confidence gt -1000"]
					},
				]
			},
			{
				id : "undergradLecture",
				avatars: [
					{
						id: "happy",
						src: "happy.png",
						state: ["composure gt 4"]
					},
					{
						id: "worried",
						src: "worried.png",
						state: ["composure eq 2"]
					},
					{
						id: "stressed",
						src: "stressed.png",
						state: ["composure eq 0"]
					},
				]
			},
			{
				id : "undergradDean",
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
				id : "undergradTravel",
				avatars: [
					{
						id: "happy",
						src: "happy.png",
						state: ["composure gt 4"]
					},
					{
						id: "worried",
						src: "worried.png",
						state: ["composure eq 2"]
					},
					{
						id: "stressed",
						src: "stressed.png",
						state: ["composure eq 0"]
					},
				]
			},
			{
				id : "undergradFamilyDinner",
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

		var gameResources = [
			{
				id: "newExample",
				aspFilepaths: ['asp-phaser-generator-2/test/fixtures/game-10_2_handModified.lp'],
				gameString : "var variables;function preload(){};function create(){};function update(){};function getAspGoals(){}"
			},
			{
				id: "undergradDinner",
				aspFilepaths: ['asp-phaser-generator-2/test/fixtures/game-10_2_handModified.lp'],
				gameString : "var variables;function preload(){};function create(){};function update(){};function getAspGoals(){}"
			},
			{
				id: "undergradLecture",
				aspFilepaths: ['asp-phaser-generator-2/test/fixtures/game-10_2_handModified.lp'],
				gameString : "var variables;function preload(){};function create(){};function update(){};function getAspGoals(){}"
			},
			{
				id: "undergradDean",
				aspFilepaths: ['asp-phaser-generator-2/test/fixtures/game-10_2_handModified.lp'],
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
				id: "dinner",
				aspFilepaths: ['tempgames/games_5_5/games_5_5_1.lp','tempgames/games_5_5/games_5_5_2.lp','tempgames/games_5_5/games_5_5_3.lp','tempgames/games_5_5/games_5_5_4.lp','tempgames/games_5_5/games_5_5_5.lp','tempgames/games_5_5/games_5_5_6.lp','tempgames/games_5_5/games_5_5_7.lp','tempgames/games_5_5/games_5_5_8.lp','tempgames/games_5_5/games_5_5_9.lp','tempgames/games_5_5/games_5_5_10.lp','tempgames/games_5_5/games_5_5_11.lp','tempgames/games_5_5/games_5_5_12.lp','tempgames/games_5_5/games_5_5_13.lp','tempgames/games_5_5/games_5_5_14.lp','tempgames/games_5_5/games_5_5_15.lp','tempgames/games_5_5/games_5_5_16.lp','tempgames/games_5_5/games_5_5_17.lp','tempgames/games_5_5/games_5_5_18.lp','tempgames/games_5_5/games_5_5_19.lp','tempgames/games_5_5/games_5_5_20.lp','tempgames/games_5_5/games_5_5_21.lp','tempgames/games_5_5/games_5_5_22.lp','tempgames/games_5_5/games_5_5_23.lp','tempgames/games_5_5/games_5_5_24.lp','tempgames/games_5_5/games_5_5_25.lp','tempgames/games_5_5/games_5_5_26.lp','tempgames/games_5_5/games_5_5_27.lp','tempgames/games_5_5/games_5_5_28.lp','tempgames/games_5_5/games_5_5_29.lp','tempgames/games_5_5/games_5_5_30.lp','tempgames/games_5_5/games_5_5_31.lp','tempgames/games_5_5/games_5_5_32.lp','tempgames/games_5_5/games_5_5_33.lp','tempgames/games_5_5/games_5_5_34.lp','tempgames/games_5_5/games_5_5_35.lp','tempgames/games_5_5/games_5_5_36.lp','tempgames/games_5_5/games_5_5_37.lp','tempgames/games_5_5/games_5_5_38.lp','tempgames/games_5_5/games_5_5_39.lp','tempgames/games_5_5/games_5_5_40.lp','tempgames/games_5_5/games_5_5_41.lp','tempgames/games_5_5/games_5_5_42.lp','tempgames/games_5_5/games_5_5_43.lp','tempgames/games_5_5/games_5_5_44.lp','tempgames/games_5_5/games_5_5_45.lp','tempgames/games_5_5/games_5_5_46.lp','tempgames/games_5_5/games_5_5_47.lp','tempgames/games_5_5/games_5_5_48.lp','tempgames/games_5_5/games_5_5_49.lp','tempgames/games_5_5/games_5_5_50.lp'],
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
			}
		];

		var gameSpec = gameResources.filter(function(v) { return v.id === id; })[0];		//grab all filepaths for our id
		Game.init(gameSpec, State, Display);
	}

	return {
		init : init,
		loadStoryMaterials : loadStoryMaterials,
		loadAvatars : loadAvatars,
		loadSceneIntro : loadSceneIntro,
		loadBackground : loadBackground,
		startGame : startGame,
		getStorySpec : getStorySpec
	}
});
