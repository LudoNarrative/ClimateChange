define(["Game", "jQuery", "jQueryUI"], function(Game) {

	var State;

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
				_coordinator.loadAvatars(id);
			}
		}).appendTo(pTag);

		return pTag;
	}

	var initTitleScreen = function(_coordinator, _State, scenes) {

		State = _State;
		
		$('<h1/>', {
		    text: 'Climate Change Game',
		    id: 'title'
		}).appendTo('body');

		var begin = $('<h2/>', {
			text: 'Begin',
			id: 'begin',
			click: function() {
				initSceneScreen(State);
				_coordinator.loadStoryMaterials(scenes[0]);
				_coordinator.startGame(scenes[0]);
				_coordinator.loadAvatars(scenes[0]);
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

	var initSceneScreen = function(State) {

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

		initStatsUI(State);
	}

	var initStatsUI = function(State) {
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
		Sets avatar on-screen based on state
	*/
	var setAvatar = function(State) {
		var theAvatar = false;

		State.avatars.forEach(function(avatar, pos) {
			var correctAvatar = State.isTrue(avatar.state);
			if (correctAvatar) {
				theAvatar = avatar;
			}
		});
		if (theAvatar) {
			$('#charPic').css("background-image", "url(/assets/avatar/"+ theAvatar.src +")"); 
		}
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
		initTitleScreen : initTitleScreen,
		setAvatar : setAvatar
	} 
});