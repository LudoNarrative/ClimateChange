/* Main StoryAssembler Module.
*/

define(["Display", "Request"], function(Display, Request) {

	var beginScene = function(wishlist) {
		
		Display.init(function(){});

		// Pick an item from the wishlist.
		var nextItem = wishlist.selectNext();

		// Get and show text for that item.
		var text = Request.getText(nextItem.content);
		Display.addStoryText(text);
	}

	return {
		beginScene: beginScene
	}
});		