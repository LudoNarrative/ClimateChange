/*** MAIN CODE ****/

// Global Parameters
store.set("score",60);
store.set("required_percent",-1);
store.set("difficulty",1);
store.set("update",1); // tells the game to end when update is 0
store.set("reading",0);
checkEnd = null;

$(document).ready(function(){
	document.getElementById('scene-description').innerHTML = ("Click on a city to travel there.");

	change_scene("canvas", "europe-map.jpg");

	place_object("MADRID", "node.png",60,240,25,25);
	var d = document.getElementById("MADRID");
	d.className = "node";
	$('#MADRID').data('data', { cost: '692', carbon:'0.58'});

	place_object("PARIS", "node.png",110,195,25,25);
	var d = document.getElementById("PARIS");
	d.className = "node";
	$('#PARIS').data('data', { cost: '741', carbon:'1.32'});


	place_object("BERLIN", "node.png",170,170,25,25);
	var d = document.getElementById("BERLIN");
	d.className = "node";
	$('#BERLIN').data('data', { cost: '733', carbon:'1.34'});

	$('.node').mouseover(function(){
		$(this).animate({
	    width: "30px",
	    height: "30px"
	  }, 100 );
		document.getElementById('scene-description').innerHTML = ("<p>Click on a city to travel there.</p><b>"+this.id + ":</b>" + "<ul><li>$" + $("#"+this.id).data("data").cost + "</li><li>" + $("#"+this.id).data("data").carbon + " tons CO<sub>2</sub></li></ul>");
		$(this).css('cursor','pointer');
	}).mouseout(function(){
		$(this).animate({
	    width: "25px",
	    height: "25px"
	  }, 100 );
	  document.getElementById('scene-description').innerHTML = ("Click on a city to travel there.");
	  $(this).css('cursor','auto');
	});

	$('.node').click(function(){
		passages["Start"].render();
		$(".node").remove();
		change_scene("canvas", "plane-flying.gif");

		// If user clicks, start reading / flying game.
		$(document).on({
			    'click.myevent2': function () {
			        startGame();
		    		$(document).off('click.myevent2', '.choice-point');
			    }
			}, '.choice-point');

	});

});


function startGame(){
	// If user clicks, check if all articles have been read.
		$(document).on({
			    'click.myevent3': function () {
			      checkArticlesRead();
			    }
			}, '.choice-point');

}

function checkArticlesRead(){
	if (store.get("readFood")&&store.get("readAirport")&&store.get("readSpecies")&&store.get("readRefugees")&&store.get("reading")==0){
		$(document).off('click.myevent3', '.choice-point');
		endGame();
	}
}

function endGame(){
	change_scene("canvas", "runway.jpg");
	$("#progress-bar").hide();
	passages["End"].render();
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

// Change the background image of a canvas.
function change_scene(canvasID, image){
	$('#'+canvasID).css('background-image', 'url("../img/'+image+'")');
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
	elem.src = '../img/' +img;
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
