/*** MAIN CODE ****/

// Global Parameters
store.set("score",60);
store.set("required_percent",-1);
store.set("difficulty",1);
store.set("update",1); // tells the game to end when update is 0
checkEnd = null;

$(document).ready(function(){
	startTutorial();
});

function startTutorial(){
	// Set score at a scary place
	store.set("score",40);

	// Place the sweet spot in the scene.
	place_div('sweet-spot', 175,10,80,80, "#666");

	// Place the ball in the scene.
	place_object('ball','ball.png',175,10,80,80);
	$('#ball').hide();

	// Make the ball move to the left and right.
	back_and_forth('#ball',350,0,1500);

	// Once delay for movement has completed, show the ball.
	//setTimeout(function(){
   if (store.get("update")){
     $('#ball').show();
   }

  //}, 3000);

	// Check if ball in middle of target on click.
	$('#ball').click(function(e){
		e.preventDefault();
		checkCool();
	});
	$('#sweet-spot').click(function(e){
		e.preventDefault();
		checkCool();
	});
	$("#canvas").on("click", function(e) {
		e.preventDefault();
		checkCool();
	});



	lose_cool();
  loseCool = setInterval ( lose_cool, 1000 );


  // If user clicks...
	$(document).on({
		    'click.myevent2': function () {
		        startGame();
	    		$(document).off('click.myevent2', '.choice-point');
		    }
		}, '.choice-point');
}

function checkCool(){
	// console.log("check");
	// Only update score if game is in progress.
	if (store.get("update")==1){
		if (check_collision("#ball","#sweet-spot")){
			if (store.get("score")+50 < 60){
				store.set("score",store.get("score")+40);
			}
			else{
				store.set("score",60);

			}
		// console.log("green");
		flash_color("#sweet-spot","green", "background-color");
		}
		else{
			store.set("score",store.get("score")-25);
			flash_color("#sweet-spot","red", "background-color");
			// console.log("red");
		}
		update_score();
	}
}

function startGame(){
	passages["Start"].render();
	store.set("score",60);
	store.set("difficulty",1);
  setTimeout(function(){
   	check_end();
  	checkEnd = setInterval ( check_end, 500 );
  }, 2000);
}

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
	$('#canvas').css('background-image', 'url("img/'+image+'")');
}

function place_element(id,elType,x,y,w,h,params) {
	var elem = document.createElement(elType);

	elem.setAttribute("alt", id);
	elem.setAttribute("id", id);
	document.getElementById("canvas").appendChild(elem);
	set_height(id,h);
	set_width(id,w);
	if (params.img) {
		set_src(id,params.img);
	}
	if (params.color) {
		set_color(id, params.color);
	}

	elem.style.position = 'absolute';
	set_x(id, x);
	set_y(id, y);
}

// Place a generic object on the canvas.
function place_object(id,img,x,y,w,h){
	place_element(id, "img", x, y, w, h, {img: img});
}

// Place a div on the canvas.
function place_div(id,x,y,w,h,color){
	place_element(id, "div", x, y, w, h, {color: color});
}

// Set height of a canvas element.
function set_height(id, h){
	var elem = document.getElementById(id);
	elem.setAttribute("height", h);
	elem.style.height = h + "px";
}

// Set width of a canvas element.
function set_width(id, w){
	var elem = document.getElementById(id);
	elem.setAttribute("width", w);
	elem.style.width = w + "px";
}

// Set color of a canvas element.
function set_color(id, color){
	var elem = document.getElementById(id);
	elem.style["background-color"] = color;
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
	elem.src = 'img/' +img;
}

// Make an object move horizontally back and forth.
function back_and_forth(id,distance,x,halfTime){
	// var halfTime = 1500;

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
// Note: color animations won't work without jQueryUI or another plugin.
var flashLength = 500;
function flash_color(id,color1,param){
	var el = $(id);
	el.stop(true, true);
	var origColor = el.css(param);
	el.css(param, color1)
    .animate({ color: origColor}, flashLength, function() {
    	el.stop(true, true).css(param, origColor)
    	.animate({ color: color1}, flashLength);
    });
}

function lose_cool(){
	// Update stress image.
	var score = store.get("score");
	if (score > 40){
		set_src("stressface","teaching_chill.png");
	}
	else if (score > 20){
		set_src("stressface","teaching_neutral.png");
	}
	else if (score > 0){
		set_src("stressface","teaching_stressed.png");
	}
	else{
		set_src("stressface","teaching_ultrastressed.png");
	}

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
	// if (store.get("score") < 0){
	// 	flash_color("#score","red");
	// }

	// console.log(store.get("score"));

}

function check_end(){
	// If the score is super bad, end game early
	if (store.get("score") <= -25){
		store.set("update",0);
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
			// var coords = get_coords("ball");
			// place_object('explosion','the_bay_touch_once.gif',coords.left,coords.top-40,142,200);
		}

		// Hide the ball.
		$("#ball").hide();

		// Hide the target.
		$("#sweet-spot").hide();

		// When the user clicks, redirect them to start.
		$(document).on({
		    'click.myevent3': function () {
		        passages["Start"].render();
			    $("#ball").show();
			    $("#sweet-spot").show();
			    store.set("score",80);
			    update_score();
			    store.set("update",1);
			    loseCool = setInterval ( lose_cool, 1000 );
	    		checkEnd = setInterval ( check_end, 500 );
	    		$(document).off('click.myevent3', '.choice-point');
		    }
		}, '.choice-point');
	}
}

// Remove element of ID or class.  Works for modern browsers (not IE 7 and below).
Element.prototype.remove = function() {
    this.parentElement.removeChild(this);
}
NodeList.prototype.remove = HTMLCollection.prototype.remove = function() {
    for(var i = this.length - 1; i >= 0; i--) {
        if(this[i] && this[i].parentElement) {
            this[i].parentElement.removeChild(this[i]);
        }
    }
}
