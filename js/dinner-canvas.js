/*** MAIN CODE ****/

// Global Parameters
store.set("chapter",1);
plateInterval = null;

$(document).ready(function() {

	place_object('bg', 'dinner/background.png', 0, 70, 375, 540);
	place_object('plate', 'dinner/plate4.png', 103, 482, 168, 129);
	place_object('fork', 'dinner/fork.png', 247, 529, 50, 75);

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
	place_object('leftArrow', 'dinner/left.png', 8, 431, 37, 40);
	place_object('rightArrow', 'dinner/right.png', 330, 431, 37, 40);
	if (plateStatus !== 4) {
		place_object('downArrow', 'dinner/down.png', 165, 506, 25, 30);
	}
}
var removeArrows = function() {
	$("#leftArrow, #rightArrow, #downArrow").remove();
}

// Show the appropriate plate food image.
var updateFoodImage = function() {
	$("#plate").attr("src", "../img/dinner/plate" + plateStatus + ".png");
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
		place_object('dishCenter', 'dinner/dish1.png', x, y, rightDishCoords.w, rightDishCoords.h, 'dish');
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
		$("#dishCenter").stop(true, true).animate({top: centerDishCoords.y + 10}, 125, function() {
			$(this).animate({top: centerDishCoords.y}, 300);
		});
		// Plate is full.
	}
}

// Handle eating food (happens automatically on interval, only if there's food on plate.)
var eatFood = function() {
	if (plateStatus > 0) {
		plateStatus -= 1;
		$("#fork").animate({"top": 679}, 850, function() {
			updateFoodImage();
			$(this).animate({"top": 529}, 850);
		});
		
	}
}

// Handle adding a new dish to be passed on either the left or right.
var addDish = function(onRight) {
	var placeDish = function(dish, x, y, handler) {
		place_object(dish, 'dinner/dish1.png', x, y, rightDishCoords.w, rightDishCoords.h, 'dish');
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

	startPassages("dinner.json","Start");
}


function check_end(){
	// If the game is done,
	if (!store.get("update")){

		// Stop updating passage.
		clearInterval(updatePassage);

		//Add choice point to point back to menu.
		document.getElementById('choice-points').innerHTML = ("<a class='choice-point' href='../index.html'>End of Chapter One.</a>");

		// Update chapter.
		store.set("chapter",store.get("chapter")+1);

		clearInterval(plateInterval);
		clearInterval(checkEnd);
		store.set("dishesCritical", false);

  	$("#dishRight, #dishLeft, #dishCenter").remove();
  	removeArrows();
	}
}
