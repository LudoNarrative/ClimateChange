define(["Game", "jsonEditor", "HealthBar", "text!avatars", "jQuery", "jQueryUI"], function(Game, JSONEditor, HealthBar, avatarsData) {

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
		_coordinator.cleanState(id);
		var bg = _coordinator.loadBackground(id);
		processWishlistSettings(_coordinator, id);
		initSceneScreen(State, bg, id);
		if (loadIntro) { _coordinator.loadSceneIntro(id); }
		_coordinator.loadAvatars(id);
		_coordinator.validateArtAssets(id);
		_coordinator.loadStoryMaterials(id);
		_coordinator.startGame(id);
	}

	var initTitleScreen = function(_Coordinator, _State, scenes, playGameScenes) {

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
	    			startScene(_Coordinator, playGameScenes[0], true);
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
//---------Functions for the timeline UI-----------------------------
	var initTimelineScreen = function(_Coordinator, _State, scenes, playGameScenes) {
		init(_Coordinator, _State);				//initialize our copy of the coordinator and state

		var theDiv = $('<div/>', {			//make container
		    id: 'timeline'
		}).appendTo('body');

		$('<div/>', {
		    id: 'blackout'
		    //text: ''
		}).appendTo('body');
		

		scenes.forEach(function(scene, pos) {			//make scene / knob containers


			$("#timeline").append("<div id='"+scene+"-panel' class='scenePanel'></div>");

			var date = $('<div/>', {
				id: 'date_' + scene,
				class: 'date',
				html: '<span>' + _Coordinator.getStorySpec(scene).year + '</span>'
			}).appendTo("#" + scene + '-panel');

			var theDiv = $('<div/>', {
			    id: 'scene_' + scene,
			    class: 'sceneWindows',
			    html: '<p>' + _Coordinator.loadTimelineDesc(scene) + '</p>'
			}).appendTo("#" + scene + '-panel');

			$("#scene_" + scene).click(function() {
				$('.sceneKnobs:visible').slideToggle("slow", function() {});
				$('#knobs_' + scene).slideToggle("slow", function() {});

				$('.sceneWindows.active').toggleClass('active', 500);
				$(this).toggleClass('active', 500);
			});

			var theKnobs = $('<div/>', {
			    id: 'knobs_' + scene,
			    class: 'sceneKnobs closed'
			}).appendTo("#" + scene + '-panel');

			populateKnobs(scene, _Coordinator, _State, scenes);
		});

		activateBegins(_Coordinator, _State, scenes);
	}

	//process the wishlist for the passed in story according to its current settings in the UI
	var processWishlistSettings = function(_Coordinator, id) {

		var knobList = [];
		var widgetNum = 0;
		var story = _Coordinator.getStorySpec(id);

		for (var x=0; x < story.wishlist.length; x++) {
			if (story.wishlist[x].condition.includes("[")) {
				State.set("dynamicWishlist", true);			//set flag that we have a dynamic wishlist
				if (story.wishlist[x].condition.includes("-")) {			//it's a slider
					var value = $("#" + story.id + "-slider-" + widgetNum).slider("option", "value");
					story.wishlist[x].condition = story.wishlist[x].condition.replace(/\[.*?\]/g, value);
					widgetNum++;
				}
				else if (story.wishlist[x].condition.includes("|")) {	//it's a dropdown
					var value = $("#" + story.id + "-select-" + widgetNum).val();
					story.wishlist[x].condition = story.wishlist[x].condition.replace(/\[.*?\]/g, value);
					widgetNum++;
				}
				else {									//it's a switch
					var value = $("#" + story.id + "-switch" + widgetNum).val();
					if (value == "on") {		//if it's on, remove brackets
						story.wishlist[x].condition = story.wishlist[x].condition.replace(/^\[(.+)\]$/,'$1');
					}
					else {			//otherwise, remove it
						story.wishlist.splice(x,1);
					}
					widgetNum++;
				}
				delete story.wishlist[x].label;
				delete story.wishlist[x].hoverText;
			}

		}

		State.set("processedWishlist", story.wishlist);
	}

	//activate begin links in timeline
	var activateBegins = function(_Coordinator, _State, scenes) {
		$(".beginScene").click(function(evnt) { 
			evnt.stopPropagation(); 
			var sceneId = $(this).attr( "id" ).split("-")[1];
			$( "#blackout" ).fadeIn( "slow", function() {
    			startScene(_Coordinator, sceneId, true);
			});
		});
	}

	//activate and add in knobs for coordinator stuff
	var populateKnobs = function(sceneId, _Coordinator, _State, scenes) {
		
		var sceneSpec = _Coordinator.getStorySpec(sceneId);
		var sliderX = [];
		for (var x=0; x < sceneSpec.wishlist.length; x++) {
			
			if (sceneSpec.wishlist[x].condition.includes("[")) {		//if the wishlist item has [] in it...
				var knobHtml = "";
				var regExp = /\[([^)]+)\]/;
				var knobString = regExp.exec(sceneSpec.wishlist[x].condition)[1];
				
				var theLabel;			//set up label stuff if they have it
				if (sceneSpec.wishlist[x].label != null) { theLabel = sceneSpec.wishlist[x].label; }
				else { theLabel = sceneSpec.wishlist[x].condition.replace(/ *\[[^)]*\] */g, ""); }

				var hoverTextClass = "";
				var hoverText;
				if (sceneSpec.wishlist[x].hoverText != null) { 		//set up hovertext stuff if they have it
					hoverTextClass = " class='tooltip'"; 
					hoverText = "<span class='tooltiptext'>"+sceneSpec.wishlist[x].hoverText + "</span>"; 
				}

				if (knobString.includes("-")) {			//range slider (e.g. "confidence eq [0-4]")
					var minValStart = knobString.indexOf("[") + 1;
					var minValEnd = knobString.indexOf("-");
					var minVal = knobString.substring(minValStart,minValEnd);		//get min value
					var maxValStart = knobString.indexOf("-") + 1;
					var maxValEnd = knobString.length;
					var maxVal = knobString.substring(maxValStart,maxValEnd);		//get max value
					knobHtml += '<label for="'+ sceneId +'-slider-' + x.toString() +'"'+ hoverTextClass +'>'+hoverText+theLabel+'</label><div id="'+ sceneId +'-slider-' + x.toString() +'"><div id="custom-handle-'+ sceneId + '_' + x.toString() +'" class="ui-slider-handle"></div></div>';
					$("#knobs_" + sceneId).append(knobHtml);
					sliderX.push({xVal:x, min: minVal, max: maxVal});
					$( function() {
						var data = sliderX.shift();
				    	var handle = $( "#custom-handle-"+ sceneId + "_" + data.xVal.toString() );
					    $( "#" + sceneId + "-slider-" + data.xVal.toString() ).slider({
					    	create: function() { 
					    		handle.text( $( this ).slider( "value" ) ); 
					    		$(this).slider('value', (data.max-data.min)/3);
					    	},
					      	slide: function( event, ui ) { handle.text( ui.value );	},
					      	stop: function(event, ui) {
					      		if (sceneSpec.wishlist[data.xVal].changeFunc !== null){
					      			runChangeFunc(this, sceneSpec.wishlist[data.xVal].changeFunc);
					      		}
					      	},
					      	min: parseFloat(data.min),
					      	max: parseFloat(data.max),
					      	step: 1
					    });
					});
					
				}
				else if (knobString.includes("|")) {		//dropdown w/ options (e.g. "career eq [shrimp|lobster]")
					var theLabel;
					if (sceneSpec.wishlist[x].label != null) { theLabel = sceneSpec.wishlist[x].label; }
					else { theLabel = sceneSpec.wishlist[x].condition.replace(/ *\[[^)]*\] */g, ""); }

					knobHtml += "<label for='"+ sceneId +"-select-"+x+"'"+ hoverTextClass +">"+hoverText+theLabel+"</label><select id='"+ sceneId +"-select-"+x+"' class='selectKnob'>";
					var theOptions = knobString.split("|");
					for (var y=0; y < theOptions.length; y++) {
						knobHtml += '<option value="'+ theOptions[y] +'">'+ theOptions[y] +'</option>';
					}
					knobHtml += "</select>";
					$("#knobs_" + sceneId).append(knobHtml);
					$("#knobs_" + sceneId).append("<br class='clearFloat'/>");
				}
				else {			//otherwise must be an on/off switch (e.g. "[introFriends eq true]")
					var theLabel;
					if (sceneSpec.wishlist[x].label != null) { theLabel = sceneSpec.wishlist[x].label; }
					else { theLabel = sceneSpec.wishlist[x].condition; }
					knobHtml += '<div class="switch-container">';
					knobHtml += '<label class="switch" for="'+ sceneId +'-switch'+ x +'"'+hoverTextClass+'>'+hoverText+'<input type="checkbox" id="'+ sceneId +'-switch'+x+'" checked="checked"><span class="slider round"></span></label>';
					knobHtml += '<span class="switch-label">'+ theLabel +'</span>';
					knobHtml += "</div>"
					$("#knobs_" + sceneId).append(knobHtml);
					$("#knobs_" + sceneId).append("<br class='clearFloat'/>");
				}				
				
			}
		}
	}

	var runChangeFunc = function(changingElement, functionName) {
		switch (functionName) {
			case "studentBalance":
				studentBalance(changingElement);
				break;
		}
	}

	//-------------KNOB TWIDDLING FUNCTIONS-------------------------------------------

	var studentBalance = function(changer) {
		var partnerSlider;
		if (changer.id == "finalLecture-slider-10") { partnerSlider = "#finalLecture-slider-11"}
		else { partnerSlider = "#finalLecture-slider-10"; }
		var currentValue = $("#" + changer.id).slider('value');
		$(partnerSlider).slider('value', (3-currentValue));
		console.log("setting to " + (3-currentValue+1));
	}
