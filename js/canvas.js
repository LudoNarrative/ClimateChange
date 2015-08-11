/*** MAIN CODE ****/

// Global Parameters
store.set("score",60);
store.set("difficulty",1);
store.set("update",1); // tells the game to end when update is 0

$(document).ready(function(){
	// Place the sweet spot in the scene.
	place_object('sweet-spot','sweet-spot.png',200,100,100,100);

	// Place the ball in the scene.
	place_object('ball','red-glossy-orb.png',200,100,100,100);

	// Make the ball move to the left and right.
	back_and_forth('#ball',400,0);

	// Check if spacebar pressed.
	$(window).keypress(function(e) {
  		if (e.keyCode === 0 || e.keyCode === 32) {
  			// Only update score if game is in progress.
  			if (store.get("update")==1){
  				if (check_collision("#ball","#sweet-spot")){
  					if (store.get("score")+50 < 60){
  						store.set("score",store.get("score")+40);
  					}
  					else{
  						store.set("score",60);
  					}

						flash_color("#score","green");
				}
				else{
					store.set("score",store.get("score")-25);
					flash_color("#score","red");
				}
				update_score();
  			}
  		}
	});

	lose_cool();
    loseCool = setInterval ( lose_cool, 1000 );

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

function lose_cool(){
	// Determine how much cool is lost based on difficulty level.
	var losecool = 0;
	var diff = store.get("difficulty");

	if (diff<=0){
		store.set("difficulty",0);
		losecool=1;
	}
	else if (diff <=1){
		losecool=5;
	}
	else{
		store.set("difficulty",2);
		losecool=15;
	}

	// Update score.
	store.set("score",store.get("score")-losecool);
	update_score();

	// If the score is bad, change its color to red.
	if (store.get("score") < 0){
		flash_color("#score","red");
	}

	// If the score is super bad, end game early
	if (store.get("score") <= -25){
		store.set("update",0);
	}
}

function check_end(){
	var score = store.get("score");

	// Update stress image.
	if (score > 40){
		set_src("stressface","stress-1.png");
	}
	else if (score > 20){
		set_src("stressface","stress-2.png");
	}
	else if (score > 0){
		set_src("stressface","stress-3.png");
	}
	else{
		set_src("stressface","stress-4.png");
	}

	// If the game is done,
	if (!store.get("update")){

		// Stop changing score.
		clearInterval(loseCool);

		// Stop checking for end.
		clearInterval(checkEnd);

		// Render the fail screen if score was bad.
		if (store.get("score") <= -25){
			passages["fail"].render();
		}
		else{
			// Render the good ending.
			passages["ClassEnds"].render();

			// Make the ball "explode" (show explosion gif and then hide ball).
			var coords = get_coords("ball");
			place_object('explosion','the_bay_touch_once.gif',coords.left,coords.top-40,142,200);
		}

		// Hide the ball.
		$("#ball").hide();

		// When the user clicks, redirect them to start.
		$(document).on({
		    'click.myevent': function () {
		        passages["Start"].render();
			    $("#ball").show();
			    store.set("score",0);
			    update_score();
			    store.set("update",1);
			    loseCool = setInterval ( lose_cool, 1000 );
	    		checkEnd = setInterval ( check_end, 500 );
	    		$(document).off('click.myevent', '.choice-point');
		    }
		}, '.choice-point');


	}
}
