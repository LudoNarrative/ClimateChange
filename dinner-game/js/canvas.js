/*** MAIN CODE ****/

// Global Parameters
store.set("score",60);
store.set("required_percent",-1);
store.set("difficulty",1);
store.set("update",1); // tells the game to end when update is 0
checkEnd = null;
plateInterval = null;

$(document).ready(function() {

	place_object('bg', 'background.png', 0, 70, 375, 540);
	place_object('plate', 'plate4.png', 103, 482, 168, 129);

	place_div('leftZone', 0, 70, 78, 540, {z: 999});
	$("#leftZone").click(leftSideClick);
	place_div('centerZone', 78, 70, 212, 540, {z: 999});
	$("#centerZone").click(downClick);
	place_div('rightZone', 290, 70, 85, 540, {z: 999});
	$("#rightZone").click(rightSideClick);

	// This is a gross hack to clip the half-offscreen dishes to the background: put two black boxes with higher z-index on top of where the offscreen portion of the dishes show up.
	place_div('leftClip', -190, 384, 190, 180, {z: 1000, color: "black"});
	place_div('rightClip', 375, 384, 190, 180, {z: 1000, color: "black"});


	startGame();

})



/* DINNER GAME CODE */

var plateStatus = 4; // 0 (empty) to 4 (full)
var maxPlate = 4;

var leftSide = 0; // 0 = empty, 1 = dish waiting, 2 = impatient dish waiting
var rightSide = 0;
var center = 0; // 0 = nothing, -1: left-bound dish, 1: right-bound dish
var takenFromThisDish;
var leftDishCoords = { x: -78, y: 489, w: 116, h: 60 };
var rightDishCoords = { x: 335, y: 489, w: 116, h: 60 };
var centerDishCoords = { x: 60, y: 390, w: 238, h: 120 };

// Show and hide the direction arrows when you're holding a dish.
var showArrows = function() {
	place_object('leftArrow', 'left.png', 8, 431, 37, 40);
	place_object('rightArrow', 'right.png', 330, 431, 37, 40);
	place_object('downArrow', 'down.png', 165, 506, 25, 30);
}
var removeArrows = function() {
	$("#leftArrow, #rightArrow, #downArrow").remove();
}

// Show the appropriate plate food image.
var updateFoodImage = function() {
	$("#plate").attr("src", "../img/plate" + plateStatus + ".png");
}


// Handle trying to pass a dish left or right (must pass it to the opposite side it came in from.)
var passDish = function(passingRight) {
	var passDishAnim = function(left) {
		$("#dishCenter").stop(true, true).animate({left: left, top: rightDishCoords.y - 75, width: rightDishCoords.w, height: rightDishCoords.h}, 750, function() {
			$(this).remove();
		});
		center = 0;
		removeArrows();
	}
	var dishWrongWayAnim = function(left) {
		$("#dishCenter").stop(true, true).animate({left: left}, 100, function() {
			$(this).animate({left: centerDishCoords.x}, 500);
		});
	}
	if (passingRight && center === 1) {
		passDishAnim(rightDishCoords.x + 110);
	} else if (!passingRight && center === -1) {
		passDishAnim(leftDishCoords.x - 110);
	} else {
		if (passingRight) {
			dishWrongWayAnim(centerDishCoords.x + 30);
		} else {
			dishWrongWayAnim(centerDishCoords.x - 30);
		}
	}
}

// Handle taking a dish from a side and showing the arrows.
var takeDish = function(fromRight) {
	takenFromThisDish = false;
	store.set("dishesCritical", false);
	var dishAnim = function(old, x, y) {
		$("#" + old).remove();
		place_object('dishCenter', 'dish1.png', x, y, rightDishCoords.w, rightDishCoords.h, 'dish');
		$("#dishCenter").animate({left: centerDishCoords.x, top: centerDishCoords.y, width: centerDishCoords.w, height: centerDishCoords.h}, 1000, showArrows);
	}
	if (fromRight) {
		center = -1;
		rightSide = 0;
		dishAnim("dishRight", rightDishCoords.x, rightDishCoords.y);
	} else {
		center = 1;
		leftSide = 0;
		dishAnim("dishLeft", leftDishCoords.x, leftDishCoords.y);
	}
}

// Handle trying to take food from the dish you're holding (plate must have room to succeed.)
var takeFood = function() {
	if (plateStatus < maxPlate) {
		plateStatus += 1;
		takenFromThisDish = true;
		updateFoodImage();
		$("#downArrow").remove();
	} else {
		// Plate is full.
	}
}

// Handle eating food (happens automatically on interval, only if there's food on plate.)
var eatFood = function() {
	if (plateStatus > 0) {
		plateStatus -= 1;
		updateFoodImage();
	}	
}

