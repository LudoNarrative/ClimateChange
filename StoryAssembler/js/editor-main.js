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
		"cytoscape": "../lib/cytoscape",
		"cytoscape-cxtmenu" : "../lib/cytoscape-cxtmenu",
		"cytoscape-edgehandles" : "../lib/cytoscape-edgehandles",

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
	["State", "StoryDisplay", "Display", "cytoscape", "cytoscape-cxtmenu", "Coordinator", "ChunkLibrary", "Wishlist", "StoryAssembler", "Character", "Game", "AspPhaserGenerator", "util", "domReady!"],
	function(State, StoryDisplay, Display, cytoscape, cxtmenu, Coordinator, ChunkLibrary, Wishlist, StoryAssembler, Character, Game, AspPhaserGenerator, util) {

	cxtmenu( cytoscape, $ ); 		// register extension
	var levelData;
	var globalData;
	var story;
	var graphData = [];
	var leftToVisit = [];
	var scene = "dinner";		//later, this should be set from dropdown

	var stateCompares = ["droppedKnowledge", "establishFriendBackstory", "establishSpecialtyInfo", "goto_whatspeciality", "provokeConfidenceChoice"];

	var graphRootId = "";
	var iterNum = 50;
	var iterStep = 0;
	var deadendPaths = 1;


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

	//----RUN-THROUGH HELPER FUNCTIONS------------------------------------------------------
	var getStoryEl = function() {
		return document.getElementById("storyArea").children[0];
	}
	var getChoiceEl = function() {
		return document.getElementById("choiceArea");
	}
	var html = function(el) {
		return el.innerHTML;
	}
	var countChildren = function(el) {
		return el.children.length;
	}
	var child = function(num, el) {
		return el.children[num-1];
	}
	var clickEl = function(el) {
		el.click();
	}
	var clickChoice = function(num) {
		clickEl(child(num, getChoiceEl()));
	}
	var contentForChoice = function(num) {
		return html(child(num, getChoiceEl()));
	}
	var cleanUpDom = function() {
		var el = document.getElementById("storyArea");
		el.parentNode.removeChild(el);
		el = document.getElementById("choiceArea");
		el.parentNode.removeChild(el);
		el = document.getElementById("diagnostics");
		if (el !== null) {
			el.parentNode.removeChild(el);
		}
	}
	//----------------------------------------------------------------------------------------

	var simulateRunthroughs = function() {
		
		require("ChunkLibrary");
		resetStory();

		addToGraph([]);
		stepStory([]);
		
		return graphData
		//cleanUpDom();
	}

	//resets the story, usually called before clicking to re-traverse the choices
	var resetStory = function() {
		var scenes = ["dinner", "lecture", "travel", "worker" ];
		
		ChunkLibrary.reset();
		State.reset();

		State.set("scenes", scenes);
		State.set("currentScene", scene);
		story = Coordinator.getStorySpec(scene);
		story.startState.forEach(function(command) {
			State.change(command);
		});
		levelData = HanSON.parse(story.dataFile);
		var globalDataFile = require("text!globalData");
		globalData = HanSON.parse(globalDataFile);

		ChunkLibrary.add(levelData);
		ChunkLibrary.add(globalData);

		var wishlist = Wishlist.create(story.wishlist, State);
		//wishlist.logOn();

		if (story.characters) {
			Character.init(State);
			for (var key in story.characters) {
				Character.add(key, story.characters[key]);
			}
		}

		StoryAssembler.beginScene(wishlist, ChunkLibrary, State, StoryDisplay);

		$("#storyDiagnostics").hide();
		$("#storyDiagnosticsButton").hide();
	}

	/*
		This function adds a node and edge to the graph
		clickPath: (used when called recursively) the path it took to get us to this chunk
	*/
	var addToGraph = function(clickPath) {

		var newNode = {};
		var uniqueNodeId = "";
		
		if ($("#storyArea span.chunk").html() == "[No path found!]") {		//if there's no path, make node for it
			uniqueNodeId = 'deadend' + deadendPaths;
			//uniqueNodeId = 'deadend';
			newNode = {							//add current node to graph
				group: 'nodes',
				data: {
					id: uniqueNodeId,
					textId: "[No path found!]",	
					clickPath: util.clone(clickPath)
				}			
			};
			deadendPaths++;
		}
		else {
			uniqueNodeId = State.get("currentTextId") + "_" + uniquify();

			if (clickPath.length == 0) { graphRootId = uniqueNodeId; }		//if this was called as the first one, set graph root to that node

			newNode = {							//add current node to graph
				group: 'nodes',
				data: {
					id: uniqueNodeId,
					textId: State.get("currentTextId"),	
					clickPath: util.clone(clickPath)
				}			
			}
		}

		graphData.push(newNode);		//add node to graph

		if (clickPath.length > 0) {

			if (clickPath[clickPath.length-1].source == uniqueNodeId) {
				console.log("what on earth");
			}

			var type = "choice";
			var text = "";

			//if we have an "unknown" link in clickPath from a Continue link, populate that
			if (clickPath[clickPath.length-1].dest == "unknown") {
				clickPath[clickPath.length-1].dest = uniqueNodeId;
				type = "continue";
				text = "Continue";
			}

			else { 
				text = " ";			//TODO: how do I load ChunkLibrary to get the label from the current node?
			}
			var newEdge = {
				group: 'edges',
		      	data: {
		        	//id: 'e1',
		        	//TODO: this says ".id" but we just store the click number right now!
		        	source: clickPath[clickPath.length-1].source,	 // the source node id (edge comes from this node)
		        	target: uniqueNodeId,  		 // the target node id (edge goes to this node)
		        	choiceText: text,
		        	type : type
		      	}
   			}
   			graphData.push(newEdge);		//add edge to graph
		}
	}

	//adds unique string to node ids based off State (so the connections between stuff link up)
	var uniquify = function() {
			var theString = "";
			for (var x=0; x < stateCompares.length; x++) {
				var temp = State.get(stateCompares[x]);
				if (typeof temp == "undefined") { theString += "-u"; }
				else if (temp == false) { theString += "-f"; }
				else if (temp == true) { theString += "-t"; }
				else { theString += "-" + theString; }
			}
			return theString;
			//return clickPath.map(function(obj){return obj.clickNum}).join();
		}

	//steps the story
	var stepStory = function(clickPath) {

		var uniqueNodeId = State.get("currentTextId") + "_" + uniquify();
		var newChoices = checkForNewChoices(graphData, leftToVisit);			//check and see if there are any new choices
			
		if (newChoices.length > 0) {		//if there are new choices...
			newChoices.forEach(function(newChoice, pos) {			//copy them to the leftToVisit with the path to them
				var choiceClickPath = clickPath.slice(0);		//clone array
				choiceClickPath.push({source: uniqueNodeId, dest: newChoice.chunkId, clickNum: newChoice.choiceNum+1});
				newChoice.clickPath = choiceClickPath;
				if (!wasVisited(newChoice, leftToVisit)) {
					leftToVisit.push(newChoice);		//add it to leftToVisit
				}
			});
			
			var nextChoice = leftToVisit.pop();									//pop last item off array, which should be last choice currently available?
			var temp = nextChoice.clickPath[nextChoice.clickPath.length-1];
			clickPath.push({source: temp.source, dest: temp.dest, clickNum: temp.clickNum});			//add it to clickPath
			if (typeof child(temp.clickNum, getChoiceEl()) !== "undefined") {
				clickChoice(temp.clickNum);					//click the choice
				addToGraph(clickPath);
				stepStory(clickPath);			//repeat process
			}
			else if ($("#storyArea span.chunk").html() == "[No path found!]") {
				//if (leftToVisit.length > 0 && (iterStep < iterNum)) {
				if (leftToVisit.length > 0) {
					iterStep++;
					console.log("reached the end of this playthrough, backing up and restarting...");
					var nextNode = leftToVisit.shift();
					gotoChoice(nextNode.clickPath, story, levelData, globalData);
				}
				
			}

			else {
				console.log("Error! There was supposed to be a choice to pick but none is in the el!");
			}
		}
		
	};

	//checks if we have visited this node already
	var wasVisited = function(newChoice, leftToVisit) {
		for (var x=0; x < leftToVisit.length; x++) {
				var arrIdentifier = leftToVisit[x].chunkId + "_" + leftToVisit[x].clickPath.map(function(obj){return obj.clickNum}).join();
				var objIdentifier = newChoice.chunkId + "_" + newChoice.clickPath.map(function(obj){return obj.clickNum}).join();
			if (arrIdentifier == objIdentifier) {
				return true;
			}
		}
		return false;
	}

	/*
		resets game and clicks through until it makes the choice you've passed in
		bound to nodes so you can click to go to them
	*/
	var gotoChoice = function(clickPath, story, levelData, globalData) {
		resetStory();
		for (var x=0; x < clickPath.length; x++) {
			if (x==0) { addToGraph([]); }
			else { addToGraph(clickPath); }
			clickChoice(clickPath[x].clickNum);
		}
		addToGraph(clickPath);
		stepStory(clickPath);
	}

	//checks current choices and returns them if they aren't present in the graphData yet
	var checkForNewChoices = function(graphData) {

		var newChoices = [];

		function isNew(graphData, theChoice) {		//helper function
			var usedBefore = graphData.some(function(node) {
				return theChoice.chunkId === node.data.id;
			});
			if (usedBefore) {		//if it's been used before, check if the path is different
				
				var hasNewPath = true;
				for (var x=0; x < graphData.length; x++) {
					var val = graphData[x];
					if (JSON.stringify(val.data.clickPath) == JSON.stringify(theChoice.clickPath) && val.data.id == theChoice.chunkId) {
						hasNewPath = false;
					}
				}
				return hasNewPath;
			}

			else {
				return true;
			}
		}

		State.get("currentChoices").forEach(function(choice, pos) {
			if (isNew(graphData, choice) && !choice.cantChoose) {
				choice.choiceNum = pos;
				newChoices.push(choice);
			}
			else if (choice.persistent) {
				throw "Unimplemented code!";
			}
		});
		return newChoices
	}

	var createGraph = function() {

		var graphElements = simulateRunthroughs();
		console.log("GraphElements", graphElements.filter(function(value){return value.group=='nodes'}));

		var cyto = cytoscape({
			container : $("#cyto"),
			elements : graphElements,
			style: [ // the stylesheet for the graph
			    {
			      selector: 'node',
			      style: {
			        'background-color': '#666',
			        'label': 'data(textId)'
			      }
			    },

			    {
			      selector: 'edge',
			      style: {
			      	'label' : 'data(choiceText)',
			      	'edge-text-rotation': 'autorotate',
			        'width': 3,
			        'line-color': '#ccc',
			        'target-arrow-color': '#ccc',
			        'target-arrow-shape': 'triangle',
			        'curve-style': 'bezier'
			      }
			    }
			],
			/*layout : {
				name: 'cose',
				fit: true,
				nodeOverlap: 10,
				idealEdgeLength: function( edge ){ return 10; },
				useMultitasking: true,
				animate: true
			}*/
			layout : {
				name: 'breadthfirst',
				roots: '#' + graphRootId
				
				//name: 'cose'
			}
		});

		cyto.cxtmenu({			//walkthrough of options at https://github.com/cytoscape/cytoscape.js-cxtmenu
			selector: '*',

			commands: [
				{
					content: 'ID',
					select: function(ele){
						console.log( ele.id() );
					}
				},

				{
					content: 'Data',
					select: function(ele){
						console.log( ele.data() );
					}
				},

				{
					content: 'Position',
					select: function(ele){
						console.log( ele.position() );
					}
				}
			],
			fillColor: 'rgba(0, 92, 128,0.75)',
			activeFillColor: 'rgba(6, 173, 239,0.75)'
		});
	}
	
    var createEditor = function() {
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

		//hook up submit button to save file locally
		$('#submit').click(function() {                  

			var blob = new Blob([JSON.stringify(editor.getValue())], {type: "text/plain;charset=utf-8"});
	        saveAs(blob, "hello world.txt");
	    });

		// Hook up the Restore to Default button
		$('#restore').click(function() {
			editor.setValue(starting_value);
		});

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
    }

    $('body').append("<div id='cyto'></div><button id='submit'>Save JSON file</button><button id='restore'>Reset Changes</button><span id='valid_indicator'></span><div id='editor_holder'></div><div id='storyContainer' class='editor'></div>");

	createGraph();
	//createEditor();

});