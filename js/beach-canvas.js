/*** MAIN CODE ****/

// Global Parameters
store.set("percent",0);
store.set("required_percent",0);
store.set("emotional",0);

// Update stress for scrubbing game.
function update_stress(){
	var sfsrc = (document.getElementById("stressface").src).substring(26);

	if (store.get("serious") == "chill"){
		 set_src("stressface", get_random_in_list(["conversation/scrubGame_chill_1.png", "conversation/scrubGame_chill_2.png", "conversation/scrubGame_chill_3.png", "conversation/scrubGame_chill_4.png"],sfsrc));
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

	$('#choice-points').on('click',function()
	{
		update_stress();
	});

  check_end();
  checkEnd = setInterval ( check_end, 500 );
});


function get_random_in_list(list, exception){
	el = exception;
	if (list.length > 1){
		while(el==exception){
			el = choose_random_element(list)
		}
	}
	else{
		console.log("List length too small (requires length > 1).")
	}
	return el;
}

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