//------------------------------------------------------------------------------------
	//builds the scene divs
	var initSceneScreen = function(State, bg, id) {

		$('body').html('');
		$('body').css("background-image", "url('assets/bgs/"+ bg +"')"); 

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

			if (picClass == "supportingChar") {
				$('#charPic_' + char.id).html("<div class='nameLabel'>" + char.name + "</div>");
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

		return "assets/avatars/" + avatarSet.character + "/" + avatarSet.character + "_" + avatarSet.ages[ageIndex] + "_" + tag +".png"; 
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

		if (statsContainer.firstChild !== null && typeof statsContainer.firstChild.children[1].children[2] !== "undefined") {
			var statName1 = statsContainer.firstChild.children[1].firstChild.id;
			var statName2 = statsContainer.firstChild.children[1].children[2].id;

			if (statDivId == statName1 || statDivId == statName2) {		//if it's a big stat, increase appropriately
				newWidth *= 2;
			}
		}
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

		var nextIndex = Coordinator.getNextScene(State.get("currentScene"));
		$( "#blackout" ).delay(1600).fadeIn( "slow", function() {
	    	$("#sceneIntro").html(endText);

	    	$('<h3/>', {
	    		text : 'Stats',
	    	}).appendTo("#sceneIntro");
	    	var stats = State.get("storyUIvars");
	    	stats.forEach(function(stat, pos) {
	    		if ($.inArray("protagonist", stat.characters) !== -1) {
					$('<div/>', {
						id: stat.varName+'ContainerOutro',
				    	class: 'stat'
					}).appendTo("#sceneIntro");

					$('<span/>', {
				    	class: 'statLabel',
				    	text: "Ending " + stat.label + ": "
					}).appendTo('#'+stat.varName+'ContainerOutro');

					$('<span/>', {
				    	class: 'statValue',
				    	text: State.get(stat.varName).toFixed(1)
					}).appendTo('#'+stat.varName+'ContainerOutro');
				}
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
		initTimelineScreen : initTimelineScreen,
		setAvatars : setAvatars,
		createStats : createStats,
		setStats : setStats,
		setSceneIntro : setSceneIntro,
		setSceneOutro : setSceneOutro,
		startScene : startScene,
		addGameDiagnostics : addGameDiagnostics,
		processWishlistSettings : processWishlistSettings
	} 
});