/*** MAIN CODE ****/

// Global Parameters
store.set("percent",0);
store.set("required_percent",0);
store.set("emotional",0);

// Update stress for scrubbing game.
function update_stress(){
	if (store.get("serious") == "chill"){
		 set_src("stressface", "conversation/scrubGame_chill_1.png")
		// set_src("stressface", choose_random_element(["conversation/scrubGame_chill_1.png", "conversation/scrubGame_chill_2.png", "conversation/scrubGame_chill_3.png", "conversation/scrubGame_chill_4.png"]));
	}
	else if (store.get("serious")=="chillbro"){
		set_src("stressface","conversation/scrubGame_chill_bro.png");
	}
	else if (store.get("serious")=="unchillbro"){ // super unchill bro!  he sad.
		set_src("stressface","conversation/scrubGame_serious_2.png");
	}
	else if (store.get("serious")=="chillsis"){
		set_src("stressface","conversation/scrubGame_chill_sis.png");
	}
	else if (store.get("serious")=="neutral"){
		set_src("stressface","conversation/scrubGame_neutral.png");
	}
	else{ // "unchill"
		set_src("stressface", "conversation/scrubGame_serious.png");
	}
}

$(document).ready(function(){
	startPassages("workers.json","Start");

	// updateStress = setInterval(update_stress, 1000);
	$('#choice-points').on('click',function()
	{
		update_stress();
	});

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
