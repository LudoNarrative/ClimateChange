define(["Game","jQuery", "jQueryUI"], function(Game) {

	var makeLink = function(_coordinator, id, content, target) {
		
		var pTag = $('<p/>', {
		    class: 'titleLink',
		});

		$('<a/>', {
		    href: target,
		    text: content,
		    click: function() {
				initSceneScreen();
				_coordinator.loadStoryMaterials(id);
				_coordinator.startGame(id);
			}
		}).appendTo(pTag);

		return pTag;
	}

	var initTitleScreen = function(_coordinator, scenes) {
		
		$('<h1/>', {
		    text: 'Climate Change Game',
		    id: 'title'
		}).appendTo('body');

		var begin = $('<h2/>', {
			text: 'Begin',
			id: 'begin',
			click: function() {
				initSceneScreen();
				_coordinator.loadStoryMaterials(scenes[0]);
				_coordinator.startGame(scenes[0]);
			}
		}).appendTo('body');

		$('<h2/>', {
		    text: 'Scene Selection',
		    id: 'sceneSelectTitle'
		}).appendTo('body');

		// For each scene, make a link to start it.
		scenes.forEach(function(scene, pos) {
			var el = makeLink(_coordinator, scene, scene, "#");
			$('body').append(el);
		});
	}

	var initSceneScreen = function() {

		$('body').html('');
		$('<div/>', {
		    id: 'storyContainer'
		    //text: ''
		}).appendTo('body');

		$('<div/>', {
		    id: 'gameContainer'
		    //text: ''
		}).appendTo('body');

		$('<div/>', {
		    id: 'statsContainer'
		    //text: ''
		}).appendTo('body');

		initStatsUI();
	}

	var initStatsUI = function() {
		$('<div/>', {
		    id: 'charPic'
		    //text: ''
		}).appendTo('#statsContainer');

		$('<div/>', {
		    id: 'storyStats'
		    //text: ''
		}).appendTo('#statsContainer');

		$('<div/>', {
		    id: 'gameStats'
		    //text: ''
		}).appendTo('#statsContainer');

		$('<div/>', {
		    id: 'sharedStats'
		    //text: ''
		}).appendTo('#statsContainer');
	}

	/*
	Called by story and game systems to change stat displayed, or add it
	*/

	var setStat = function(statContainer, statName, statValue) {

		var container = $(statContainer);
		var exists = false;

		$(statContainer).forEach(function(statSpan, pos) {

		});

		$('span',"#" + statContainer).each(function(){
			if (this.html() == statName) {
				this.html(statValue);
			}
		})
	}

	return {
		initTitleScreen : initTitleScreen	
	} 
});