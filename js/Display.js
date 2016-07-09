define(["Game"], function(Game) {

	var makeLink = function(_coordinator, id, content, target) {
		var el = document.createElement("a");
		el.href = target;
		el.onclick = function() {
			_coordinator.loadStoryMaterials(id);
			_coordinator.startGame(id);
		}
		el.innerHTML = content;
		var p = document.createElement("p");
		p.appendChild(el);
		return p;
	}

	var initTitleScreen = function(_coordinator, scenes) {
		
		// For each scene, make a link to start it.
		scenes.forEach(function(scene, pos) {
			var body = document.getElementsByTagName("body")[0];
			var el = makeLink(_coordinator, scene, scene, "#");
			body.appendChild(el);
		});
	}

	return {
		initTitleScreen : initTitleScreen	
	} 
});