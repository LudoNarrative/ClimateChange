requirejs.config({
	paths: {
		"domReady": "../lib/domReady",
		"text": "../lib/text",
		"underscore": "../lib/underscore-1.8.3.min",

		"util": "util",
		"StoryAssembler": "StoryAssembler",
		"StoryDisplay": "Display",
		"State": "State",
		"Wishlist" : "Wishlist",
		"Condition": "Condition",
		"Request": "Request",
		"Want": "Want",
		"Validate": "Validate",
		"ChunkLibrary": "ChunkLibrary",
		"BestPath": "BestPath",
		"Templates": "Templates",
		"Character": "Character",
		"Hanson": "Hanson",

		"globalData" : "../data/global.json",
		"travelData" : "../data/travel.json", 
		"workerData" : "../data/worker.json", 
		"lectureData" : "../data/lecture.json", 
		"dinnerData" : "../data/dinner2.json",

		"Coordinator" : "../../Coordinator/Coordinator",
		"Display" : "../../js/Display",

		"Phaser" : "../../lib/phaser",
		"jQuery": "../../lib/jquery-3.0.0.min",
		"jQueryUI": "../../lib/jquery-ui.min",
		"jsonEditor": "../../lib/jsonEditor/jsoneditor",
		"cytoscape": "../../lib/cystoscape",

		"Game" : "../../GameGenerator/js/game",
		"AspPhaserGenerator" : "../../asp-phaser-generator/index",
		"translateAsp" : '../../asp-phaser-generator/src/asp-to-cygnus',
		"rensa" : '../../asp-phaser-generator/src/brain',
		"ctp" : '../../asp-phaser-generator/src/cygnus-to-phaser-brain',
		"translatePhaserBrain" : '../../asp-phaser-generator/src/phaser-brain-to-code'
	},

	shim: {
		"jQueryUI": {
			export: "$",
			deps: ["jQuery"]
		}
	}
});

requirejs(
	["State", "StoryDisplay", "Display", "Coordinator", "ChunkLibrary", "Wishlist", "StoryAssembler", "Character", "Game", "AspPhaserGenerator", "cytoscape", "util", "domReady!"],
	function(State, StoryDisplay, Display, Coordinator, ChunkLibrary, Wishlist, StoryAssembler, Character, Game, AspPhaserGenerator, cytoscape) {

	var formatForEditor = function(mode, data) {

		if (mode == "readIn") {
		/*	data.forEach(function(chunk,pos) {
				chunk.choices.forEach(function(choice, pos) {

				});
			});
			
			*/
			return data;
		}

		if (mode == "readOut") {
			return data;
		}
	}

	//----------------------------------------------------------------------------------------

	//Coordinator.init();
	var scenes = ["dinner", "lecture", "travel", "worker" ];	//order of scenes
	State.set("scenes", scenes);

	id = "dinner";

	State.set("currentScene", id);
	var story = Coordinator.getStorySpec(id);
	story.startState.forEach(function(command) {
		State.change(command);
	});
	var levelData = HanSON.parse(story.dataFile);
	var globalDataFile = require("text!globalData");
	var globalData = HanSON.parse(globalDataFile);
	ChunkLibrary.reset();
	ChunkLibrary.add(levelData);
	ChunkLibrary.add(globalData);

	var wishlist = Wishlist.create(story.wishlist, State);
	wishlist.logOn();
	if (story.characters) {
		Character.init(State);
		for (var key in story.characters) {
			Character.add(key, story.characters[key]);
		}
	}

	$('body').append("<button id='submit'>Save JSON file</button><button id='restore'>Reset Changes</button><span id='valid_indicator'></span><div id='editor_holder'></div>");
    
    var starting_value = formatForEditor("readIn", levelData);		//starting value for editor
    //var starting_value;
      
	// Initialize the editor
	var editor = new JSONEditor(document.getElementById('editor_holder'),{
		// Enable fetching schemas via ajax
		ajax: true,
		remove_empty_properties : true,
		// The schema for the editor
		schema: {
		  type: "array",
		  title: "Chunk",
		  format: "tabs",
		  items: {
		    title: "Chunk",
		    headerTemplate: "{{self.id}}",
		    oneOf: [
		      {
		        $ref: "data/exampleData/schema/chunkSchema.json",
		        title: "Chunk"
		      },
		      {
		        $ref: "data/exampleData/schema/choiceChunkSchema.json",
		        title: "Choice Chunk"
		      }
		    ]
		  }
		},

		// Seed the form with a starting value
		startval: starting_value,

		// Disable additional properties
		no_additional_properties: true,

		// Require all properties by default
		required_by_default: true
	});


	// Hook up the submit button to log to the console
	/*
	$('#submit').click(function() {
		if (JSON.stringify(editor.getValue()) === JSON.stringify(starting_value) ) {
			console.log("No changes made!");
		}
		else { console.log("changes made!: "); }
		console.log(JSON.stringify(formatForEditor("readOut", editor.getValue())));		// Get the value from the editor
	});*/

	$('#submit').click(function() {                  

		var blob = new Blob([JSON.stringify(editor.getValue())], {type: "text/plain;charset=utf-8"});
        saveAs(blob, "hello world.txt");
    });

	// Hook up the Restore to Default button
	$('#restore').click(function() {
		editor.setValue(starting_value);
	});
	/*      
	// Hook up the enable/disable button
	document.getElementById('enable_disable').addEventListener('click',function() {
	// Enable form
	if(!editor.isEnabled()) {
	  editor.enable();
	}
	// Disable form
	else {
	  editor.disable();
	}
	});
	*/

	// Hook up the validation indicator to update its 
	// status whenever the editor changes
	editor.on('change',function() {
	// Get an array of errors from the validator
	var errors = editor.validate();

	var indicator = document.getElementById('valid_indicator');

	// Not valid
	if(errors.length) {
	  indicator.style.color = 'red';
	  indicator.textContent = "not valid";
	}
	// Valid
	else {
	  indicator.style.color = 'green';
	  indicator.textContent = "valid";
	}
	});

	//StoryAssembler.beginScene(wishlist, ChunkLibrary, State, StoryDisplay, Display, Character);


});