/* Main StoryAssembler Module.
*/

define(["Display", "Request"], function(Display, Request) {

	var chunkLibrary;
	var beginScene = function(wishlist, _chunkLibrary) {
		chunkLibrary = _chunkLibrary;
		
		Display.init(function(){});

		// Pick an item from the wishlist.
		var bestPath = wishlist.bestPath(chunkLibrary);
		var nextStep = bestPath.route[0];

		// Get and show text for that item.
		// var text = Request.getText(nextItem.content);
		var text = chunkLibrary.get(nextStep).content;
		
		Display.addStoryText(text);
	}

	return {
		beginScene: beginScene
	}
});		