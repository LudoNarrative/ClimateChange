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
		ChunkLibrary.reset();
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
				{ condition: "classOver eq true", persistent: true }
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

		var gameResources = [
			{
				id: "dinner",
				aspFilepaths: ['asp-phaser-generator/test/fixtures/asp-game-1.lp'],
				gameString : "var variables;var gridSize;var gridLinesHorizontal;var gridLinesVertical;var grid;var gridIdx;var addedEntities;var low;var medium;var mid;var high;var goals;var e1;var e2;var r1;var r2;function preload(){game.load.image('e1','assets/sprites/circle.png');game.load.image('e2','assets/sprites/pentagon.png');};function create(){variables={'confidence':'5','optimism':'2','difficulty':'3'};gridSize=30;gridLinesHorizontal=Math.floor((game.width-1)/gridSize);gridLinesVertical=Math.floor((game.height-1)/gridSize);grid=initGrid();gridIdx=0;addedEntities={};low=1;medium=6;mid=medium;high=11;goals=[];r1=medium;r2=0;e1=addAtRandomPoint('e1');addedEntities['e1']=e1;initEntityProperties('e1');e2=addAtRandomPoint('e2');addedEntities['e2']=e2;initEntityProperties('e2');e2.inputEnabled=true;e2.events.onInputDown.add(e2ClickListener,this);};function update(){r1=r1-low;r2=r2-low;if(Phaser.Point.distance(new Phaser.Point(e1.x,e1.y),new Phaser.Point(e2.x,e2.y)) < game.width*0.1 && r2>=high){r1=r1+r2;}if(r1<=low){}var tempPoint = new Phaser.Point(e2.x-e1.x,e2.y-e1.y);tempPoint.normalize();move_away(e1, tempPoint);e1.body.gravity.y = mid;e2.body.gravity.y = mid;for(var k in addedEntities) {if (addedEntities.hasOwnProperty(k)) {var entity = addedEntities[k];entity.directionChange.clamp(0,1);entity.x+=entity.directionChange.x;entity.y+=entity.directionChange.y;if(entity.x>game.width){entity.x=game.width;}if (entity.x<0){entity.x=0;} if (entity.y>game.height){entity.y=game.height;}if (entity.y<0){entity.y=0;}}}};function render(){};function e2ClickListener(){e1=addAtRandomPoint('e1');addedEntities['e1']=e1;initEntityProperties('e1');r2=r2+high;r1=r1-medium;};function setVariable(varName,value){variables[varName]=value;State.set(varName, value);StoryAssembler.refreshNarrative();Display.setAvatar(State);};function getVariable(varName){return variables[varName];};function getRandomPoint(){var x=game.rnd.integerInRange(0,game.world.width-1);var y=game.rnd.integerInRange(0,game.world.height-1);return new Phaser.Point(x,y);};function initGrid(){grid=[];for(var i=0;i<gridLinesHorizontal;i++){for(var j=0;j<gridLinesVertical;j++){grid.push(new Phaser.Point(i*gridSize,j*gridSize));}}shuffle(grid);return grid;};function addAtRandomPoint(sprite){var spawned=addAtPos(grid[gridIdx], sprite);gridIdx++;if(gridIdx===grid.length){gridIdx=0;shuffle(grid);}return spawned;};function addAtPos(point,sprite){return game.add.sprite(point.x,point.y,sprite);};function shuffle(a){var j,x,i;for(i=a.length;i;i--){j=Math.floor(Math.random()*i);x=a[i-1];a[i-1]=a[j];a[j]=x;}};function move_towards(e,dir){e.directionChange.x += dir.x;e.directionChange.y += dir.y;};function move_away(e,dir){e.directionChange.x -= dir.x;e.directionChange.y -= dir.y;};function move(e,x,y){e.directionChange.x += x;e.directionChange.y += y;};function initEntityProperties(eName){game.physics.arcade.enable(addedEntities[eName]);addedEntities[eName].body.collideWorldBounds = true;if (!addedEntities[eName].body.velocity.hasOwnProperty('x')){addedEntities[eName].body.velocity.x=0;}if (!addedEntities[eName].body.velocity.hasOwnProperty('y')){addedEntities[eName].body.velocity.y=0;}if (!addedEntities[eName].body.hasOwnProperty('angularVelocity')){addedEntities[eName].body.angularVelocity=0;}if (!addedEntities[eName].hasOwnProperty('directionChange')){addedEntities[eName].directionChange=new Phaser.Point(0,0);}};function changeMode(newMode){if(newMode==='game_win'){mode = 'win'; game.world.removeAll(); displayText('CLEARED');}else if(newMode==='game_loss'){mode='loss'; game.stage.backgroundColor = '#400';}};function displayText(t){var style = { font: 'bold 32px Arial', fill: '#fff', boundsAlignH: 'center', boundsAlignV: 'middle'};text = game.add.text(0, 0, t, style);};function getAspGoals(){if (goals === undefined || goals.length == 0){return ['No ASP goals.'];}else{return goals;}};goals=['Prevent:[r1] le [low]','Maintain r1'];"
			},
			{
				id: "lecture",
				aspFilepaths: ['asp-phaser-generator/test/fixtures/asp-game-2.lp'],
				gameString: "var variables;var gridSize;var gridLinesHorizontal;var gridLinesVertical;var grid;var gridIdx;var addedEntities;var low;var medium;var mid;var high;var goals;var e1;var e2;var r1;var r2;function preload(){game.load.image('e1','assets/sprites/circle.png');game.load.image('e2','assets/sprites/square.png');};function create(){variables={'confidence':'5','optimism':'2','difficulty':'3'};gridSize=30;gridLinesHorizontal=Math.floor((game.width-1)/gridSize);gridLinesVertical=Math.floor((game.height-1)/gridSize);grid=initGrid();gridIdx=0;addedEntities={};low=1;medium=6;mid=medium;high=11;goals=[];r1=low;r2=low;e1=addAtRandomPoint('e1');addedEntities['e1']=e1;initEntityProperties('e1');e2=addAtRandomPoint('e2');addedEntities['e2']=e2;initEntityProperties('e2');};function update(){r1=r1-high;r2=r2-medium;if(r1<=0){}if(Phaser.Point.distance(new Phaser.Point(e1.x,e1.y),new Phaser.Point(e2.x,e2.y)) < game.width*0.1 && r2>=r1){r1=r1-medium;}if(Phaser.Point.distance(new Phaser.Point(e1.x,e1.y),new Phaser.Point(e2.x,e2.y)) < game.width*0.1 && game.input.activePointer.leftButton.isDown){e2=addAtRandomPoint('e2');addedEntities['e2']=e2;initEntityProperties('e2');r1=r1+r2;r2=r2+r1;}var tempPoint = new Phaser.Point(game.input.mousePointer.x-e2.x,game.input.mousePointer.y-e2.y);tempPoint.normalize();move_away(e2, tempPoint);var tempPoint = new Phaser.Point(e1.x-e2.x,e1.y-e2.y);tempPoint.normalize();move_away(e2, tempPoint);e2.body.gravity.y = mid;for(var k in addedEntities) {if (addedEntities.hasOwnProperty(k)) {var entity = addedEntities[k];entity.directionChange.clamp(0,1);entity.x+=entity.directionChange.x;entity.y+=entity.directionChange.y;if(entity.x>game.width){entity.x=game.width;}if (entity.x<0){entity.x=0;} if (entity.y>game.height){entity.y=game.height;}if (entity.y<0){entity.y=0;}}}};function render(){};function setVariable(varName,value){variables[varName]=value;State.set(varName, value);StoryAssembler.refreshNarrative();Display.setAvatar(State);};function getVariable(varName){return variables[varName];};function getRandomPoint(){var x=game.rnd.integerInRange(0,game.world.width-1);var y=game.rnd.integerInRange(0,game.world.height-1);return new Phaser.Point(x,y);};function initGrid(){grid=[];for(var i=0;i<gridLinesHorizontal;i++){for(var j=0;j<gridLinesVertical;j++){grid.push(new Phaser.Point(i*gridSize,j*gridSize));}}shuffle(grid);return grid;};function addAtRandomPoint(sprite){var spawned=addAtPos(grid[gridIdx], sprite);gridIdx++;if(gridIdx===grid.length){gridIdx=0;shuffle(grid);}return spawned;};function addAtPos(point,sprite){return game.add.sprite(point.x,point.y,sprite);};function shuffle(a){var j,x,i;for(i=a.length;i;i--){j=Math.floor(Math.random()*i);x=a[i-1];a[i-1]=a[j];a[j]=x;}};function move_towards(e,dir){e.directionChange.x += dir.x;e.directionChange.y += dir.y;};function move_away(e,dir){e.directionChange.x -= dir.x;e.directionChange.y -= dir.y;};function move(e,x,y){e.directionChange.x += x;e.directionChange.y += y;};function initEntityProperties(eName){game.physics.arcade.enable(addedEntities[eName]);addedEntities[eName].body.collideWorldBounds = true;if (!addedEntities[eName].body.velocity.hasOwnProperty('x')){addedEntities[eName].body.velocity.x=0;}if (!addedEntities[eName].body.velocity.hasOwnProperty('y')){addedEntities[eName].body.velocity.y=0;}if (!addedEntities[eName].body.hasOwnProperty('angularVelocity')){addedEntities[eName].body.angularVelocity=0;}if (!addedEntities[eName].hasOwnProperty('directionChange')){addedEntities[eName].directionChange=new Phaser.Point(0,0);}};function changeMode(newMode){if(newMode==='game_win'){mode = 'win'; game.world.removeAll(); displayText('CLEARED');}else if(newMode==='game_loss'){mode='loss'; game.stage.backgroundColor = '#400';}};function displayText(t){var style = { font: 'bold 32px Arial', fill: '#fff', boundsAlignH: 'center', boundsAlignV: 'middle'};text = game.add.text(0, 0, t, style);};function getAspGoals(){if (goals === undefined || goals.length == 0){return ['No ASP goals.'];}else{return goals;}};goals=['Prevent:[r1] le [0]','Maintain r1'];"
			},
			{
				id: "worker",
				aspFilepaths: ['asp-phaser-generator/test/fixtures/asp-game-3.lp'],
				gameString: "var variables;var gridSize;var gridLinesHorizontal;var gridLinesVertical;var grid;var gridIdx;var addedEntities;var low;var medium;var mid;var high;var goals;var e1;var e2;var r1;var r2;function preload(){game.load.image('e1','assets/sprites/pentagon.png');game.load.image('e2','assets/sprites/triangle.png');};function create(){variables={'confidence':'5','optimism':'2','difficulty':'3'};gridSize=30;gridLinesHorizontal=Math.floor((game.width-1)/gridSize);gridLinesVertical=Math.floor((game.height-1)/gridSize);grid=initGrid();gridIdx=0;addedEntities={};low=1;medium=6;mid=medium;high=11;goals=[];r1=medium;r2=medium;e1=addAtRandomPoint('e1');addedEntities['e1']=e1;initEntityProperties('e1');e2=addAtRandomPoint('e2');addedEntities['e2']=e2;initEntityProperties('e2');e1.inputEnabled=true;e1.events.onInputDown.add(e1ClickListener,this);};function update(){r2=r2+high;r1=r1-medium;if(r1<=low){}if(Phaser.Point.distance(new Phaser.Point(e1.x,e1.y),new Phaser.Point(e2.x,e2.y)) < game.width*0.1 && r2>=0){r1=r1-high;}if(Phaser.Point.distance(new Phaser.Point(e1.x,e1.y),new Phaser.Point(e2.x,e2.y)) < game.width*0.1 && r2<=0){r1=r1+r2;}var tempPoint = new Phaser.Point(game.input.mousePointer.x-e2.x,game.input.mousePointer.y-e2.y);tempPoint.normalize();move_away(e2, tempPoint);var tempPoint = new Phaser.Point(e1.x-e2.x,e1.y-e2.y);tempPoint.normalize();move_away(e2, tempPoint);e1.body.gravity.y = mid;for(var k in addedEntities) {if (addedEntities.hasOwnProperty(k)) {var entity = addedEntities[k];entity.directionChange.clamp(0,1);entity.x+=entity.directionChange.x;entity.y+=entity.directionChange.y;if(entity.x>game.width){entity.x=game.width;}if (entity.x<0){entity.x=0;} if (entity.y>game.height){entity.y=game.height;}if (entity.y<0){entity.y=0;}}}};function render(){};function e1ClickListener(){e2=addAtRandomPoint('e2');addedEntities['e2']=e2;initEntityProperties('e2');r1=r1-r2;r2=r2-high;};function setVariable(varName,value){variables[varName]=value;State.set(varName, value);StoryAssembler.refreshNarrative();Display.setAvatar(State);};function getVariable(varName){return variables[varName];};function getRandomPoint(){var x=game.rnd.integerInRange(0,game.world.width-1);var y=game.rnd.integerInRange(0,game.world.height-1);return new Phaser.Point(x,y);};function initGrid(){grid=[];for(var i=0;i<gridLinesHorizontal;i++){for(var j=0;j<gridLinesVertical;j++){grid.push(new Phaser.Point(i*gridSize,j*gridSize));}}shuffle(grid);return grid;};function addAtRandomPoint(sprite){var spawned=addAtPos(grid[gridIdx], sprite);gridIdx++;if(gridIdx===grid.length){gridIdx=0;shuffle(grid);}return spawned;};function addAtPos(point,sprite){return game.add.sprite(point.x,point.y,sprite);};function shuffle(a){var j,x,i;for(i=a.length;i;i--){j=Math.floor(Math.random()*i);x=a[i-1];a[i-1]=a[j];a[j]=x;}};function move_towards(e,dir){e.directionChange.x += dir.x;e.directionChange.y += dir.y;};function move_away(e,dir){e.directionChange.x -= dir.x;e.directionChange.y -= dir.y;};function move(e,x,y){e.directionChange.x += x;e.directionChange.y += y;};function initEntityProperties(eName){game.physics.arcade.enable(addedEntities[eName]);addedEntities[eName].body.collideWorldBounds = true;if (!addedEntities[eName].body.velocity.hasOwnProperty('x')){addedEntities[eName].body.velocity.x=0;}if (!addedEntities[eName].body.velocity.hasOwnProperty('y')){addedEntities[eName].body.velocity.y=0;}if (!addedEntities[eName].body.hasOwnProperty('angularVelocity')){addedEntities[eName].body.angularVelocity=0;}if (!addedEntities[eName].hasOwnProperty('directionChange')){addedEntities[eName].directionChange=new Phaser.Point(0,0);}};function changeMode(newMode){if(newMode==='game_win'){mode = 'win'; game.world.removeAll(); displayText('CLEARED');}else if(newMode==='game_loss'){mode='loss'; game.stage.backgroundColor = '#400';}};function displayText(t){var style = { font: 'bold 32px Arial', fill: '#fff', boundsAlignH: 'center', boundsAlignV: 'middle'};text = game.add.text(0, 0, t, style);};function getAspGoals(){if (goals === undefined || goals.length == 0){return ['No ASP goals.'];}else{return goals;}};goals=['Prevent:[r1] le [low]','Maintain r1'];"
			},
			{
				id: "travel",
				aspFilepaths: ['asp-phaser-generator/test/fixtures/asp-game-4.lp'],
				gameString: "var variables;var gridSize;var gridLinesHorizontal;var gridLinesVertical;var grid;var gridIdx;var addedEntities;var low;var medium;var mid;var high;var goals;var e1;var e2;var r1;var r2;function preload(){game.load.image('e1','assets/sprites/square.png');game.load.image('e2','assets/sprites/circle.png');};function create(){variables={'confidence':'5','optimism':'2','difficulty':'3'};gridSize=30;gridLinesHorizontal=Math.floor((game.width-1)/gridSize);gridLinesVertical=Math.floor((game.height-1)/gridSize);grid=initGrid();gridIdx=0;addedEntities={};low=1;medium=6;mid=medium;high=11;goals=[];r1=low;r2=high;e1=addAtRandomPoint('e1');addedEntities['e1']=e1;initEntityProperties('e1');e2=addAtRandomPoint('e2');addedEntities['e2']=e2;initEntityProperties('e2');};function update(){r2=r2+r1;r1=r1-r2;if(Phaser.Point.distance(new Phaser.Point(e1.x,e1.y),new Phaser.Point(e2.x,e2.y)) < game.width*0.1 && r1<=low){r2=r2-low;}if(r1<=0){}if(Phaser.Point.distance(new Phaser.Point(e1.x,e1.y),new Phaser.Point(e2.x,e2.y)) < game.width*0.1 && r2>=high){r1=r1+r2;}if(!game.input.activePointer.leftButton.isDown){e1=addAtRandomPoint('e1');addedEntities['e1']=e1;initEntityProperties('e1');r2=r2+low;r1=r1-high;}var tempPoint = new Phaser.Point(game.input.mousePointer.x-e1.x,game.input.mousePointer.y-e1.y);tempPoint.normalize();move_away(e1, tempPoint);var tempPoint = new Phaser.Point(e1.x-e2.x,e1.y-e2.y);tempPoint.normalize();move_away(e2, tempPoint);e1.body.gravity.y = mid;e2.body.gravity.y = mid;for(var k in addedEntities) {if (addedEntities.hasOwnProperty(k)) {var entity = addedEntities[k];entity.directionChange.clamp(0,1);entity.x+=entity.directionChange.x;entity.y+=entity.directionChange.y;if(entity.x>game.width){entity.x=game.width;}if (entity.x<0){entity.x=0;} if (entity.y>game.height){entity.y=game.height;}if (entity.y<0){entity.y=0;}}}};function render(){};function setVariable(varName,value){variables[varName]=value;State.set(varName, value);StoryAssembler.refreshNarrative();Display.setAvatar(State);};function getVariable(varName){return variables[varName];};function getRandomPoint(){var x=game.rnd.integerInRange(0,game.world.width-1);var y=game.rnd.integerInRange(0,game.world.height-1);return new Phaser.Point(x,y);};function initGrid(){grid=[];for(var i=0;i<gridLinesHorizontal;i++){for(var j=0;j<gridLinesVertical;j++){grid.push(new Phaser.Point(i*gridSize,j*gridSize));}}shuffle(grid);return grid;};function addAtRandomPoint(sprite){var spawned=addAtPos(grid[gridIdx], sprite);gridIdx++;if(gridIdx===grid.length){gridIdx=0;shuffle(grid);}return spawned;};function addAtPos(point,sprite){return game.add.sprite(point.x,point.y,sprite);};function shuffle(a){var j,x,i;for(i=a.length;i;i--){j=Math.floor(Math.random()*i);x=a[i-1];a[i-1]=a[j];a[j]=x;}};function move_towards(e,dir){e.directionChange.x += dir.x;e.directionChange.y += dir.y;};function move_away(e,dir){e.directionChange.x -= dir.x;e.directionChange.y -= dir.y;};function move(e,x,y){e.directionChange.x += x;e.directionChange.y += y;};function initEntityProperties(eName){game.physics.arcade.enable(addedEntities[eName]);addedEntities[eName].body.collideWorldBounds = true;if (!addedEntities[eName].body.velocity.hasOwnProperty('x')){addedEntities[eName].body.velocity.x=0;}if (!addedEntities[eName].body.velocity.hasOwnProperty('y')){addedEntities[eName].body.velocity.y=0;}if (!addedEntities[eName].body.hasOwnProperty('angularVelocity')){addedEntities[eName].body.angularVelocity=0;}if (!addedEntities[eName].hasOwnProperty('directionChange')){addedEntities[eName].directionChange=new Phaser.Point(0,0);}};function changeMode(newMode){if(newMode==='game_win'){mode = 'win'; game.world.removeAll(); displayText('CLEARED');}else if(newMode==='game_loss'){mode='loss'; game.stage.backgroundColor = '#400';}};function displayText(t){var style = { font: 'bold 32px Arial', fill: '#fff', boundsAlignH: 'center', boundsAlignV: 'middle'};text = game.add.text(0, 0, t, style);};function getAspGoals(){if (goals === undefined || goals.length == 0){return ['No ASP goals.'];}else{return goals;}};goals=['Prevent:[r1] le [0]','Maintain r1'];"
			},

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
		startGame : startGame
	}
});