// Handle adding a new dish to be passed on either the left or right.
var addDish = function(onRight) {
	var placeDish = function(dish, x, y, handler) {
		place_object(dish, 'dish1.png', x, y, rightDishCoords.w, rightDishCoords.h, 'dish');
	}
	if (onRight) {
		rightSide = 1;
		placeDish("dishRight", rightDishCoords.x, rightDishCoords.y, rightSideClick);
	} else {
		leftSide = 1;
		placeDish("dishLeft", leftDishCoords.x, leftDishCoords.y, leftSideClick);
	}
}

// Handle escalating a dish to be impatient.
var makeDishImpatient = function(onRight) {
	if (onRight) {
		rightSide = 2;
		$("#dishRight").addClass("impatient");
	} else {
		leftSide = 2;
		$("#dishLeft").addClass("impatient");
	}
	// If both dishes impatient, note in the store.
	if (rightSide === 2 && leftSide === 2) {
		store.set("dishesCritical", true);
	}
}

// Handle clicking on the left, center, or right.
var rightSideClick = function() {
	// If we've got a dish, try to pass it right.
	if (center !== 0) {
		passDish(true);
	// Otherwise if a dish is waiting on the right, take it.
	} else if (rightSide !== 0) {
		takeDish(true);
	}
}
var leftSideClick = function() {
	// If we've got a dish, try to pass it left.
	if (center !== 0) {
		passDish(false);
	// Otherwise if a dish is waiting on the left, take it.
	} else if (leftSide !== 0) {
		takeDish(false);
	}
}
var downClick = function() {
	// If we've got a dish and haven't taken food yet, try to take.
	if (center !== 0 && !takenFromThisDish) {
		takeFood();
	}
}


// Dinner scene intervals.

var eatCounter = 0;
var eatEveryNSeconds = 10;
var percentChancePerSecondOfDish = 20;

// Called on loop while scene is active. (Should be once per seccond for variables above to be accurate.)
var plate_loop = function() {

	// Handle a dish appearing or escalating.
	if (getRandomInt(1, 100) < percentChancePerSecondOfDish) {
		if (getRandomInt(1, 100) > 50) {
			// dish on right
			if (rightSide === 0) {
				// dish appears
				addDish(true);
			} else if (rightSide === 1) {
				// dish becomes impatient
				makeDishImpatient(true);
			}  
		} else {
			// dish on left
			if (leftSide === 0) {
				// dish appears
				addDish(false);
			} else if (leftSide === 1) {
				// dish becomes impatient
				makeDishImpatient(false);
			}  
		}
	}

	// Eat food every so often when hands are free.
	eatCounter += 1;
	if (eatCounter % eatEveryNSeconds === 0 && center === 0) {
		eatFood();
	}
}


/* END DINNER GAME CODE */


function startGame(){

	plateStatus = 4; // 0 (empty) to 4 (full)
	maxPlate = 4;

	leftSide = 0; // 0 = empty, 1 = dish waiting, 2 = impatient dish waiting
	rightSide = 0;
	center = 0; // 0 = nothing, -1: left-bound dish, 1: right-bound dish

	takenFromThisDish = false;
	updateFoodImage();

	plateInterval = setInterval(plate_loop, 1000);
	store.set("dishesCritical", false);

	checkEnd = setInterval( check_end, 500 );

	passages["Start"].render();
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
	$('#canvas').css('background-image', 'url("../img/'+image+'")');
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
	if (params.objClass) {
		elem.classList.add(params.objClass);
	}
	if (params.z) {
		set_zindex(id, params.z);
	}

	elem.style.position = 'absolute';
	set_x(id, x);
	set_y(id, y);
}

// Place a generic object on the canvas.
function place_object(id,img,x,y,w,h, objClass){
	place_element(id, "img", x, y, w, h, {img: img, objClass: objClass});
}

// Place a div on the canvas.
function place_div(id,x,y,w,h, params){
	params = params || {};
	place_element(id, "div", x, y, w, h, params);
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

function set_zindex(id, z){
	console.log("!", id, z);
	var elem = document.getElementById(id);
	elem.style["z-index"] = z;
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


function check_end(){
	// If the game is done,
	if (!store.get("update")){

		clearInterval(plateInterval);
		clearInterval(checkEnd);
		store.set("dishesCritical", false);

    	$("#dishRight, #dishLeft, #dishCenter").remove();
    	removeArrows();

		// When the user clicks, redirect them to start.
		$(document).on({
		    'click.myevent3': function () {
		    	store.set("update",1);
	    		$(document).off('click.myevent3', '.choice-point');
		    	startGame();
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
