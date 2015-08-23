/*** MAIN CODE ****/

// Global Parameters
store.set("score",60);
store.set("difficulty",1);
store.set("update",1); // tells the game to end when update is 0

store.set("percent",0);
store.set("required_percent",0);
store.set("emotional",0);

// Update stress for scrubbing game.
function update_stress(){
	if (store.get("emotional") <= 0){
		set_src("stressface", choose_random_element(["scrubGame_chill_1.png", "scrubGame_chill_2.png", "scrubGame_chill_3.png", "scrubGame_chill_4.png"]));
	}
	else{
		set_src("stressface", choose_random_element(["scrubGame_upset_1.png", "scrubGame_upset_2.png"]));
	}
}

$(document).ready(function(){

	updateStress = setInterval(update_stress, 1000);


    check_end();
    checkEnd = setInterval ( check_end, 500 );
});

/**** ALL FUNCTIONS ****/

/**
 * Returns a random integer between min (inclusive) and max (inclusive)
 * Using Math.round() will give you a non-uniform distribution!
 */
function getRandomInt(min, max) {
    return Math.floor(Math.random() * (max - min + 1)) + min;
}

// Choose a random element from an array.
function choose_random_element(list){
	return list[Math.floor(Math.random() * list.length)];
}

// Choose random item.
function choose_random_item(){
	return choose_random_element(window.items)
}

// Choose random location.
function choose_random_location(){
	return choose_random_element(window.locations)
}

// Change the background image of the canvas.
function change_scene(image){
	$('#canvas').css('background-image', 'url("../img/'+image+'")');
}

// Place a generic object on the canvas.
function place_object(id,img,x,y,w,h){
	var elem = document.createElement("img");

	elem.setAttribute("alt", id);
	elem.setAttribute("id", id);
	// elem.id = id;
	document.getElementById("canvas").appendChild(elem);
	set_height(id,h);
	set_width(id,w);
	set_src(id,img);

	elem.style.position = 'absolute';
	set_x(id, x);
	set_y(id, y);
}

// Set height of a canvas element.
function set_height(id, h){
	var elem = document.getElementById(id);
	elem.setAttribute("height", h);
}

// Set width of a canvas element.
function set_width(id, w){
	var elem = document.getElementById(id);
	elem.setAttribute("width", w);
}

// Set x of a canvas element.
function set_x(id, x){
	var elem = document.getElementById(id);
	elem.style.left = x + 'px';
}

// Set y of a canvas element.
function set_y(id, y){
	var elem = document.getElementById(id);
	elem.style.top = y + 'px';
}

// Get coordinates of a canvas element.
function get_coords(id){
	return $("#" + id).position();
}

// Set image of a canvas element.
function set_src(id,img){
	var elem = document.getElementById(id);
	elem.src = '../img/' +img;
}

// Make an object move horizontally back and forth.
function back_and_forth(id,distance,x){
	var halfTime = 1500;

	setInterval(function(){
    $(id).stop(true,true).animate({left: distance}, halfTime,
          function(){
          	$(this).stop(true,true).animate({left: x}, halfTime);
    	  });
	}, halfTime*2);

}

function check_collision(id1, id2){
	// add extended safe zone based on difficulty
	var extra_width = 0;
	var diff = store.get("difficulty");

	if (diff<=0){
		extra_width=50;
	}
	else if (diff<=1){
		extra_width=25;
	}
	else{
		extra_width=0;
	}

 	var ax = get_pos(id1).x;
 	var ay = get_pos(id1).y;
 	var bx = get_pos(id2).x;
 	var by = get_pos(id2).y;

 	var width = $(id1).width() + extra_width;

 	return !(
        ((ay + $(id1).height()) < (by)) ||
        (ay > (by + $(id2).height())) ||
        ((ax + width) < bx) ||
        (ax > (bx + width))
    );
}

function get_pos(id){
	var offsets = $(id).offset();
	var top = offsets.top;
	var left = offsets.left;
	return{x:left,y:top};
}

function update_score(){
	$('#score').text('Score: ' + store.get("score"));
}

// Provide a brief flash of color to an element.
function flash_color(id,color1){
	$(id).stop().css("color", color1)
    .animate({ color: "#FFFFFF"}, 1200, function() {
    	$(id).stop().css("color", "#FFFFFF")
    	.animate({ color: color1}, 1200);
    });
}


function check_end(){

	// If the game is done,
	if (!store.get("update")){

		// Stop checking for end.
		clearInterval(checkEnd);

		// When the user clicks, redirect them to start.
		$(document).on({
		    'click.myevent': function () {
		    	restart_scratch('scratch1');
		       passages["Start"].render();

			    store.set("update",1);
	    		checkEnd = setInterval ( check_end, 500 );
	    		$(document).off('click.myevent', '.choice-point');
		    }
		}, '.choice-point');


	}
}
