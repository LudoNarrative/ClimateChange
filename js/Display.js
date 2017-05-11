define(["Game", "jsonEditor", "text!avatars", "jQuery", "jQueryUI"], function(Game, JSONEditor, avatarsData) {

	var State;
	var Coordinator;

	//initializes our copy of State and Coordinator
	var init = function(_Coordinator, _State) {
		State = _State;
		Coordinator = _Coordinator;
	}

	var makeLink = function(_coordinator, id, content, target) {
		
		var pTag = $('<p/>', {
		    class: 'titleLink',
		});

		$('<a/>', {
		    href: target,
		    text: content,
		    click: function() {
				$( "#blackout" ).fadeIn( "slow", function() {
	    			startScene(_coordinator,id);
  				});
			}
		}).appendTo(pTag);

		return pTag;
	}

	var startScene = function(_coordinator, id, loadIntro) {
		var bg = _coordinator.loadBackground(id);
		initSceneScreen(State, bg);
		if (loadIntro) { _coordinator.loadSceneIntro(id); }
		_coordinator.loadAvatars(id);
		_coordinator.validateArtAssets(id);
		_coordinator.loadStoryMaterials(id);
		_coordinator.startGame(id);
	}

	var initTitleScreen = function(_Coordinator, _State, scenes) {

		init(_Coordinator, _State);				//initialize our copy of the coordinator and state
		
		$('<h1/>', {
		    text: 'Climate Change Prototype',
		    id: 'title'
		}).appendTo('body');

		var begin = $('<h2/>', {
			text: 'Begin',
			id: 'begin',
			click: function() {
				$( "#blackout" ).fadeIn( "slow", function() {
	    			startScene(_Coordinator, scenes[0], true);
  				});
			}
		}).appendTo('body');

		$('<h2/>', {
		    text: 'Scene Selection',
		    id: 'sceneSelectTitle'
		}).appendTo('body');

		// For each scene, make a link to start it.
		scenes.forEach(function(scene, pos) {
			var el = makeLink(_Coordinator, scene, scene, "#");
			$('body').append(el);
		});

		$('<div/>', {
		    id: 'blackout'
		    //text: ''
		}).appendTo('body');
	}

	var initSceneScreen = function(State, bg) {

		$('body').html('');
		$('body').css("background-image", "url('/assets/bgs/"+ bg +"')"); 

		$('<div/>', {
		    id: 'storyContainer'
		    //text: ''
		}).appendTo('body');

		$('<div/>', {
		    id: 'gameContainer'
		    //text: ''
		}).appendTo('body');

		$('<div/>', {
		    id: 'statsContainer',
		    //text: ''
		}).appendTo('body');

		$('<div/>', {
		    id: 'sceneIntro'
		    //text: ''
		}).appendTo('body');

		$('<div/>', {
		    id: 'blackout'
		    //text: ''
		}).appendTo('body');

		initStatsUI(State);
	}

	var initStatsUI = function(State) {

		$('<div/>', {
		    id: 'storyStats'
		    //text: ''
		}).appendTo('#stats');

		$('<div/>', {
		    id: 'gameStats'
		    //text: ''
		}).appendTo('#stats');
	}

	/*
		Sets avatar on-screen based on state
	*/
	var setAvatars = function() {
		
		if (typeof State.get("characters") !== "undefined") {
			State.get("characters").forEach(function(char, pos) {
			var url = false;
			var defaultTag;
			var avatar = State.avatars.filter(function( avatar ) { return avatar.id == char.id; })[0];

			for (var x=0; x < avatar.states.length; x++) {			//check all avatar states to find true one
				var correctAvatar = false;
				if (avatar.states[x].state[0] == "default") {
					defaultTag = avatar.states[x].tag;
				}
				else {			//don't evaluate default avatars
					var allTrue = true;
					for (var y=0; y < avatar.states[x].state.length; y++) {
						if (!State.isTrue(avatar.states[x].state[y])) {
							allTrue = false;
							break;
						}
					}
					if (allTrue) {			//if it's valid...
						url = getAvatar(avatar.graphics, avatar.age, avatar.states[x].tag);		//get avatar URL
						break;
					}
				}
			}

			//fallback to default if no state valid
			if (!url) { 

				url = getAvatar(avatar.graphics, avatar.age, defaultTag); 
			}

			var picClass = "supportingChar";
			if (pos == 0) { picClass = "mainChar" }

			if (document.getElementById(char.id) == null){			//if div doesn't exist, create it
				$('<div/>', {
					id: char.id,
					class: 'statContainer'
				}).appendTo('#statsContainer');

				$('<div/>', {			//create avatarBox and stat-holding box for character
				    id: 'charPic_' + char.id,
				    class: picClass
				}).appendTo('#' + char.id);

				createStats();
			}
			
			if (url) { 		//set avatar
				//$('#charPic').css("background-image", "url(/assets/avatar/"+ theAvatar.src +")"); 
				$('#charPic_' + char.id).css("background-image", "url("+url+")"); 
			}
			});
		}	
	}

	//returns asset url for an avatar of a given tag, in a given set
	var getAvatar = function(set, age, tag) {
		var avatarsObj = HanSON.parse(avatarsData);
		avatarSet = avatarsObj.filter(function( avatar ) { return avatar.character == set; })[0];
		var ageIndex = false;
		for (var x=0; x < avatarSet.ages.length; x++) { if (avatarSet.ages[x] == age) { ageIndex = x; }}
		if (!ageIndex) { ageIndex = 0; }		//if no age provided, use first value

		return "/assets/avatars/" + avatarSet.character + "/" + avatarSet.character + "_" + avatarSet.ages[ageIndex] + "_" + tag +".png"; 
	}

	/*
	Called by story and game systems to change stat displayed, or add it
	containerId: which container to update...if set to "all" updates all containers
	*/

	var createStats = function() {
		var stats = State.get("storyUIvars");

		if (typeof stats !== "undefined") {

			State.get("characters").forEach(function(char, pos) {

				if (document.getElementById(char.id + "_barContainer") == null) {
					$('<div/>', {		//make progressbar divs
				    	class: 'barContainer',
				    	id: char.id + "_barContainer"
					}).appendTo("#"+char.id);
				}
			});

			

			stats.forEach(function(stat, pos) {
				/*
				"varName" : "confidence",
				"label" : "Confidence",
				"characters" : ["protagonist"],
				"affectedBy" : "both",
				"range" : [0,10]
				*/
				for (var x=0; x < stat.characters.length; x++) { //for each character...

					if (document.getElementById(stat.characters[x] + "_" + stat.varName) == null) {
						$('<div/>', {		//make progressbar divs
							id: stat.characters[x] + "_" + stat.varName,
					    	class: 'stat',
					    	html: "<div class='stat-label'>"+ stat.label + "</div>"
						}).appendTo("#"+stat.characters[x] + "_barContainer");
					}

					setBarWidth(stat.characters[x] + "_" + stat.varName);

				}
			});
		}
	};

	var setStats = function() {
		var stats = State.get("storyUIvars");

		stats.forEach(function(stat, pos) {
				/*
				"varName" : "confidence",
				"label" : "Confidence",
				"characters" : ["protagonist"],
				"affectedBy" : "both",
				"range" : [0,10]
				*/
				for (var x=0; x < stat.characters.length; x++) { //for each character...
					setBarWidth(stat.characters[x] + "_" + stat.varName);
				}
			});

	}

	//sets stat bar width
	var setBarWidth = function(statDivId) {
		var character = statDivId.split("_")[0];
		var statName = statDivId.split("_")[1];
		var stat = State.getBlackboard().storyUIvars.filter(function(thing,i){ 
			return thing.varName == statName;
		})[0];
		var newWidth = State.get(statName)/(stat.range[1] - stat.range[0]) * 100;
		$("#" + statDivId).css("width", newWidth + "%");
	}

	//sets the intro screen for each scene
	var setSceneIntro = function(sceneText) {
		$("#blackout").show();
		$("#sceneIntro").html(sceneText);
		var begin = $('<h2/>', {
			text: 'Begin',
			click: function() {
				$("#sceneIntro").fadeOut( "slow" );
				$("#blackout").fadeOut( "slow" );
			}
		}).appendTo("#sceneIntro");
		$("#sceneIntro").fadeIn( "slow" );
	}

	var setSceneOutro = function(endText) {

		var nextIndex = State.get("scenes").findIndex(function(scene) {
			return (scene == State.get("currentScene"));
		}) + 1;
		$( "#blackout" ).delay(1600).fadeIn( "slow", function() {
	    	$("#sceneIntro").html(endText);

	    	$('<h3/>', {
	    		text : 'Stats',
	    	}).appendTo("#sceneIntro");
	    	var stats = State.get("storyUIvars");
	    	stats.forEach(function(stat, pos) {
				$('<div/>', {
					id: stat+'ContainerOutro',
			    	class: 'stat'
				}).appendTo("#sceneIntro");

				$('<span/>', {
			    	class: 'statLabel',
			    	text: stat + ": "
				}).appendTo('#'+stat+'ContainerOutro');

				$('<span/>', {
			    	class: 'statValue',
			    	text: State.get(stat)
				}).appendTo('#'+stat+'ContainerOutro');
			});


	    	var begin = $('<h2/>', {
			text: 'Next',
			click: function() {
				startScene(Coordinator, State.get("scenes")[nextIndex], true);
			}
			}).appendTo("#sceneIntro");

	    	$( "#sceneIntro" ).fadeIn();
	    });
	}

	var addGameDiagnostics = function(gameSpec, aspFilepath, aspGame, initialPhaserFile) {
		
		$('<div/>', {
			id: "gameDiagnostics",
			html: '<ul><li><a href="#ASPEditor">ASP Editor</a></li><li><a href="#JSONEditorDiv">JSON Editor</a></li></ul><div id="ASPEditor"></div><div id="JSONEditorDiv"></div>'
		}).appendTo("body");

		addJSONEditor(gameSpec, initialPhaserFile);
		addASPEditor(gameSpec, aspFilepath, aspGame);

		$('<div/>', {
			id: "gameDiagnosticsButton",
			click: function() {
				$("#gameDiagnostics").toggle();
			}
		}).appendTo("body");

		$( "#gameDiagnostics" ).tabs();
	}

	//adds a JSON editor to the game diagnostics panel
	var addJSONEditor = function(gameSpec, initialPhaserFile) {

        var ruleSchemas = [
        	{
        		"properties": {
				    "l": {
				      "type": "array",
				      "format": "table",
				      "title": "Left",
				      "items": {
				        "type": "string"
				      }
				    },
				    "r": {
				      "type": "array",
				      "format": "table",
				      "title": "Right",
				      "items": {
				        "type": "string"
				      }
				    },
				    "relation": {
				      "type": "string",
				      "title": "Relation",
				      "enum": [
				        "is_a",
				      ],
				    }
				}
			}
		];

		var schema = {					// The schema for the editor
          type: "array",
          title: "Phaser Rules",
          items: {
            title: "Rule",
            headerTemplate: "Rule {{i}}",
            oneOf: ruleSchemas
          }
        };

		var options = {
    		//schema: schema,
    		mode: 'text',
    		modes: ['tree', 'text'],
    		theme: 'html'
  		};

  		var container = document.getElementById('JSONEditorDiv');
  		var editor = new JSONEditor(container, options);		//create editor (make it global so other buttons can pass it [hacky])

  		$('<div/>', {
			id: "JSONDumpDiv",
		})
		.appendTo("#JSONEditorDiv");
		$('<textarea/>', {			//add JSON dump field
			id: 'JSONDump',
			rows: "4",
			cols: "75",
			text: ""
		}).attr('spellcheck',false)
		.appendTo("#JSONDumpDiv");

		$('<div/>', {
			id: "closeDump",
			class: "diagButton",
			text: "Close",
			click: function() { $("#JSONDumpDiv").toggle(); }
		})
		.appendTo("#JSONDumpDiv");


  		$('<div/>', {
			id: "evaluateJSONButton",
			class: "diagButton",
			text: "Run new JSON",
			click: function() {
				Game.runGenerator(gameSpec, $("#ASPinput")[0].value.split("==========")[0], $("#ASPinput")[0].value.split("==========")[1], editor.get(), false);
			}
		})
		.appendTo("#JSONEditorDiv");

		$('<div/>', {
			id: "dumpJSONButton",
			class: "diagButton",
			text: "Dump JSON",
			click: function() {
				$("#JSONDump")[0].value = JSON.stringify(editor.get(), null, 2);
    			$("#JSONDumpDiv").toggle();
			}
		})
		.appendTo("#JSONEditorDiv");

		editor.set(initialPhaserFile);

	}

	//adds an ASP editor to the game diagnostics panel
	var addASPEditor = function(gameSpec, aspFilepath, aspGame) {

		$('<p/>', {					//add header
			text: "ASP code from: " + aspFilepath
		}).appendTo("#ASPEditor");

		$('<textarea/>', {			//add editing field
			id: 'ASPinput',
			rows: "4",
			cols: "75",
			text: aspGame
		}).attr('spellcheck',false)
		.appendTo("#ASPEditor");

		$('<div/>', {				//add evaluate ASP button
			id: "evaluateASPButton",
			class: "diagButton",
			text: "Run ASP",
			click: function() {
				Game.runGenerator(gameSpec, $("#ASPinput")[0].value.split("==========")[0], $("#ASPinput")[0].value.split("==========")[1], editor.get(), false);
			}
		})
		.appendTo("#ASPEditor");
	}

	return {
		init : init,
		initTitleScreen : initTitleScreen,
		setAvatars : setAvatars,
		createStats : createStats,
		setStats : setStats,
		setSceneIntro : setSceneIntro,
		setSceneOutro : setSceneOutro,
		startScene : startScene,
		addGameDiagnostics : addGameDiagnostics
	} 
});