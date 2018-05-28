define(["Game", "Templates", "jsonEditor", "HealthBar", "text!avatars", "jQuery", "jQueryUI"], function(Game, Templates, JSONEditor, HealthBar, avatarsData) {

	var State;
	var Coordinator;

	var gameModeChosen = "";				//holder for if game is chosen through UI knobs for scene
	var interfaceMode = "graph";			//how scenes progress...a timeline that's returned to ("timeline"), progress scene-to-scene ("normal"), or "graph"
	var avatarMode = "oneMain";				//oneMain means just one main character, otherwise "normal" RPG style

	//initializes our copy of State and Coordinator
	var init = function(_Coordinator, _State) {
		State = _State;
		Coordinator = _Coordinator;

		State.set("displayType", "notEditor");		//this is so we properly end scenes, etc. and don't do editor/viz stuff
	}

	var makeLink = function(_coordinator, id, content, target) {
		
		var pTag = $('<p/>', {
		    class: 'titleLink',
		});

		var linkId = id;
		if (id.indexOf(":") > -1) { linkId = id.split(":")[1]; }

		$('<a/>', {
		    href: target,
		    id: "startScene_" + linkId,
		    text: content,
		    click: function() {
				$( "#blackout" ).fadeIn( "slow", function() {
	    			startScene(_coordinator,id, true);
  				});
			}
		}).appendTo(pTag);

		return pTag;
	}

	var startScene = function(_coordinator, id, loadIntro) {

		if (id.substring(0,6) == "intro:") {		//if we're just using the intro as an interstitial scene, not actually running the game...
			initSceneScreen(State, bg, id);
			_coordinator.loadSceneIntro(id);
			State.set("currentScene", id);
		}
		else {
			_coordinator.cleanState(id);
			var bg = _coordinator.loadBackground(id);
			processWishlistSettings(_coordinator, id);
			initSceneScreen(State, bg, id);
			if (loadIntro) { _coordinator.loadSceneIntro(id); }
			_coordinator.loadAvatars(id);
			_coordinator.validateArtAssets(id);
			_coordinator.loadStoryMaterials(id);
		}
	}

	var startGraphScene = function(_coordinator, id, loadIntro) {

		$("#graphClickBlocker").hide();			//turn off click blocker

		if (id.substring(0,6) == "intro:") {		//if we're just using the intro as an interstitial scene, not actually running the game...
			initSceneScreen(State, bg, id);
			_coordinator.loadSceneIntro(id);
			State.set("currentScene", id);
		}
		else {
			_coordinator.cleanState(id);
			var bg = _coordinator.loadBackground(id);
			processWishlistShimmers(_coordinator, id);
			initSceneScreen(State, bg, id);
			if (loadIntro) { _coordinator.loadSceneIntro(id); }
			_coordinator.loadAvatars(id);
			_coordinator.validateArtAssets(id);
			_coordinator.loadStoryMaterials(id);
		}
	}

	var initTitleScreen = function(_Coordinator, _State, scenes, playGameScenes) {

		init(_Coordinator, _State);				//initialize our copy of the coordinator and state
		
		$('<h1/>', {
		    text: "Emma's Journey",
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

		if (localStorage.getItem("playerIdentifier") == null) { setPlayerIdentifier(); }
		
		$('body').append('<h2 id="trackingId">Identifier: <span style="color:yellow">' + localStorage.getItem("playerIdentifier") + "</span>");

		var regenerateLink = $('<h2/>', {
			html: '(click to regenerate)',
			id: 'regenerateLink',
			style: 'color:#43d9ff',
			click: function() {
				setPlayerIdentifier();
				$("#trackingId").html('Identifier: <span style="color: yellow">' + localStorage.getItem("playerIdentifier") + "</span>");
			}
		}).appendTo('body');

		$("body").append("<h2><a href='https://docs.google.com/forms/d/1ZF2XaZMxnn3f321c2LjIWYvXiqKzQCeby8ttOfb7_pg' target=_blank>Fill Out Survey</a></h2>");

		var offset = "0px;"
		if (gameVersion == "release") { offset = "300px"; }

		$('<h2/>', {
		    text: 'Scene Selection',
		    id: 'sceneSelectTitle',
		    style: 'margin-top:' + offset
		}).appendTo('body');

		// For each scene, make a link to start it.
		scenes.forEach(function(scene, pos) {
			var el = makeLink(_Coordinator, scene, scene, "#");
			$('body').append(el);
			$('body').append("<div id='hiddenKnobs'></div>");
			createKnobs(scene, "hiddenKnobs");
			populateKnobs(scene, _Coordinator, _State, scenes);
		});


		$('<div/>', {
		    id: 'blackout'
		    //text: ''
		}).appendTo('body');
	}

//================Functions for the graph UI=====================================
	
	var circleClicked = function(_Coordinator, timestep, level, theElement, playFirstClicked=false) {

	var content = {
		"0_low" : {
			"text" : "<h3>Dinner With Friends-Low</h3><p>You are Emma Richards, a PhD student who studies {shimmer|studyShimmer|phytoplankton}.</p><p>Tomorrow, you'll be defending your thesis. Your friends decided to throw a dinner party for you.</p><p><span class='mutable'>Were you able to field their questions, while still passing food around the table?</span></p>",
			"artAccentSrc" : "",
			"beginScene" : "finalDinner",
			"climateFacts" : [
				{
					"title" : "2020 Climate Fact",
					"text" : "Most of the native bird population in Europe has collapsed, due to falling insect populations brought on by inclement weather. The ripples in the food chain have affected most of the agricultural output for those countries."
				}
			]
		},
		"1_low" : {
			"text" : "<h3>First Lecture-Low</h3><p>You wonder how your first lecture will go. Will you be in front of hundreds of students? Or maybe a smaller class? What will you talk about? It's hard to say, since you're still wrapping up work on your dissertation. Hopefully once you have your PhD, things will solidify.</p>",
			"artAccentSrc" : "",
			"beginScene" : "finalLecture",
			"climateFacts" : [
			{
					"title" : "2025 Climate Fact",
					"text" : "Most of the native bird population in Europe has collapsed, due to falling insect populations brought on by inclement weather. The ripples in the food chain have affected most of the agricultural output for those countries."
				}
			]
		},
		"2_low" : {
			"text" : "<h3>A Meeting With the Dean-Low</h3><p>You've been having a somewhat rough time with your lectures. It looks like your superiors are starting to notice as Dean Smith has called you to come meet with him in private.</p><p>Choose what Emma says, but make sure to keep your cool or your job might be in jeoprardy!</p>",
			"artAccentSrc" : "",
			"beginScene" : "finalDean",
			"climateFacts" : [
			{
					"title" : "2025 Climate Fact",
					"text" : "Most of the native bird population in Europe has collapsed, due to falling insect populations brought on by inclement weather. The ripples in the food chain have affected most of the agricultural output for those countries."
				}
			]
		},
		"3_low" : {
			"text" : "<h3>Beach Scene-Low</h3><p>You took Mom's words to heart, and later on got involved with a local group helping with habitat remediation for crabs.</p><p>You managed to keep the Oxbow Marshes designated as a wildlife refuge, and pushed for tighter regulations of the local paper mill. Sometimes it feels hopeless, given global events, but you've kept working. One day you have a memorable conversation with your co-worker about this very thing.</p>",
			"artAccentSrc" : "",
			"beginScene" : "finalBeach",
			"climateFacts" : [{
					"title" : "2035 Climate Fact",
					"text" : "Most of the native bird population in Europe has collapsed, due to falling insect populations brought on by inclement weather. The ripples in the food chain have affected most of the agricultural output for those countries."
				}]
		},
		"4_low" : {
			"text" : "<h3>Epilogue-Low</h3>",
			"artAccentSrc" : "",
			"beginScene" : "intro:theEnd",
			"climateFacts" : [{
					"title" : "2045 Climate Fact",
					"text" : "Most of the native bird population in Europe has collapsed, due to falling insect populations brought on by inclement weather. The ripples in the food chain have affected most of the agricultural output for those countries."
				}]
		},
		"0_medium" : {
			"text" : "<h3>Dinner With Friends-Medium</h3><p>You are Emma Richards, a PhD student who studies <span class='mutable'>shrimp</span>.</p><p>Tomorrow, you'll be defending your thesis. Your friends decided to throw a dinner party for you.</p><p><span class='mutable'>Were you able to field their questions, while still passing food around the table?</span></p>",
			"artAccentSrc" : "",
			"beginScene" : "finalDinner",
			"climateFacts" : [
				{
					"title" : "2020 Climate Fact",
					"text" : "Most of the native bird population in Europe has collapsed, due to falling insect populations brought on by inclement weather. The ripples in the food chain have affected most of the agricultural output for those countries."
				}
			]
		},
		"1_medium" : {
			"text" : "<h3>First Lecture-Medium</h3><p>You wonder how your first lecture will go. Will you be in front of hundreds of students? Or maybe a smaller class? What will you talk about? It's hard to say, since you're still wrapping up work on your dissertation. Hopefully once you have your PhD, things will solidify.</p>",
			"artAccentSrc" : "",
			"beginScene" : "finalLecture",
			"climateFacts" : [{
					"title" : "2025 Climate Fact",
					"text" : "Most of the native bird population in Europe has collapsed, due to falling insect populations brought on by inclement weather. The ripples in the food chain have affected most of the agricultural output for those countries."
				}]
		},
		"2_medium" : {
			"text" : "<h3>A Meeting With the Dean-Medium</h3><p>You've been having a somewhat rough time with your lectures. It looks like your superiors are starting to notice as Dean Smith has called you to come meet with him in private.</p><p>Choose what Emma says, but make sure to keep your cool or your job might be in jeoprardy!</p>",
			"artAccentSrc" : "",
			"beginScene" : "finalDean",
			"climateFacts" : [
			{
					"title" : "2025 Climate Fact",
					"text" : "Most of the native bird population in Europe has collapsed, due to falling insect populations brought on by inclement weather. The ripples in the food chain have affected most of the agricultural output for those countries."
				}
			]
		},
		"3_medium" : {
			"text" : "<h3>Beach Scene-Medium</h3>",
			"artAccentSrc" : "",
			"beginScene" : "finalBeach",
			"climateFacts" : [{
					"title" : "2035 Climate Fact",
					"text" : "Most of the native bird population in Europe has collapsed, due to falling insect populations brought on by inclement weather. The ripples in the food chain have affected most of the agricultural output for those countries."
				}]
		},
		"4_medium" : {
			"text" : "<h3>Epilogue-Medium</h3>",
			"artAccentSrc" : "",
			"beginScene" : "intro:theEnd",
			"climateFacts" : [{
					"title" : "2045 Climate Fact",
					"text" : "Most of the native bird population in Europe has collapsed, due to falling insect populations brought on by inclement weather. The ripples in the food chain have affected most of the agricultural output for those countries."
				}]
		},
		"0_high" : {
			"text" : "<h3>Dinner With Friends-High</h3><p>You are Emma Richards, a PhD student who studies <span class='mutable'>shrimp</span>.</p><p>Tomorrow, you'll be defending your thesis. Your friends decided to throw a dinner party for you.</p><p><span class='mutable'>Were you able to field their questions, while still passing food around the table?</span></p>",
			"artAccentSrc" : "",
			"beginScene" : "finalDinner",
			"climateFacts" : [
				{
					"title" : "2020 Climate Fact",
					"text" : "Most of the native bird population in Europe has collapsed, due to falling insect populations brought on by inclement weather. The ripples in the food chain have affected most of the agricultural output for those countries."
				}
			]
		},
		"1_high" : {
			"text" : "<h3>First Lecture-Hot</h3><p>You wonder how your first lecture will go. Will you be in front of hundreds of students? Or maybe a smaller class? What will you talk about? It's hard to say, since you're still wrapping up work on your dissertation. Hopefully once you have your PhD, things will solidify.</p>",
			"artAccentSrc" : "",
			"beginScene" : "finalLecture",
			"climateFacts" : [{
					"title" : "2025 Climate Fact",
					"text" : "Most of the native bird population in Europe has collapsed, due to falling insect populations brought on by inclement weather. The ripples in the food chain have affected most of the agricultural output for those countries."
				}]
		},
		"2_high" : {
			"text" : "<h3>A Meeting With the Dean-High</h3><p>You've been having a somewhat rough time with your lectures. It looks like your superiors are starting to notice as Dean Smith has called you to come meet with him in private.</p><p>Choose what Emma says, but make sure to keep your cool or your job might be in jeoprardy!</p>",
			"artAccentSrc" : "",
			"beginScene" : "finalDean",
			"climateFacts" : [
			{
					"title" : "2025 Climate Fact",
					"text" : "Most of the native bird population in Europe has collapsed, due to falling insect populations brought on by inclement weather. The ripples in the food chain have affected most of the agricultural output for those countries."
				}
			]
		},
		"3_high": {
			"text" : "<h3>Beach Scene-High</h3>",
			"artAccentSrc" : "",
			"beginScene" : "finalBeach",
			"climateFacts" : [{
					"title" : "2035 Climate Fact",
					"text" : "Most of the native bird population in Europe has collapsed, due to falling insect populations brought on by inclement weather. The ripples in the food chain have affected most of the agricultural output for those countries."
				}]
		},
		"4_high": {
			"text" : "<h3>Epilogue-High</h3>",
			"artAccentSrc" : "",
			"beginScene" : "intro:theEnd",
			"climateFacts" : [{
					"title" : "2045 Climate Fact",
					"text" : "Most of the native bird population in Europe has collapsed, due to falling insect populations brought on by inclement weather. The ripples in the food chain have affected most of the agricultural output for those countries."
				}]
		},
		"timeline_high" : {
			"text" : "<h3>High Temperature Change</h3><p>This timeline is with a large amount of effects from climate change</p>",
			"beginScene" : "finalDinner",
			"artAccentSrc" : "",
			"climateFacts" : [{
				"title" : "High Temp Change Fact",
				"text" : "Climate has changed a lot. Temperature increase will displace a bunch of people."
			}]
		},
		"timeline_medium" : {
			"text" : "<h3>Medium Temperature Change</h3><p>This timeline is with a fair amount of effects from climate change</p>",
			"beginScene" : "finalDinner",
			"artAccentSrc" : "",
			"climateFacts" : [{
				"title" : "Medium Temp Change Fact",
				"text" : "Climate has changed a lot. Temperature increase will displace a bunch of people."
			}]
		},
		"timeline_low" : {
			"text" : "<h3>Low Temperature Change</h3><p>This timeline is with a low amount of effects from climate change</p>",
			"beginScene" : "finalDinner",
			"artAccentSrc" : "",
			"climateFacts" : [{
				"title" : "Low Temp Change Fact",
				"text" : "Climate has changed a lot. Temperature increase will displace a bunch of people."
			}]
		}
	};

	$("#playButton").unbind();			//if we clicked more than one thing, unbind all previous click assignments

	if (!playFirstClicked && State.get("introCompleted") !== true) {
		State.remove("sceneTimeline");
	}

	$("#playButton").click(function(evnt){
		evnt.stopPropagation();

		if (State.get("sceneTimeline") == null && State.get("introCompleted") !== true) {	//if it's the first time they've clicked the play button...
			switch(level) {
				case "low":
					State.set("sceneTimeline", "low");		//set low state variables
					State.set("sceneIndex", 0);
					timestep = "timeline";
					break;
				case "medium":
					State.set("sceneTimeline", "medium");	//set medium state variables
					State.set("sceneIndex", 0);
					timestep = "timeline";
					break;
				case "high":
					State.set("sceneTimeline", "high");		//set high state variables
					State.set("sceneIndex", 0);
					timestep = "timeline";
					break;
				default:
					console.error(level + " is not a valid level selection!");
			}

			State.set("UIsecondClick", "true");
			State.set("UIselectedLevel", content[timestep + "_" + level].beginScene);

			circleClicked(_Coordinator, 0, level, $("#playButton"), true);
		}
		
		else { 
			State.set("introCompleted", true);
			startGraphScene(_Coordinator, content[timestep + "_" + level].beginScene, true); 
		}

	});

	graphInterstitialAnimationNextScene(level + "_" + timestep);

	var animations = $.chain(function() {
		$("#climateFacts").fadeOut(1000);
	    return $("#mainText").fadeOut(1000);				//fadeout current text
	}, function() {
		
		var contentIndex;
		if (State.get("sceneTimeline") == null && State.get("introCompleted") !== true) { 	//if we haven't played a scene yet...
			contentIndex = "timeline_" + level; 
			}		
		else { contentIndex = timestep + "_" + level; }

		var mainTextAssets = Templates.interactiveRender(content[contentIndex].text);

		$("#mainTextContent").html(mainTextAssets.txt);
		attachClickEvents(mainTextAssets.textEvents);
		$("#climateFacts .title").html(content[contentIndex].climateFacts[0].title);
		$("#climateFacts .text").html(content[contentIndex].climateFacts[0].text);
		timelineFocus(level);
		$("#climateFacts .title").fadeIn(1000);
		$("#climateFacts .text").fadeIn(1000);
		$("#climateFacts").fadeIn(1000);
		return $("#mainText").fadeIn(1000);				//Fade in main text
	});

	$.when( animations ).done(function() {
	    // ALL ANIMATIONS HAVE BEEN DONE IN SEQUENCE
	});
	
	if ($("#artAccent").css("display") == "none") { $("#artAccent").fadeIn(1000);	}		//artAccent
	
	if ($("#climateFacts").css("display") == "none") { $("#climateFacts").fadeIn(1000);	}		//climateFacts
}

	//simple helper function that binds click events to template text
	var attachClickEvents = function(textEventsArray) {
		for (var x=0; x < textEventsArray.length; x++) {
			var textEvent = textEventsArray[x];
			$("#" + textEvent.elemId).bind("click", function() {
				textClickFuncs(textEvent.funcName, this.innerHTML, this.id);
			});
			textClickFuncs(textEvent.funcName, this.innerHTML, this.id);		//hacky: run it once to populate dynamic wishlist variables in localstorage
		}
	}

	//functions attached to shimmer text
	var textClickFuncs = function(functionName, oldVal, divId) {
	
		var funcs = {
			"studyShimmer" : function(oldVal) {
				var wishlist;
				var shimmerVals = ["phytoplankton", "coral", "lobsters"];

				var i = shimmerVals.indexOf(oldVal) + 1;
				if (i == shimmerVals.length) { i = 0; }

				setDynamicWishlistItem("state: set areaOfExpertise [phytoplankton|lobsters|coral]", shimmerVals[i]);
				
				return shimmerVals[i];
			}
		}

		$("#" + divId).html(funcs[functionName]($("#" + divId).html()));
	}

	//sets wishlist items from when knobs are twiddled
	var setDynamicWishlistItem = function(itemKey, itemValue) {
		var bbWishlist = parseBlackboardWishlist();
		if (bbWishlist[State.get("UIselectedLevel")] == undefined) {
			bbWishlist[State.get("UIselectedLevel")] = {};
		}
		bbWishlist[State.get("UIselectedLevel")][itemKey] = itemValue;
		State.set("wishlists", JSON.stringify(bbWishlist));
	}

	var parseBlackboardWishlist = function() {
		var bbWishlist = State.get("wishlists");
		if (bbWishlist !== undefined) { return JSON.parse(bbWishlist);	}
		else { return {}; }
	}
	
	//adjusts opacity on different timelines so one is in focus
	var timelineFocus = function(level) {
		var fadeLow = function() {
			$("#tempArea_low").fadeTo("slow", 0.3);
			$("#path_low_0").fadeTo("slow", 0.2);
			$("#path_low_1").fadeTo("slow", 0.2);
			$("#path_low_2").fadeTo("slow", 0.2);
			$("#path_low_3").fadeTo("slow", 0.2);
			$("#path_low_4").fadeTo("slow", 0.2);
			$("#low_3").fadeTo("slow", 0.4);
			$("#climateFacts").removeClass("lowFacts");
			$("#mainTextContent h3").removeClass("low");
		};
		var fadeMedium = function() {
			$("#tempArea_medium").fadeTo("slow", 0.3);
			$("#path_medium_0").fadeTo("slow", 0.2);
			$("#path_medium_1").fadeTo("slow", 0.2);
			$("#path_medium_2").fadeTo("slow", 0.2);
			$("#path_medium_3").fadeTo("slow", 0.2);
			$("#path_medium_4").fadeTo("slow", 0.2);
			$("#medium_3").fadeTo("slow", 0.4);
			$("#climateFacts").removeClass("mediumFacts");
			$("#mainTextContent h3").removeClass("medium");
		};
		var fadeHigh = function() {
			$("#tempArea_high").fadeTo("slow", 0.3);
			$("#path_high_0").fadeTo("slow", 0.2);
			$("#path_high_1").fadeTo("slow", 0.2);
			$("#path_high_2").fadeTo("slow", 0.2);
			$("#path_high_3").fadeTo("slow", 0.2);
			$("#path_high_4").fadeTo("slow", 0.2);
			$("#high_3").fadeTo("slow", 0.4);
			$("#climateFacts").removeClass("highFacts");
			$("#mainTextContent h3").removeClass("high");
		};
		switch (level) {
			case "high":
				$("#tempArea_high").fadeTo("slow", 0.6);
				$("#climateFacts").addClass("highFacts");
				$("#mainTextContent h3").addClass("high");
				$("#path_high_0").fadeTo("slow", 1);
				$("#path_high_1").fadeTo("slow", 1);
				$("#path_high_2").fadeTo("slow", 1);
				$("#path_high_3").fadeTo("slow", 1);
				$("#path_high_4").fadeTo("slow", 1);
				$("#high_3").fadeTo("slow", 1);
				fadeLow();
				fadeMedium();
				break;
			case "medium":
				$("#tempArea_medium").fadeTo("slow", 0.6);
				$("#climateFacts").addClass("mediumFacts");
				$("#mainTextContent h3").addClass("medium");
				$("#path_medium_0").fadeTo("slow", 1);
				$("#path_medium_1").fadeTo("slow", 1);
				$("#path_medium_2").fadeTo("slow", 1);
				$("#path_medium_3").fadeTo("slow", 1);
				$("#path_medium_4").fadeTo("slow", 1);
				$("#medium_3").fadeTo("slow", 1);
				fadeHigh();
				fadeLow();
				break;
			case "low":
				$("#tempArea_low").fadeTo("slow", 0.6);
				$("#climateFacts").addClass("lowFacts");
				$("#mainTextContent h3").addClass("low");
				$("#path_low_0").fadeTo("slow", 1);
				$("#path_low_1").fadeTo("slow", 1);
				$("#path_low_2").fadeTo("slow", 1);
				$("#path_low_3").fadeTo("slow", 1);
				$("#path_low_4").fadeTo("slow", 1);
				$("#low_3").fadeTo("slow", 1);
				fadeHigh();
				fadeMedium();
				break;
		}

	}

	//trigger animation on graph and prepare play button for next scene
	var graphInterstitialAnimationNextScene = function(buttonId) {
		if (!State.get("introCompleted")) {
			$("#low_0").hide();
			$("#medium_0").hide();
			$("#high_0").hide();
		}
		
		$("#" + buttonId).show();
		
	}

	var initGraphScreen = function(_Coordinator, _State, scenes) {
		init(_Coordinator, _State);				//initialize our copy of the coordinator and state
		$("body").append('<div id="graphClickBlocker"></div><div id="graphContainer"><div id="graphWiper"></div><div id="graphLinesContainer"></div><div id="graphValuesContainer"></div><div id="mainText"> <div id="mainTextContent"> </div> <div id="playButton"></div> </div> <div id="climateFacts"> <div class="title"></div> <div class="text"></div>  <div id="artAccent"></div> </div></div><div id="graphBlackout"></div> <div id="centerText"></div>');
		
		$("#graphLinesContainer").append('<svg version="1.1" id="Layer_1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px"	 width="1024px" height="768px" viewBox="0 0 1024 768" enable-background="new 0 0 1024 768" xml:space="preserve"><line opacity="0.25" fill="#999999" stroke="#E6E6E6" stroke-width="2" stroke-miterlimit="10" x1="86" y1="454" x2="1024" y2="454"/><line opacity="0.25" fill="#999999" stroke="#E6E6E6" stroke-width="2" stroke-miterlimit="10" x1="86" y1="379" x2="1024" y2="379"/><line fill="#999999" opacity="0.25" stroke="#E6E6E6" stroke-width="2" stroke-miterlimit="10" x1="86" y1="305" x2="1024" y2="305"/><line fill="#999999" opacity="0.25" stroke="#E6E6E6" stroke-width="2" stroke-miterlimit="10" x1="86" y1="229" x2="1024" y2="229"/><line fill="#999999" opacity="0.25" stroke="#E6E6E6" stroke-width="2" stroke-miterlimit="10" x1="86" y1="155" x2="1024" y2="155"/><line fill="#999999" opacity="0.25" stroke="#E6E6E6" stroke-width="2" stroke-miterlimit="10" x1="86" y1="80" x2="1024" y2="80"/><line fill="#999999" opacity="0.25" stroke="#E6E6E6" stroke-width="2" stroke-miterlimit="10" x1="85" y1="530" x2="1023" y2="530"/><line fill="#999999" opacity="0.25" stroke="#E6E6E6" stroke-width="2" stroke-miterlimit="10" x1="85" y1="607" x2="1023" y2="607"/><line fill="#999999" stroke="#000000" stroke-width="3" stroke-miterlimit="10" x1="85" y1="691.5" x2="1023" y2="691.5"/><line fill="#999999" stroke="#000000" stroke-width="3" stroke-miterlimit="10" x1="85.5" y1="0" x2="85.5" y2="768"/><line fill="none" stroke="#000000" stroke-width="2" stroke-miterlimit="10" x1="162" y1="693" x2="162" y2="722"/><line fill="none" stroke="#000000" stroke-width="2" stroke-miterlimit="10" x1="238" y1="693" x2="238" y2="722"/><line fill="#999999" stroke="#808080" stroke-width="2" stroke-miterlimit="10" x1="502" y1="0" x2="502" y2="768"/><line fill="none" stroke="#000000" stroke-width="2" stroke-miterlimit="10" x1="314" y1="693" x2="314" y2="722"/><line fill="none" stroke="#000000" stroke-width="2" stroke-miterlimit="10" x1="390" y1="693" x2="390" y2="722"/><line fill="none" stroke="#000000" stroke-width="4" stroke-miterlimit="10" x1="462" y1="693" x2="462" y2="725"/><line fill="none" stroke="#000000" stroke-width="2" stroke-miterlimit="10" x1="539" y1="693" x2="539" y2="722"/><line fill="none" stroke="#000000" stroke-width="2" stroke-miterlimit="10" x1="615" y1="693" x2="615" y2="722"/><line fill="none" stroke="#000000" stroke-width="2" stroke-miterlimit="10" x1="691" y1="693" x2="691" y2="722"/><line fill="none" stroke="#000000" stroke-width="2" stroke-miterlimit="10" x1="768" y1="693" x2="768" y2="722"/><line fill="none" stroke="#000000" stroke-width="4" stroke-miterlimit="10" x1="843" y1="693" x2="843" y2="725"/><line fill="none" stroke="#000000" stroke-width="2" stroke-miterlimit="10" x1="920" y1="693" x2="920" y2="722"/><line fill="none" stroke="#000000" stroke-width="2" stroke-miterlimit="10" x1="996" y1="693" x2="996" y2="722"/><rect x="418" y="734" fill="none" width="68" height="27"/><text transform="matrix(1 0 0 1 437.0586 749.752)" font-family="Arial-BoldMT" font-size="22">2000</text><rect x="800" y="734" fill="none" width="68" height="27"/><text transform="matrix(1 0 0 1 819.0586 749.752)" font-family="Arial-BoldMT" font-size="22">2050</text><rect x="717" y="736" fill="none" width="68" height="27"/><text transform="matrix(1 0 0 1 749.4062 747.4561)" font-family="Arial-BoldMT" font-size="16">2040</text><rect x="870" y="736" fill="none" width="68" height="27"/><text transform="matrix(1 0 0 1 902.4062 747.4561)" font-family="Arial-BoldMT" font-size="16">2060</text><rect x="947" y="736" fill="none" width="68" height="27"/><text transform="matrix(1 0 0 1 979.4062 747.4561)" font-family="Arial-BoldMT" font-size="16">2070</text><rect x="641" y="736" fill="none" width="68" height="27"/><text transform="matrix(1 0 0 1 673.4062 747.4561)" font-family="Arial-BoldMT" font-size="16">2030</text><rect x="565.065" y="736" fill="none" width="68" height="27"/><text transform="matrix(1 0 0 1 597.4717 747.4561)" font-family="Arial-BoldMT" font-size="16">2020</text><rect x="489" y="736" fill="none" width="68" height="27"/><text transform="matrix(1 0 0 1 521.4062 747.4561)" font-family="Arial-BoldMT" font-size="16">2010</text><rect x="337.52" y="736" fill="none" width="68" height="27"/><text transform="matrix(1 0 0 1 369.9258 747.4561)" font-family="Arial-BoldMT" font-size="16">1990</text><rect x="261.52" y="736" fill="none" width="68" height="27"/><text transform="matrix(1 0 0 1 293.9258 747.4561)" font-family="Arial-BoldMT" font-size="16">1980</text><rect x="185.585" y="736" fill="none" width="68" height="27"/><text transform="matrix(1 0 0 1 217.9912 747.4561)" font-family="Arial-BoldMT" font-size="16">1970</text><rect x="109.52" y="736" fill="none" width="68" height="27"/><text transform="matrix(1 0 0 1 141.9258 747.4561)" font-family="Arial-BoldMT" font-size="16">1960</text><rect x="18.116" y="157.058" fill="none" width="21.404" height="446.385"/><text transform="matrix(0 -1 1 0 29.5723 447.7383)" font-family="Arial-BoldMT" font-size="16">TEMPERATURE CHANGE IN CELCIUS</text><rect x="23.116" y="521" fill="none" width="53.997" height="47.997"/><text transform="matrix(1 0 0 1 43.75 538.1836)" font-family="Arial-BoldMT" font-size="24">0.0</text><rect x="23.116" y="447" fill="none" width="53.997" height="47.997"/><text transform="matrix(1 0 0 1 43.75 464.1836)" font-family="Arial-BoldMT" font-size="24">0.5</text><rect x="23.116" y="368.501" fill="none" width="53.997" height="47.997"/><text transform="matrix(1 0 0 1 43.75 385.6855)" font-family="Arial-BoldMT" font-size="24">1.0</text><rect x="23.116" y="294.501" fill="none" width="53.997" height="47.997"/><text transform="matrix(1 0 0 1 43.75 311.6851)" font-family="Arial-BoldMT" font-size="24">1.5</text><rect x="23.116" y="221.253" fill="none" width="53.997" height="47.997"/><text transform="matrix(1 0 0 1 43.75 238.4365)" font-family="Arial-BoldMT" font-size="24">2.0</text><rect x="23.116" y="142.754" fill="none" width="53.997" height="47.997"/><text transform="matrix(1 0 0 1 43.75 159.9385)" font-family="Arial-BoldMT" font-size="24">2.5</text><rect x="23.116" y="68.754" fill="none" width="53.997" height="47.997"/><text transform="matrix(1 0 0 1 43.75 85.9385)" font-family="Arial-BoldMT" font-size="24">3.0</text></svg>');

		$("#graphValuesContainer").append('<svg version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" width="1024px" height="768px" viewBox="0 0 1024 768" enable-background="new 0 0 1024 768" xml:space="preserve"><defs><radialGradient id="blueGradient"><stop offset="10%" stop-color="#00a8e4"/><stop offset="95%" stop-color="#00a8e4"/></radialGradient><linearGradient id="pastGradient" x1="0%" y1="0%" x2="0%" y2="100%"><stop offset="0%" style="stop-color:#a58c3b;stop-opacity:1" /><stop offset="100%" style="stop-color:#4a4227;stop-opacity:1" /></linearGradient></defs><g id="past"><path fill="url(#pastGradient)" d="M85,539.714v99.105c0,0,7.548,8.749,14.926,0c7.379-8.745,15.188-8.745,22.566-6.8c7.378,1.943,14.049,1.943,22.35,0c8.302-1.945,11.176-1.942,15.788-3.887c4.611-1.942,7.431-7.776,13.888-3.888c6.457,3.888,5.562,5.827,10.173,18.464c4.612,12.63,2.779,22.347,11.08,18.46c8.301-3.886,10.153-15.547,14.764-19.433c4.611-3.887,7.382-5.831,11.993-3.887c4.612,1.947,2.77,1.947,11.992-3.887c9.223-5.83,11.069-5.83,19.37-11.657c8.3-5.83,3.69-19.489,12.913-11.687c9.223,7.799,7.378,17.514,15.679,11.687c8.301-5.83,11.069-21.482,17.524-21.431c6.456,0.051,11.068,11.609,14.757,0c3.689-11.606,5.533-23.264,9.223-13.548c3.689,9.714,4.611,19.376,10.146,23.292c5.534,3.914,8.356-1.237,14.756-10.664c5.89-8.673,10.146-16.519,15.681-20.401c5.534-3.888,11.068-11.657,15.679-15.546c4.611-3.89,7.071,0.109,11.989,0c4.919-0.113,5.535,15.546,7.379,27.204c1.844,11.659,7.378,23.215,12.912,9.663c5.534-13.548,4.613-25.209,9.224-27.153c4.611-1.943,11.067-19.462,15.679-25.278c4.612-5.814,4.611-5.006,13.835-9.859C460.486,533.732,469.71,519,469.71,519s6.456,0,14.756,0c8.302,0,18.534-3,18.534-3v-65c0,0-7.422,10.012-15.724,15.841c-8.3,5.828-18.928,21.377-22.618,19.435c-3.689-1.947-8.08,9.716-15.458,9.716c-7.379,0-12.804,1.944-17.416,9.716c-4.61,7.771-11.012,13.601-16.546,21.377c-5.534,7.772-10.819,17.166-14.729,5.831c-11.059-32.065-13.822-27.208-13.822-27.208s-5.986,0-10.138,13.601c-2.494,8.174-11.986,13.609-17.521,15.549c-5.534,1.942-14.755,9.687-18.444,13.587c-3.689,3.904-6.455-5.814-11.989-11.645c-5.534-5.828-17.522-15.544-27.668-3.884c-10.146,11.655-3.689,13.604-10.146,11.655c-6.456-1.941-10.146-9.747-13.834,3.873c-3.689,13.621-16.602-3.9-23.058,0c-6.456,3.904-12.912-0.087-20.291,8.709c-7.378,8.797-19.368,8.797-23.979,8.797c-4.612,0-17.524,3.885-21.213,5.829c-3.689,1.943-0.922-11.762-7.378-14.626c-6.457-2.863-13.835-20.35-17.524-22.296c-3.688-1.941-2.767,11.63-6.456,13.587c-3.689,1.96-15.679,7.761-19.368,0c-3.688-7.753-5.535-0.015-10.146,0c-4.611,0.015-20.229,3.874-25.763,0C96.236,544.57,85,539.714,85,539.714z"/><g><path fill="none" stroke="#d4af5e" stroke-width="3" stroke-miterlimit="10" d="M87,590.5c0,0,33.616,0,51.601,0c17.985,0,28.668-25.508,40.121-1.342c5.069,10.691,5.533,25.318,17.018,19.928c14.916-7,17.569-15.141,28.637-14.395c11.067,0.74,11.067,13.661,23.519-0.168c12.451-13.834,23.519-7.111,33.204-16.344c9.684-9.231,15.218-9.271,26.286-15.105c11.068-5.83,11.068-20.423,19.368-0.022c8.301,20.407,9.685,11.648,22.136,2.905c12.451-8.744,17.985-0.612,24.902-13.426c6.917-12.812,10.862-19.614,15.218-18.646c14.166,3.148,8.358,37.197,16.659,33.414c8.3-3.782,11.011-10.096,19.312-24.67c8.301-14.573,12.451-20.402,24.902-29.15c12.451-8.744,33.459-24.892,52.365-24.892"/></g></g><g id="simpleAreas"><path class="tempArea" id="tempArea_low" opacity="0.4" fill="#006bb3" d="M500,459.588c0,0,243.033-214.49,718.51-185.991c0,83.995-0.022,223.489-0.022,223.489S704,417.59,500,516.585C500,489.586,500,459.588,500,459.588z"/><path opacity="0.4" class="tempArea" id="tempArea_high" fill="#E52000" d="M500,454.088c0,0,0,31.496,0,62.901c78.087,15.093,719-419.886,719-419.886s0-286.486,0-385.479C707,418.088,500,454.088,500,454.088z"/><path class="tempArea" id="tempArea_medium" opacity="0.4" fill="#FF8500" d="M503,451c0,0,214-132.5,718.497-419.393c0,74.938-3.796,199.72-3.796,199.72S821.075,438.087,502.452,518"/><path class="tempPath" id="path_high_4" fill="none" stroke="#ED1C24" stroke-width="3" stroke-miterlimit="10" d="M837.531,267.518c2.967-5.921,5.28-9.873,8.481-10.551c4.61-0.973,11.066-6.8,14.756-16.518c3.689-9.716,10.146-5.829,15.681-11.661c5.533-5.828,12.912-13.603,18.445-19.432c5.534-5.829,12.912-15.545,20.291-17.49c7.379-1.941,15.166-6.4,20.7-16.117c5.534-9.715,19.321-18.421,24.856-24.25c5.533-5.828,13.506-13.67,24.573-19.5c11.068-5.828,12.179-14.84,19.334-23.692c5.623-6.958,19.194-16.669,24.729-20.558c5.532-3.89,12.825-16.364,18.36-20.25c5.534-3.887,12.035-11.863,20.336-15.75c8.301-3.885,14.803-9.976,20.337-17.75c5.534-7.773,12.319-13.42,20.619-19.25c8.302-5.83,11.83-13.32,19.209-23.039c7.378-9.717,15.678-15.545,23.056-21.375c7.38-5.831,5.534-9.717,11.991-17.49c6.456-7.772,11.989-21.376,21.213-21.376s12.913-11.658,17.525-15.546c4.609-3.886,15.677-9.715,15.677-9.715"/><path class="tempPath" id="path_high_3"  fill="none" stroke="#ED1C24" stroke-width="3" stroke-miterlimit="10" d="M714.859,361.788c3.025-3.796,5.833-7.031,8.485-8.627c6.456-3.892,14.757-3.886,21.214-11.661c6.455-7.771,17.525-11.659,26.748-19.435c9.221-7.772,16.6-13.603,19.367-19.433c2.767-5.828,6.455,7.771,12.912,0c6.457-7.771,9.223-27.185,15.68-26.224c6.456,0.964,8.3,10.631,13.834-0.033c1.691-3.26,3.125-6.25,4.432-8.858"/><path class="tempPath" id="path_high_2"  fill="none" stroke="#ED1C24" stroke-width="3" stroke-miterlimit="10" d="M688.947,378.332c2.647,1.692,5.085,5.359,11.34,0.089c5.436-4.58,10.229-11.185,14.572-16.633"/><path class="tempPath" id="path_high_1"  fill="none" stroke="#ED1C24" stroke-width="3" stroke-miterlimit="10" d="M663.313,392.553c0.965-0.98,1.906-1.812,2.849-2.474c5.534-3.884,12.912-7.772,18.446-11.658c1.78-1.251,3.083-0.893,4.339-0.089"/><path class="tempPath" id="path_high_0" fill="none" stroke="#ED1C24" stroke-width="3" stroke-miterlimit="10" d="M502.452,488.703c0,0,5.995-2.711,13.374-4.997c7.38-2.288,13.835-0.346,17.524-8.121c3.689-7.771,7.378-7.771,13.835-7.771c6.456,0,15.679-17.487,21.213-18.46s13.832-10.69,21.212-10.69s11.068,9.718,19.368,0c8.302-9.715,11.069-23.319,18.448-23.319c7.378,0,7.377,11.661,17.523,0c8.419-9.676,13.662-18.013,18.364-22.791"/><path class="tempPath" id="path_low_0" fill="none" stroke="#0071BC" stroke-width="3" stroke-miterlimit="10" d="M660.013,423.607c-4.016-0.79-7.952-4.998-14.372-0.491c-8.302,5.832-15.218,4.374-19.369,11.66c-4.15,7.29-3.459-1.457-11.067,0c-7.609,1.457-11.761,4.374-16.602,8.746c-4.843,4.374-5.534,0-13.144,0c-7.608,0-15.909,2.918-19.368,10.203c-3.458,7.286-11.067,4.37-15.909,8.742c-4.844,4.373-8.302,1.459-12.451,8.746c-4.151,7.288-10.377,11.66-16.602,11.66c-6.227,0-6.918-5.831-11.76,0c-4.842,5.829-7.124,5.713-7.124,5.713"/><path class="tempPath" id="path_low_1" fill="none" stroke="#0071BC" stroke-width="3" stroke-miterlimit="10" d="M688.268,409.876c-4.814-1.457-10.657-2.68-13.266,1.583c-4.46,7.286-5.844,8.745-11.377,11.657c-1.254,0.661-2.437,0.723-3.612,0.491"/><path class="tempPath" id="path_low_2" fill="none" stroke="#0071BC" stroke-width="3" stroke-miterlimit="10" d="M714.072,407.722c-8.487,1.548-17.42,2.89-18.627,3.737c-0.861,0.604-3.761-0.549-7.178-1.583"/><path class="tempPath" id="path_low_3" fill="none" stroke="#0071BC" stroke-width="3" stroke-miterlimit="10" d="M826.301,376.821c-5.007-0.971-9.535-0.437-13.262,4.187c-6.917,8.588-13.835-2.759-23.519,0c-9.686,2.758-18.677,1.652-23.519,7.306c-4.843,5.654-17.985-4.194-23.52,0c-5.534,4.199-7.609,12.942-13.834,15.858c-2.604,1.219-8.475,2.438-14.576,3.55"/><path class="tempPath" id="path_low_4" fill="none" stroke="#0071BC" stroke-width="3" stroke-miterlimit="10" d="M1217.701,385.226c0,0-8.3,2.913-12.451,0c-4.149-2.917-7.608,2.913-15.909,0c-8.3-2.917-15.218,2.687-19.368-0.843c-4.151-3.532-12.451,2.009-16.603-0.032c-4.148-2.042-7.607,1.148-13.142-1.175c-5.534-2.325-11.067-3.509-18.678,0c-7.608,3.507-5.533,7.553-13.834,3.343s-16.603-9.812-22.826-5.554c-6.227,4.261-12.451,4.487-20.753,2.914c-8.3-1.57-15.91-7.299-22.828-4.434c-6.917,2.863-16.6,8.136-25.593,4.044c-8.992-4.097-21.443-8.486-25.594-4.833c-4.151,3.652-17.986-3.465-22.137-1.363c-4.15,2.1-4.842-8.722-12.45-0.396c-7.608,8.329-9.684-3.061-17.985-3.196c-8.301-0.136-20.061,4.549-24.902,7.308c-4.843,2.758-11.758,4.529-15.909,0c-4.15-4.528-8.993-4.216-16.602,0c-7.61,4.218-15.219-2.759-20.062,0c-4.842,2.758-9.684,3.074-20.061,0c-4.787-1.417-9.427-3.355-13.715-4.187"/><path class="tempPath" id="path_medium_0" fill="none" stroke="#F7931E" stroke-width="3" stroke-miterlimit="10" d="M662.443,403.672c-0.879,0.663-1.655,1.366-2.277,2.09c-3.229,3.755-10.605,6.669-14.295,7.642c-3.689,0.971-5.071,5.415-10.145,8.053c-5.073,2.636-11.53,3.607-15.681,9.436s-6.917,7.772-11.529,7.772c-4.61,0-14.755,0.977-15.679,5.832c-0.922,4.857-2.305,7.771-6.455,10.688c-4.15,2.912-17.524,2.912-20.753,5.828c-3.229,2.915-10.606,3.886-14.295,9.717c-3.69,5.831-8.763,7.773-13.374,7.773s-10.607,0-14.297,5.826c-3.688,5.834-7.377,9.719-12.451,8.748c-5.071-0.971-8.968-4.489-8.968-4.489"/><path class="tempPath" id="path_medium_1" fill="none" stroke="#F7931E" stroke-width="3" stroke-miterlimit="10" d="M688.637,390.05c-0.354,0.306-0.628,0.64-0.801,1.004c-1.384,2.914-8.605,7.773-12.834,7.773c-3.413,0-8.88,2.071-12.559,4.845"/><path class="tempPath" id="path_medium_2" fill="none" stroke="#F7931E" stroke-width="3" stroke-miterlimit="10" d="M715.911,383.36c-2.398,1.49-4.837,3.622-6.86,5.753c-3.69,3.884-5.535-1.945-8.764-1.945c-2.824,0-9.179,0.743-11.65,2.882"/><path class="tempPath" id="path_medium_3" fill="none" stroke="#F7931E" stroke-width="3" stroke-miterlimit="10" d="M828.506,323.659c-1.918,0.655-3.683,2.476-5.09,6.182c-5.534,14.573-17.985,23.32-24.903,23.32c-6.917,0-12.451,2.914-17.063,0c-4.609-2.914-15.677-4.214-19.366,1.296c-3.69,5.505-13.834,6.476-17.063,9.395c-3.229,2.913-9.224,2.913-11.99,5.828c-2.767,2.914-7.839,11.66-11.528,11.66c-1.666,0-3.614,0.793-5.59,2.021"/><path class="tempPath" id="path_medium_4" fill="none" stroke="#F7931E" stroke-width="3" stroke-miterlimit="10" d="M1217.701,146.201c0,0-13.833-11.659-24.901,0c-11.068,11.661-23.52,17.491-30.437,17.491c-6.918,0-13.833-11.661-20.751,0c-6.918,11.658-29.054,20.404-29.054,20.404s-11.067,9.228-16.602,13.358c-5.534,4.131-22.134,9.961-27.668,12.875c-5.535,2.915-16.603,11.66-27.67,17.489c-11.068,5.83-24.902,14.575-29.053,14.575s-9.685,14.573-16.602,17.489c-6.918,2.914-19.369-14.574-27.67,0c-8.3,14.573-17.984,12.651-23.518,19.441c-5.535,6.793-17.986,15.537-24.904,18.452c-6.916,2.914-16.602-11.659-24.9,0c-8.302,11.66-16.603,11.66-24.902,17.491c-8.302,5.828-20.753,14.573-24.904,14.573c-3.095,0-10.037-8.104-15.66-6.182"/></g><g id="first_pass_buttons"><circle fill="#ED0A0A" cx="830.75" cy="271.25" r="11.75" class="high" id="high_3"/><circle fill="#ED0A0A" cx="714.75" cy="362.25" r="11.75" class="high" id="high_2"/><circle fill="#ED0A0A" cx="688.75" cy="381.25" r="11.75" class="high" id="high_1"/><circle fill="#ED0A0A" cx="662.75" cy="393.25" r="11.75" class="high" id="high_0"/><circle fill="#FFB600" cx="830.75" cy="331.25" r="11.75" class="medium" id="medium_3"/><circle fill="#FFB600" cx="714.75" cy="382.25" r="11.75" class="medium" id="medium_2"/><circle fill="#FFB600" cx="688.75" cy="393.25" r="11.75" class="medium" id="medium_1"/><circle fill="#FFB600" cx="662.75" cy="405.25" r="11.75" class="medium" id="medium_0"/><circle fill="url(#blueGradient)" cx="829.75" cy="378.25" r="11.75" class="low" id="low_3"/><circle fill="url(#blueGradient)" cx="714.75" cy="410.25" r="11.75" class="low" id="low_2"/><circle fill="url(#blueGradient)" cx="688.75" cy="410.25" r="11.75" class="low" id="low_1"/><circle fill="url(#blueGradient)" cx="663.75" cy="423.25" r="11.75" class="low" id="low_0"/></g><g id="sandbox"><polygon opacity="0.26" fill="#ffffff" points="647,436 686,663.036 862.255,484.166 736,348.324 736,435 728.667,442 653.334,442 "/><path opacity="0.3" fill-opacity:"#333333" stroke="#000000" stroke-width="2" stroke-miterlimit="10" d="M736,432c0,5.522-4.478,10-10,10h-69c-5.522,0-10-4.478-10-10v-80c0-5.523,4.478-10,10-10h69c5.522,0,10,4.477,10,10V432z"/><path fill="#102235" stroke="#999999" stroke-width="2" stroke-miterlimit="10" d="M864,656.851c0,11.128-9.021,20.149-20.149,20.149H705.149C694.021,677,685,667.979,685,656.851V496.149c0-11.128,9.021-20.149,20.149-20.149h138.701c11.128,0,20.149,9.021,20.149,20.149V656.851z"/><path fill="none" stroke="#FF0000" stroke-width="4" stroke-miterlimit="10" d="M685,622c0,0,16.75-4.75,23.75-11.75S723,603,736,600s20-6,32-14s21-19,32-22s18-8.004,24-19.002s8-20.252,19-27.625S855.51,502,862.255,501"/><path fill="none" stroke="#F7931E" stroke-width="4" stroke-miterlimit="10" d="M685,637.5c0,0,22.5-9,35.5-9c5,0,13-5.5,18-7.5s14.5-13.5,20.5-14s25.5-6.5,30.5-7.5s14-9,29.5-8.5c6-0.5,13.5-11,20.5-14.5s12.5-11,16.5-15s3-8.5,8-9.5"/><path fill="none" stroke="#0071BC" stroke-width="4" stroke-miterlimit="10" d="M685,656.851c0,0,19.5,2.851,29.75,0S746.254,653,754.627,650S786,641,800,637.5s39-2.5,41.5-3.5s12.449-7,20.475-17"/><circle fill="#ED0A0A" cx="842.75" cy="517.25" r="11.75" id="high_2"/><circle fill="#ED0A0A" cx="779.75" cy="576.25" r="11.75" id="high_1"/><circle fill="#ED0A0A" cx="708.75" cy="610.25" r="11.75" id="high_0"/><circle fill="#FFB600" cx="708.75" cy="633.25" r="11.75" id="medium_0"/><circle fill="#FFB600" cx="779.75" cy="603.25" r="11.75" id="medium_1"/><circle fill="#FFB600" cx="839.75" cy="576.25" r="11.75" id="medium_2"/><circle fill="#0A43C1" cx="708.75" cy="658.25" r="11.75" id="low_0"/><circle fill="#0A43C1" cx="779.75" cy="645.25" r="11.75" id="low_1"/><circle fill="#0A43C1" cx="841.75" cy="633.25" r="11.75" id="low_2"/></g></svg>');

			//we have to bind click functions to the SVG stuff this way because it doesn't like to do them inline when being appended to HTML via JQuery???
			$("#low_0").click(function() { circleClicked(_Coordinator, 0, 'low', this); });
			$("#low_1").click(function() { circleClicked(_Coordinator, 1, 'low', this); });
			$("#low_2").click(function() { circleClicked(_Coordinator, 2, 'low', this); });
			$("#low_3").click(function() { circleClicked(_Coordinator, 3, 'low', this); });
			$("#medium_0").click(function() { circleClicked(_Coordinator, 0, 'medium', this); });
			$("#medium_1").click(function() { circleClicked(_Coordinator, 1, 'medium', this); });
			$("#medium_2").click(function() { circleClicked(_Coordinator, 2, 'medium', this); });
			$("#medium_3").click(function() { circleClicked(_Coordinator, 3, 'medium', this); });
			$("#high_0").click(function() { circleClicked(_Coordinator, 0, 'high', this); });
			$("#high_1").click(function() { circleClicked(_Coordinator, 1, 'high', this); });
			$("#high_2").click(function() { circleClicked(_Coordinator, 2, 'high', this); });
			$("#high_3").click(function() { circleClicked(_Coordinator, 3, 'high', this); });

			$("#sandbox #low_0").click(function() { circleClicked(_Coordinator, 0, 'low', this); });
			$("#sandbox #low_1").click(function() { circleClicked(_Coordinator, 1, 'low', this); });
			$("#sandbox #low_2").click(function() { circleClicked(_Coordinator, 2, 'low', this); });
			$("#sandbox #medium_0").click(function() { circleClicked(_Coordinator, 0, 'medium', this); });
			$("#sandbox #medium_1").click(function() { circleClicked(_Coordinator, 1, 'medium', this); });
			$("#sandbox #medium_2").click(function() { circleClicked(_Coordinator, 2, 'medium', this); });
			$("#sandbox #high_0").click(function() { circleClicked(_Coordinator, 0, 'high', this); });
			$("#sandbox #high_1").click(function() { circleClicked(_Coordinator, 1, 'high', this); });
			$("#sandbox #high_2").click(function() { circleClicked(_Coordinator, 2, 'high', this); });

			startIntro();		//start animation intro
	}

	var startIntro = function() {

		var introTexts = [
			"Our world is changing...warming in an ever-accelerating<br/>reaction to humanity's continued development.",
			"We all have a part to play, together, in this...but each journey is also our own",
			"...steering into one of many possible futures.",
			"Maybe we can turn the tide to stem the worst of the changes.",
			"Maybe our action comes just too little, too late.",
			"Or maybe we let the chance to save our world slip through our fingers.",
			"What will you choose?"
		];


/*
		var animations = $.chain(function() {
			
			$('#centerText').html(introTexts[0]);
		    return $('#centerText').fadeIn(1000);				//"Our world is changing, something something..."
		}, function() {
			return $('body').delay(3000);							//wait
		}, function() {
			return $('#graphBlackout').fadeTo(1000, 0.2);			//fade in graph
		}, function() {
			drawUpToPresent();										//starts drawing to current day
		}, function() {
			return $('body').delay(2000);							//wait
		}, function() {
		    return $('#centerText').fadeOut(1000);			//fade out text
		}, function() {

		}, function() {
			$('#centerText').html(introTexts[1]);
			return $('#centerText').fadeIn(1000);			//"We all have a part to play, together, in this...but each journey is also our own"
		}, function() {
			return $('body').delay(3000);					//wait
		}, function() {
		    return $('#centerText').fadeOut(1000);			//fade out text
		}, function() {
			fadeFutureGradient();							//start animating gradient cone thingie
			$('#centerText').html(introTexts[2]);			//"...steering into one of many possible futures"
			return $('#centerText').fadeIn(1000);
		}, function() {
			return $('body').delay(3000);					//wait
		}, function() {
		    return $('#centerText').fadeOut(1000);			//fade out text
		}, function() {
			drawFutureBottom();								//draw in bottom line
			$('#centerText').html(introTexts[3]);			//"Maybe we do cool things"
			return $('#centerText').fadeIn(1000);
		}, function() {
			return $('body').delay(3000);					//wait
		}, function() {
		    return $('#centerText').fadeOut(1000);			//fade out text
		}, function() {
			drawFutureMiddle();								//draw in middle line
			$('#centerText').html(introTexts[4]);			//"Maybe things aren't so great"
			return $('#centerText').fadeIn(1000);
		}, function() {
			return $('body').delay(3000);					//wait
		}, function() {
		    return $('#centerText').fadeOut(1000);			//fade out text
		}, function() {
			drawFutureTop();								//draw in top line
			$('#centerText').html(introTexts[5]);			//"Or maybe we let the chance to save our world slip through our fingers."
			return $('#centerText').fadeIn(1000);
		}, function() {
			return $('body').delay(3000);					//wait
		}, function() {
		    return $('#centerText').fadeOut(1000);			//fade out text
		}, function() {
			$('#centerText').html(introTexts[6]);			//"What will you choose?"
			return $('#centerText').fadeIn(1000);
		}, function() {
			return $('body').delay(3000);					//wait
		}, function() {
			$('#graphBlackout').fadeOut(1000);					//fade in graph all the way
		    return $('#centerText').fadeOut(1000);			//fade out text
		}, function() {
			$(".point:not(.last)").fadeOut(1000);			//fade out all but end points
			$(".point.last").addClass("pointFlash");
		}
		);
*/


		var animations = $.chain(function() {
			$('#graphBlackout').fadeOut(1000);					//fade in graph all the way
			$("#graphLinesContainer").css("z-index", 0);
			
			drawUpToPresent();
			drawFutureMiddle();								//draw in middle line
			drawFutureBottom();								//draw in bottom line
			drawFutureTop();
			
		    return $('#centerText').fadeOut(1000);			//fade out text
		}, function() {
			$(".point:not(.last)").fadeOut(1000);			//fade out all but end points
			$(".point.last").addClass("pointFlash");
		}
		);



/*
		$.when( animations ).done(function() {
		    // ALL ANIMATIONS HAVE BEEN DONE IN SEQUENCE
		   
		}); */

		//circleClicked(0, "low");						//trigger click action on first timeline dot
	}

	//Timeline animations
	var drawUpToPresent = function(){
		$("#graphWiper").animate({
			width: "52%"
		}, 5000, function() {
			$("#graphWiper").hide();
			$("#graphLinesContainer").css("z-index", 0);
		});
	}

	var fadeFutureGradient = function(){
		//$('#futureGradient').fadeTo(5000, 0.4);
	}

	var drawFutureBottom = function(){
		$("#tempArea_low").fadeTo(5000, 0.4);
		$("#path_low_0").addClass("draw-in");
		$("#path_low_1").addClass("draw-in");
		$("#path_low_2").addClass("draw-in");
		$("#path_low_3").addClass("draw-in");
		$("#path_low_4").addClass("draw-in");
		
		$("#low_3").fadeIn();
		/*
		document.querySelectorAll('.point.futureBottom').forEach(function(point){
			point.style.opacity = 1;
		});
		*/

	}

	var drawFutureMiddle = function(){
		$("#tempArea_medium").fadeTo(5000, 0.4);
		$("#path_medium_0").addClass("draw-in");
		$("#path_medium_1").addClass("draw-in");
		$("#path_medium_2").addClass("draw-in");
		$("#path_medium_3").addClass("draw-in");
		$("#path_medium_4").addClass("draw-in");
		
		$("#medium_3").fadeIn();
		/*
		document.querySelectorAll('.point.futureMiddle').forEach(function(point){
			point.style.opacity = 1;
		});
		*/

	}

	var drawFutureTop = function(){
		$("#tempArea_high").fadeTo(5000, 0.4);
		$("#path_high_0").addClass("draw-in");
		$("#path_high_1").addClass("draw-in");
		$("#path_high_2").addClass("draw-in");
		$("#path_high_3").addClass("draw-in");
		$("#path_high_4").addClass("draw-in");

		$("#high_3").fadeIn();
	}
//end timeline animations

	$.chain = function() {
	    var promise = $.Deferred().resolve().promise();
	    jQuery.each( arguments, function() {
	        promise = promise.pipe( this );
	    });
	    return promise;
	};


	var returnToGraphScreen = function() {
		$("#graphBlackout").fadeOut();
		$("#totalGameContainer").hide();
		$('body').css("background-image", "none");
		$('body').css("background-color", "black");
		$("#graphContainer").show();
		var nextSceneIndex = State.get("sceneIndex")+1;
		if (nextSceneIndex > State.get("scenes").length) {
			startSandboxMode();
		}
		else {
			State.set("sceneIndex", nextSceneIndex);
			$("#graphClickBlocker").show();					//disable clicks on graph (full-screen div that covers anything below 2 z-index)
			
			circleClicked(Coordinator, State.get("sceneIndex"), State.get("sceneTimeline"), null);
		}
	}

	var startSandboxMode = function() {
		$("#graphClickBlocker").hide();
		$("svg circle").show();


		$("#sandbox").show();
	}



//---------Functions for the timeline UI-----------------------------
/*
	var initTimelineScreen = function(_Coordinator, _State, scenes) {
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

			var yearStr;
			if (_Coordinator.getStorySpec(scene))

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

			var targetDiv = scene + '-panel';
			createKnobs(scene, targetDiv);
			populateKnobs(scene, _Coordinator, _State, scenes);
		});

		initMetaKnobs(_Coordinator, _State);	//initiate meta knobs (after we've made scene knobs, so we can give default meta-knob values)

		activateBegins(_Coordinator, _State, scenes);

		//if we haven't sent form data yet, send it
		postTrackingStats();
		
		//if we don't have a unique tracking identifier for the player, set it	
		if (localStorage.getItem("playerIdentifier") == null) { setPlayerIdentifier(); }
	}
	*/
/*
	var returnToTimelineScreen = function(scenes) {

		$('body').empty();			//reset all html
		$('body').css("background-image", "none");

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
				html: '<span>' + Coordinator.getStorySpec(scene).year + '</span>'
			}).appendTo("#" + scene + '-panel');

			var theDiv = $('<div/>', {
			    id: 'scene_' + scene,
			    class: 'sceneWindows',
			    html: '<p>' + Coordinator.loadTimelineDesc(scene) + '</p>'
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

			populateKnobs(scene, Coordinator, State, scenes);
		});

		initMetaKnobs(Coordinator, State);	//initiate meta knobs (after we've made scene knobs, so we can give default meta-knob values)

		activateBegins(Coordinator, State, scenes);

		//if we haven't sent form data yet, send it
		postTrackingStats();
	}
*/
	//process the wishlist for the passed in story according to its current settings in the UI
	var processWishlistSettings = function(_Coordinator, id) {

		var knobList = [];
		var widgetNum = 0;
		var story = _Coordinator.getStorySpec(id);
		var knobsWishlistStateSettingsCache = [];				//a cache we store in case we need to use it later (just used for viz right now)

		for (var x=0; x < story.wishlist.length; x++) {
			if (story.wishlist[x].condition.includes("[") && !story.wishlist[x].condition.includes("game_mode")) {
				
				State.set("dynamicWishlist", true);			//set flag that we have a dynamic wishlist (so we know to look it up later)
				
				var stateSetter = false;			//whether it's a state setter, not a wishlist setter
				story.wishlist[x].condition.replace("State:", "state:");		//correct capitalization if necessary
				if (story.wishlist[x].condition.includes("state:")) { stateSetter = true; }

				if (story.wishlist[x].condition.includes("-")) {			//it's a slider
					var value = $("#" + story.id + "-slider-" + x).slider("option", "value");
					if (stateSetter) {
						var key = story.wishlist[x].condition.replace("state:","").trim().split(" ")[1];
						State.set(key, value);
						knobsWishlistStateSettingsCache.push({"type" : "stateSetter", "key" : key, "value" : value});
					}
					else {
						story.wishlist[x].condition = story.wishlist[x].condition.replace(/\[.*?\]/g, value);
					}
					widgetNum++;
				}
				else if (story.wishlist[x].condition.includes("|")) {	//it's a dropdown
					var value = $("#" + story.id + "-select-" + x).val();
					if (stateSetter) {
						var key = story.wishlist[x].condition.replace("state:","").trim().split(" ")[1];
						State.set(key, value);
						knobsWishlistStateSettingsCache.push({"type" : "stateSetter", "key" : key, "value" : value});
					}
					else {
						story.wishlist[x].condition = story.wishlist[x].condition.replace(/\[.*?\]/g, value);
					}
					widgetNum++;
				}
				else {									//it's a switch
					var value = $("#" + story.id + "-switch" + x).val();
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
				delete story.wishlist[x].changeFunc;

				if (stateSetter) { delete story.wishlist[x]; }		//if it's a state setter, just remove whole thing
				
			}
			else if (story.wishlist[x].condition.includes("game_mode")) {
				var value = $("#" + story.id + "-select-" + x).val();
				if (value !== "random") { State.set("gameModeChosen",value); }			//if they chose a non-random value, set it
				delete story.wishlist[x];					//remove it from the list, as it's not actually a wishlist item
			}
		}

		State.set("processedWishlist", story.wishlist);
		State.set("knobsWishlistStateSettingsCache", knobsWishlistStateSettingsCache);
	}

	//processes current shimmer values by looking them up in localStorage and updating wishlist items
	var processWishlistShimmers = function(_Coordinator, id) {
		var story = _Coordinator.getStorySpec(id);
		var knobsWishlistStateSettingsCache = [];			//a cache we store in case we need to use it later (just used for viz right now)

		for (var x=0; x < story.wishlist.length; x++) {
			if (story.wishlist[x].condition.includes("[") && !story.wishlist[x].condition.includes("game_mode")) {
				State.set("dynamicWishlist", true);			//set flag that we have a dynamic wishlist (so we know to look it up later)
				var stateSetter = false;			//whether it's a state setter, not a wishlist setter
				story.wishlist[x].condition.replace("State:", "state:");		//correct capitalization if necessary
				if (story.wishlist[x].condition.includes("state:")) { stateSetter = true; }

				var bbWishlistValues = parseBlackboardWishlist()[id];
				if (bbWishlistValues == undefined) { throw "dynamic wishlist item (" + story.wishlist[x].condition + ") but no dynamic shimmers used to set them!"}
				var value = bbWishlistValues[story.wishlist[x].condition];
				if (stateSetter) {
					var key = story.wishlist[x].condition.replace("state:","").trim().split(" ")[1];
					State.set(key, value);
					knobsWishlistStateSettingsCache.push({"type" : "stateSetter", "key" : key, "value" : value});
				}
				else {
					story.wishlist[x].condition = story.wishlist[x].condition.replace(/\[.*?\]/g, value);
				}
			}
			else if (story.wishlist[x].condition.includes("game_mode")) {		//game mode dynamic wishlist items
				throw "there shouldn't be dynamic game settings in the wishlists now!"
				/* 
				var value = $("#" + story.id + "-select-" + x).val();
				if (value !== "random") { State.set("gameModeChosen",value); }			//if they chose a non-random value, set it
				delete story.wishlist[x];					//remove it from the list, as it's not actually a wishlist item
				*/
			}

			//these shouldn't even be necessary any more, remove once confirmed
			delete story.wishlist[x].label;
			delete story.wishlist[x].hoverText;
			delete story.wishlist[x].changeFunc;

			if (stateSetter) { delete story.wishlist[x]; }		//if it's a state setter, just remove whole thing
		}

		State.set("processedWishlist", story.wishlist);
		State.set("knobsWishlistStateSettingsCache", knobsWishlistStateSettingsCache);

	}
/*
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
*/
	var initMetaKnobs = function(_Coordinator, _State) {
		//TODO
	}

	var createKnobs = function(sceneId, targetDivId) {
		var theKnobs = $('<div/>', {
		    id: 'knobs_' + sceneId,
		    class: 'sceneKnobs closed'
		}).appendTo("#" + targetDivId);
	}

	//activate and add in knobs for coordinator stuff
	var populateKnobs = function(sceneId, _Coordinator, _State, scenes) {
		var sceneSpec = _Coordinator.getStorySpec(sceneId);

		if (sceneSpec == null) { 
			console.log("no sceneSpec for scene to use to populate knobs!");
			return;
		}

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
					if (!knobString.includes(":")) { throw knobString + " needs a default value!"}
					var minValStart = knobString.indexOf("[") + 1;
					var minValEnd = knobString.indexOf("-");
					var minVal = knobString.substring(minValStart,minValEnd);		//get min value
					var maxValStart = knobString.indexOf("-") + 1;
					var maxValEnd = knobString.indexOf(":");
					var maxVal = knobString.substring(maxValStart,maxValEnd);		//get max value
					knobHtml += '<label for="'+ sceneId +'-slider-' + x.toString() +'"'+ hoverTextClass +'>'+hoverText+theLabel+'</label><div id="'+ sceneId +'-slider-' + x.toString() +'"><div id="custom-handle-'+ sceneId + '_' + x.toString() +'" class="ui-slider-handle"></div></div>';
					$("#knobs_" + sceneId).append(knobHtml);
					sliderX.push({xVal:x, min: minVal, max: maxVal, knobString: knobString});
					$( function() {
						var data = sliderX.shift();
						var knobString = data.knobString;
				    	var handle = $( "#custom-handle-"+ sceneId + "_" + data.xVal.toString() );
					    $( "#" + sceneId + "-slider-" + data.xVal.toString() ).slider({
					    	create: function() { 
					    		var sliderDefaultStart = knobString.indexOf(":")+1;
								var sliderDefaultEnd = knobString.length;
					    		$(this).slider('value', knobString.substring(sliderDefaultStart,sliderDefaultEnd));
					    		handle.text( $( this ).slider( "value" ) ); 
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
			case "friendBackgroundBalance":
				friendBackgroundBalance(changingElement);
				break;
			case "friendSupportivenessBalance":
				friendSupportivenessBalance(changingElement);
				break;
		}
	}

	//-------------KNOB TWIDDLING FUNCTIONS-------------------------------------------

	var studentBalance = function(changer) {
		var partnerSlider;
		if (changer.id == "finalLecture-slider-11") { partnerSlider = "#finalLecture-slider-12"}
		else { partnerSlider = "#finalLecture-slider-11"; }
		var currentValue = $("#" + changer.id).slider('value');
		$(partnerSlider).slider('value', (3-currentValue));
		$(partnerSlider).find(".ui-slider-handle").text((3-currentValue));
	}

	var friendBackgroundBalance = function(changer) {
		var sliders = $('#knobs_finalDinner .ui-slider').toArray();
		var changerIndex = sliders.indexOf(changer);
		var partnerIndex = (changerIndex % 2 === 0) ? changerIndex + 1 : changerIndex - 1;
		var partnerSlider = sliders[partnerIndex];
		var currentValue = $("#" + changer.id).slider('value');
		$(partnerSlider).slider('value', (2-currentValue));
		$(partnerSlider).find(".ui-slider-handle").text((2-currentValue));
	}

	var friendSupportivenessBalance = function(changer) {
		var sliders = $('#knobs_finalDinner .ui-slider').toArray();
		var changerIndex = sliders.indexOf(changer);
		var partnerIndex = (changerIndex % 2 === 0) ? changerIndex + 1 : changerIndex - 1;
		var partnerSlider = sliders[partnerIndex];
		var currentValue = $("#" + changer.id).slider('value');
		$(partnerSlider).slider('value', (2-currentValue));
		$(partnerSlider).find(".ui-slider-handle").text((2-currentValue));
	}
//------------------------------------------------------------------------------------
	//builds the scene divs
	var initSceneScreen = function(State, bg, id) {

		$('#graphContainer').hide();
		$('body').css("background-image", "url('assets/bgs/"+ bg +"')"); 

		if ($("#totalGameContainer").length == 0) {
			$('<div/>', {
			    id: 'totalGameContainer'
			    //text: ''
			}).appendTo('body');

			$('<div/>', {
			    id: 'storyContainer'
			    //text: ''
			}).appendTo('#totalGameContainer');

			$('<div/>', {
			    id: 'gameContainer'
			    //text: ''
			}).appendTo('#totalGameContainer');

			$('<div/>', {
				id: 'gameControls'
			}).appendTo('#gameContainer');

			$('<div/>', {
			    id: 'statsContainer',
			    //text: ''
			}).appendTo('#totalGameContainer');

			$('<div/>', {
			    id: 'sceneIntro'
			    //text: ''
			}).appendTo('#totalGameContainer');

			$('<div/>', {
			    id: 'blackout'
			    //text: ''
			}).appendTo('#totalGameContainer');
		}

		else {
			$("#totalGameContainer").show();
		}

		if (avatarMode == "oneMain") {
			$("#statsContainer").addClass("oneMain");
			$("#storyContainer").addClass("oneMain");
		}

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

				if (avatarMode == "oneMain") {		//if we're in the mode where there's just one portrait for the main character...

					var fragmentPortraitChar = State.get("currentAvatar");		//grab the avatar for this fragment. If there isn't one, default to main character
					if (typeof fragmentPortraitChar == "undefined") {
						fragmentPortraitChar = State.get("characters")[0].id;
					}
					if (avatar.id == fragmentPortraitChar) {
						if (document.getElementById('mainAvatar') == null){			//if div doesn't exist, create it
							$('<div/>', {
								id: "mainAvatarDiv",
								class: 'statContainer oneMain'
							}).appendTo('#statsContainer');

							$('<div/>', {			//create avatarBox and stat-holding box for character
							    id: "mainAvatar",
							    class: picClass + " oneMain"
							}).appendTo('#mainAvatarDiv');

							createStats();
						}

						$('#mainAvatar').css("background-image", "url("+url+")"); 					//set avatar
						$('#mainAvatar').html("<div class='nameLabel'>" + char.name + "</div>");	//set name label
					}

					else {
						if (document.getElementById(char.id) == null){			//if div doesn't exist, create it
							$('<div/>', {
								id: char.id,
								class: 'statContainer hidden'
							}).appendTo('#statsContainer');

							$('<div/>', {			//create avatarBox and stat-holding box for character
							    id: 'charPic_' + char.id,
							    class: picClass + " hidden"
							}).appendTo('#' + char.id);

							createStats();
						}
					}

				}

				else {				//otherwise if it's one portrait per character...(rpg style)
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

			var statClass = "stat";
			if (avatarMode == "oneMain") { statClass += " hidden";	}

			stats.forEach(function(stat, pos) {

				for (var x=0; x < stat.characters.length; x++) { //for each character...

					if (document.getElementById(stat.characters[x] + "_" + stat.varName) == null) {
						$('<div/>', {		//make progressbar divs
							id: stat.characters[x] + "_" + stat.varName,
					    	class: statClass,
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
		if (typeof stats !== "undefined") {
			stats.forEach(function(stat, pos) {
				for (var x=0; x < stat.characters.length; x++) { //for each character...
					setBarWidth(stat.characters[x] + "_" + stat.varName);
				}
			});
		}

	}

	//sets stat bar width
	var setBarWidth = function(statDivId) {
		var character = statDivId.split("_")[0];
		var statName = statDivId.split("_")[1];
		var stat = State.getBlackboard().storyUIvars.filter(function(thing,i){ 
			return thing.varName == statName;
		})[0];
		var newWidth = State.get(statName)/(stat.range[1] - stat.range[0]) * 100;

		if (avatarMode !== "oneMain" && statsContainer.firstChild !== null && typeof statsContainer.firstChild.children[1].children[2] !== "undefined") {
			var statName1 = statsContainer.firstChild.children[1].firstChild.id;
			var statName2 = statsContainer.firstChild.children[1].children[2].id;

			if (statDivId == statName1 || statDivId == statName2) {		//if it's a big stat, increase appropriately
				newWidth *= 2;
			}
		}
		$("#" + statDivId).css("width", newWidth + "%");
	}

	//sets the intro screen for each scene
	var setSceneIntro = function(sceneText, id) {
		$("#blackout").show();

		$("#sceneIntro").html("<div id='introText'>In this scene you'll have to balance exploring the narrative with playing this game. Try it out to get the hang of it before starting!</div><div id='introGame'></div>");
		if (id.substring(0,6) == "intro:") { 
			$("#sceneIntro").html("<div id='introText' style='width:100%'>" + sceneText + "</div>");
		}

		var linkText = "";
		if (id.substring(0,6) !== "intro:") {	//if we're not using the intro as an interstitial scene, start game...
			Coordinator.startGame(id, true, true);		//start intro game
			linkText = "Start Scene";
		}
		else { linkText = "Continue"; }

		$("#gameContainer").css("visibility","hidden"); // hide the empty game container during intro or interstitial scene

		var begin = $('<h2/>', {
			text: linkText,
			id: "introLink",
			click: function() {
				if (id.substring(0,6) == "intro:") {	//if this is interstitial, clicking the link starts the next scene
					//initGraphScreen(Coordinator, State, State.get("scenes"));					//reinitialize title screen (terrible)
					//initTitleScreen(Coordinator, State, State.get("scenes"), State.get("scenes"));		//reinitialize title screen (terrible)
					var nextIndex = Coordinator.getNextScene(State.get("currentScene"));
					var nextScene = State.get("scenes")[nextIndex];
					if (nextScene == undefined) {		//if there's no next scene, we're at the end, so go back to title
						State.set("playthroughCompleted", true);
						returnToGraphScreen();
					}
					else {
						if (nextScene.indexOf(":") > 0) { nextScene = nextScene.split(":")[1]; }
						setTimeout(function (){
						  $("#startScene_" + nextScene).click();
						}, 500);
					}
					
				}
				else {			//otherwise, it closes the intro window and starts the scene
					$("#gameContainer").show();
					Coordinator.startGame(id);				//start real game
					$("#sceneIntro").fadeOut( "slow" );
					$("#blackout").fadeOut( "slow" );
					$("#gameContainer").css("visibility","visible"); // unhide the game container
					State.set("refreshEnabled", true);		//enable refreshNarrative for game hook up
					State.setPlaythroughData(State.get("currentTextId"), State.get("currentChoices"));	//set playthrough data
				}
			}
		}).appendTo("#sceneIntro");
		$("#sceneIntro").fadeIn( "slow" );
	}

	var setSceneOutro = function(endText) {

		$("#gameContainer").hide();

		var nextIndex = Coordinator.getNextScene(State.get("currentScene"));
		var nextScene = State.get("scenes")[nextIndex];
		$( "#blackout" ).delay(1600).fadeIn( "slow", function() {
	    	$("#sceneIntro").html("<div id='outroText'>" + endText + "</div>");
	    	/*
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
			*/

	    	var begin = $('<h2/>', {
			text: 'Next',
			click: function() {

				postTrackingStats();		//post tracking stats

				if (interfaceMode == "timeline") {		//if timeline, return there
					returnToTimelineScreen(State.get("scenes"));
				}
				else if (interfaceMode == "graph") {
					returnToGraphScreen();
				}
				else {			//otherwise, start next scene
					$('body').append("<div id='hiddenKnobs'></div>");
					createKnobs(nextScene, "hiddenKnobs");
					populateKnobs(nextScene, Coordinator, State, State.get("scenes"));
					setTimeout(function (){		//gotta put in some lag for the knobs to populate
					  startScene(Coordinator, nextScene, true);
					}, 500);
					
				}
			}
			}).appendTo("#sceneIntro");

	    	$( "#sceneIntro" ).fadeIn();
	    });
	}

	var addGameDiagnostics = function(gameSpec, aspFilepath, aspGame, aspGameInstructions, initialPhaserFile) {
		if (document.getElementById("gameDiagnostics") !== null) {
		  $("#gameDiagnostics").remove();
		  $("#gameDiagnosticsButton").remove();
		}
		$('<div/>', {
			id: "gameDiagnostics",
			html: '<ul><li><a href="#ReportBugDiv">Report Bug</a></li><li><a href="#ASPEditor">ASP Editor</a></li><li><a href="#JSONEditorDiv">JSON Editor</a></li></ul><div id="ReportBugDiv"></div><div id="ASPEditor"></div><div id="JSONEditorDiv"></div>'
		}).appendTo("body");

		addBugReporter(gameSpec, aspFilepath, aspGame, aspGameInstructions);
		addJSONEditor(gameSpec, initialPhaserFile);
		addASPEditor(gameSpec, aspFilepath, aspGame);

		$('<div/>', {
			id: "gameDiagnosticsButton",
			click: function() {
        updateBugReportTexts(aspFilepath, aspGame, aspGameInstructions);
  			$("#gameDiagnostics").toggle();
			}
		}).appendTo("body");

		$( "#gameDiagnostics" ).tabs();
	};
  var gameBugBaseURL = "https://github.com/LudoNarrative/ClimateChange/issues/new?labels="+encodeURIComponent("Gemini/Cygnus")+",bug";
  var storyBugBaseURL = "https://github.com/LudoNarrative/ClimateChange/issues/new?labels=StoryAssembler,bug";

  var updateGameBugHref = function() {
    $("#GameBugSubmit").attr("href", gameBugBaseURL + "&body="+encodeURIComponent($("#GameBug").text()));
  };
  var updateStoryBugHref = function() {
    $("#StoryBugSubmit").attr("href", storyBugBaseURL + "&body="+encodeURIComponent($("#StoryBug").text()));
  };
    
  var updateBugReportTexts = function(aspFilepath, aspGame, aspGameInstructions) {
    $("#GameBug").text(
      "This game (delete any that do not apply):\n- Was confusing.\n- Was difficult to play.\n- Was boring.\n- Did not function according to the instructions.\n- Was not appropriate for this scene.\n\n"+
        "Other comments/elaborations:\n\n\n"+
        "Game: "+aspFilepath+"\n" +
        "```\n"+
        aspGame + "\n" + "==========\n" + aspGameInstructions +
        "\n```"
    );
    
    // TODO: also show vars and other interesting things, and grab this in a nice way instead of this rude way 
    $("#StoryBug").text("Issue:\n\nCurrent story chunks:\n```\n"+$( "#storyContainer" ).text()+"\n```");

    updateGameBugHref();
    updateStoryBugHref();
  };

	  var addBugReporter = function(gameSpec, aspFilepath, aspGame, aspGameInstructions) {

        var left = $("<div/>", {style:"width: 40%; display:inline-block;"}).appendTo("#ReportBugDiv");
        var submitLeft = $("<a/>", {
            id: 'GameBugSubmit',
            text: 'Submit game bug',
            href: gameBugBaseURL,
            target: "_blank",
            style: "display:block; width:200px;"
        }).appendTo(left);
		    $('<textarea/>', {
			      id: 'GameBug',
			      rows: "4",
			      cols: "40",
            style: "margin-right: 20px",
            text: "",
            change: updateGameBugHref
		    }).attr('spellcheck',false)
		        .appendTo(left);

        var right = $("<div/>", {style:"width:40%; display:inline-block;"}).appendTo("#ReportBugDiv");
        var submitRight = $("<a/>", {
            id: 'StoryBugSubmit',
            text: 'Submit story bug',
            href: storyBugBaseURL,
            target: "_blank",
            style: "display:block; width:200px;"
        }).appendTo(right);
        $('<textarea/>', {			//add editing field
			      id: 'StoryBug',
			      rows: "4",
			      cols: "40",
			      text: "",
            change: updateStoryBugHref
		    }).attr('spellcheck',false)
		        .appendTo(right);
	  };

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

	//posts tracking stats if we have any unsent ones
	var postTrackingStats = function() {
		if (Coordinator.recordPlaythroughs && localStorage.getItem('playthroughScene') !== null) {
			postToGoogleForm();
			localStorage.removeItem("playthroughScene");
			localStorage.removeItem("playthroughData");
		}
	}

	var postToGoogleForm = function() {

		if (State.get("displayType") !== "editor") {
			postToForm(getData());
			postToForm(getData("times"));
		}

		function postToForm(data) {
			var url = 'https://script.google.com/macros/s/AKfycbxXDhwmHQZMTTYrU6JzqQnC3t57cHLNOAlmTIQsLtde0LHwezo/exec';
		    var xhr = new XMLHttpRequest();
		    xhr.open('POST', url);
		    xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');

		    // url encode form data for sending as post data
		    var encoded = Object.keys(data).map(function(k) { return encodeURIComponent(k) + '=' + encodeURIComponent(data[k]) }).join('&');
		    xhr.send(encoded);	
		}
	}

	var setPlayerIdentifier = function() {

		var emotions = ['understanding','great','playful','calm','confident','courageous','peaceful','reliable','joyous','energetic','lucky','liberated','comfortable','amazed','fortunate','optimistic','pleased','free','delighted','provocative','encouraged','sympathetic','overjoyed','impulsive'];
		var colors = ['amber','amethyst','apricot','aqua','aquamarine','auburn','azure','beige','black','blue','bronze','brown','cardinal','carmine','celadon','cerise','cerulean','charcoal','chartreuse','chocolate','cinnamon','scarlet','copper','coral','cream','crimson','cyan','denim','ebony','ecru','eggplant','emerald','fuchsia','gold','goldenrod','gray','green','indigo','ivory','jade','jet','khaki','lavender','lemon','light','lilac','lime','magenta','mahogany','maroon','mauve','mustard','ocher','olive','orange','orchid','pale','pastel','peach','periwinkle'];
		var animals = ['alligator','ant','bear','bee','bird','bull','camel','cat','cheetah','chicken','chimpanzee','cow','crocodile','deer','dog','dolphin','duck','eagle','elephant','fish','fly','fox','frog','giraffe','goat','goldfish','gorilla','hamster','hippopotamus','horse','kangaroo','kitten','lion','lobster','monkey','octopus','owl','panda','pig','puppy','rabbit','rat','scorpion','seal','shark','sheep','snail','snake','spider','squirrel','swan','tiger','turtle','wolf','wren','zebra','pale','pastel','peach','periwinkle'];
		var letters = ['A','B','C','D','E','F','G','H','I','J','H'];
		var identifier = "";
		var d = new Date();
		identifier = emotions[d.getHours()] + " " + colors[d.getMinutes()] + " " + animals[d.getSeconds()] + " " + letters[Math.trunc(d.getMilliseconds()/100)] + (d.getMilliseconds()%100).toString();

		localStorage.setItem("playerIdentifier", identifier);
	}

	// get all data in form and return object
	//mode: if it's "times", it only puts times for choices
	var getData = function(mode) {

		var data = {};
		data.scene = localStorage.getItem("playthroughScene");
		data.identifier = localStorage.getItem("playerIdentifier");

		var temp = JSON.parse(localStorage.getItem('playthroughData'));

		//set total time
		totalTime = (temp[temp.length-1].time - temp[0].time)/1000;

		//set times for each node
		for (x = 0; x < temp.length-1; x++) {
			temp[x].time = (temp[x+1].time - temp[x].time)/1000;
		}

		var labels = '["identifier","scene","total time"';
		for (var x=1; x < 51; x++) { 
			if (x <= temp.length) {
				labels += ',"choice_' + x + '"';		//add label field
				if (mode == "times" && data["choice_" + x] !== null) { 		//add time data if mode correct
					data["choice_" + x] = temp[x-1].time; 
				}		
				else if (data["choice_" + x] !== null) { 			//otherwise add all choice data
					data["choice_" + x] = JSON.stringify(temp[x-1]); 
				}
			}
			else { labels += ',""'; }
		}
		labels += "]";

		// add form-specific values into the data
		//data.formDataNameOrder = '["scene","data"]';
		data.formDataNameOrder = labels;
		data.totalTime = totalTime;
		data.formGoogleSheetName = "responses"; // default sheet name
		if (mode == "times") { data.formGoogleSheetName = "justTimes"; }
		data.formGoogleSendEmail = ""; // no email by default

		return data;
	}

	return {
		init : init,
		initTitleScreen : initTitleScreen,
		//initTimelineScreen : initTimelineScreen,
		initGraphScreen : initGraphScreen,
		initSceneScreen : initSceneScreen,
		setAvatars : setAvatars,
		createStats : createStats,
		createKnobs : createKnobs,
		populateKnobs : populateKnobs,
		setStats : setStats,
		setSceneIntro : setSceneIntro,
		setSceneOutro : setSceneOutro,
		startScene : startScene,
		addGameDiagnostics : addGameDiagnostics,
		processWishlistSettings : processWishlistSettings,
		interfaceMode : interfaceMode,
		avatarMode : avatarMode,
		circleClicked : circleClicked,
		textClickFuncs : textClickFuncs
	} 
});