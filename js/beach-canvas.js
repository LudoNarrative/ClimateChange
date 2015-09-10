/*** MAIN CODE ****/

// Global Parameters
store.set("percent",0);
store.set("required_percent",0);
store.set("emotional",0);

// Update stress for scrubbing game.
function update_stress(){
	if (store.get("emotional") <= 0){
		set_src("stressface", choose_random_element(["conversation/scrubGame_chill_1.png", "conversation/scrubGame_chill_2.png", "conversation/scrubGame_chill_3.png", "conversation/scrubGame_chill_4.png"]));
	}
	else{
		set_src("stressface", choose_random_element(["conversation/scrubGame_upset_1.png", "conversation/scrubGame_upset_2.png"]));
	}
}

$(document).ready(function(){
	startPassages("workers.json","Start");
	updateStress = setInterval(update_stress, 1000);

  check_end();
  checkEnd = setInterval ( check_end, 500 );
});


function check_end(){

	// If the game is done,
	if (!store.get("update")){

		// Stop checking for end.
		clearInterval(checkEnd);

		// Stop updating passage.
		clearInterval(updatePassage);

		// Clear scrubbing message.
		clearTimeout(scrubTimer);
   	scrubTimer = undefined;
   	showingScrubMessage = false;

		//Add choice point to point back to menu.
		document.getElementById('choice-points').innerHTML = ("<a class='choice-point' href='../index.html'>End of Chapter Three.</a>");
	}
}
