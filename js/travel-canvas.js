/*** MAIN CODE ****/
/*global $, store, change_scene, place_object, getRandomInt, set_src, startPassages, updatePassage, getRandomIntNoRepeat, getRandomInt */

var spawnCityInterval;
var spawnTimeInSeconds = 5;
var citiesPersistInSeconds = 15;
var flashTime = 4;
var gameLengthInSeconds = 90;

var minCitiesOnItinerary = 3;
var maxCitiesOnItinerary = 3;

var numberOfTrips = 2;

var startingFunds = 15000;
var startingFame = 0;
var startingCarbon = 0;
var tripCostMin = 800;
var tripCostMax = 8000;
var minCarbonTons = 0.1;
var maxCarbonTons = 0.85; // "One round-trip flight from New York to Europe or to San Francisco creates a warming effect equivalent to 2 or 3 tons of carbon dioxide per person." http://www.nytimes.com/2013/01/27/sunday-review/the-biggest-carbon-sin-air-travel.html
var minFame = 10;
var maxFame = 300;


var gameTimer;
var gameTimerTimeout;

$(document).ready(function(){
	store.set("player_funds", startingFunds);
	store.set("player_fame", startingFame);
	store.set("player_CO2", startingCarbon);

	startGame();
});

function changeArea(id, content) {
	document.getElementById(id).innerHTML = content;
}

function showTravelerStats() {
	changeArea("status", "<p id='status-header'>Emma's Current Status:</p><p><div class='statusItem statusMoney'><span class='label'>Travel Funds</span><img src='../img/travel/money.png' width=30px>&nbsp;$"+ store.get('player_funds')+"</div><div class='statusItem'><span class='label'>Fame Level</span><img src='../img/travel/crown.png' width=30px>&nbsp;"+ store.get('player_fame')+"</div><div class='statusItem'><span class='label'>Carbon Footprint</span><img src='../img/travel/co2.png' width=40px>&nbsp;"+ store.get('player_CO2')+" lbs</div></p>");
}

function showHeader() {
	changeArea("scene-description-header", "Create the best itinerary you can before time's out.<p class='instructionDetail'>Hover over a city to see details of that speaking opportunity.");
}

function showCityStats(cityEl) {
	changeArea("city-stats", "<p class='round'>"+cityEl.id.toUpperCase() + "&nbsp;<span class='glyphicon glyphicon-star' aria-hidden='true' style='color:orange'></span><span id='isExpiringSoon'></span><br><span class='conference'>" + $("#"+cityEl.id).data("data").conference + "</span></p>" + "<ul class='round'><li class='moneyItem'>-$" + $("#"+cityEl.id).data("data").cost + "&nbsp;<img src='../img/travel/money.png' width=30px></li><li class='fameItem'>+"+$("#"+cityEl.id).data("data").fame+"&nbsp;<img src='../img/travel/crown.png' width=30px></li><li class='carbonItem'>+" + $("#"+cityEl.id).data("data").carbon + " lbs <img src='../img/travel/co2.png' width=50px></li></ul>");
	$("#city-stats").data("showing", cityEl.id);
}

function clearCityStats() {
	document.getElementById('city-stats').innerHTML = "";
	$("#city-stats").data("showing", "");
}


function cancelButtonClick() {
	var lastLeg = cancelLatestLeg();
	$("#"+(lastLeg.id)).remove();
	showItinerary();
	if (!spawnCityInterval) {
		startCitySpawning();
	}
}
function beginTripClick() {
	startTrip();
}

var itinerary = [];
function addTripLeg(el) {
	console.log("addTripLeg", el)
	itinerary.push(el);
	updateLines();
}
function cancelLatestLeg() {
	if (itinerary.length > 0) {
		var canceledCity = itinerary.pop();
		updateLines();
		return canceledCity;
	}
}
// Draw lines between cities on itinerary.
function updateLines() {
	clearCanvas();
	for (var i = 0; i < itinerary.length; i++) {
		if (i+1 < itinerary.length) {
			lineBetween(itinerary[i].id, itinerary[i+1].id);
		}
	}
}
function getItineraryFame() {
	return itinerary.reduce(function(prevVal, destination) {
		return prevVal + $("#"+destination.id).data("data").fame;
	}, 0);
}
function getItineraryCost() {
	return itinerary.reduce(function(prevVal, destination) {
		return prevVal + $("#"+destination.id).data("data").cost;
	}, 0);
}
function getItineraryCarbon() {
	var carbon = itinerary.reduce(function(prevVal, destination) {
		return prevVal + $("#"+destination.id).data("data").carbon;
	}, 0);
	return Math.round(carbon*10)/10;
}

var writtenForms = [null, "one", "two", "three", "four", "five", "six", "seven", "eight", "nine"];
function numToWritten(num) {
	if (writtenForms[num]) {
		return writtenForms[num];
	}
	return num;
}


function showItinerary() {
	var destinationNames = itinerary.map(function(destination) {
		return destination.id;
	});
	var cancelButton = "<button class='cancelLeg' onclick='cancelButtonClick();'>x</button>"
	var cityList = "";
	if (itinerary.length > 0) {
		cityList = "<p><span class='lineLabel'>Visiting:</span> " + destinationNames.join(", ") + cancelButton + "</p>";
	}

	var tripSummary;
	if (itinerary.length > 0) {
		tripSummary = "<span class='lineLabel'>Total Cost:</span> <span>$" + getItineraryCost() + "</span> <img src='../img/travel/money.png' width=21px><br><span class='lineLabel'>Fame Increase:</span> " + getItineraryFame() + " <img src='../img/travel/crown.png' width=21px><br><span class='lineLabel'>Carbon Impact:</span> " + getItineraryCarbon() + " lbs <img src='../img/travel/co2.png' width=25px><br><br>";
		if (itinerary.length < minCitiesOnItinerary) {
			var left = minCitiesOnItinerary - itinerary.length;
			var amountHint = "at least " + numToWritten(left);
			if (maxCitiesOnItinerary === minCitiesOnItinerary) {
				amountHint = numToWritten(left) + " more";
			}
			tripSummary += "<p id='cantBeginTrip'>Add " + amountHint + " destination" + (left !== 1 ? "s" : "") + " to complete your itinerary, or:</p>";
		}
	} else {
		tripSummary = "<p id='cantBeginTrip'>No destinations scheduled yet.</p>";
	}
	tripSummary += "<p id='beginButton'><button id='beginTrip' onclick='beginTripClick();'>Begin Trip</button></p>";
	tripSummary += "<p style='font-size:80%;text-align:center'><span id='gameTimer'>" + gameLengthInSeconds + "</span> seconds left to confirm this trip.</p>";

	changeArea("itinerary", "<div id='itineraryArea'><p id='itineraryHeader'>Itinerary</p>" + cityList + "<p>" + tripSummary + "</p></div>");
}


function startCitySpawning() {
	spawnCityInterval = setInterval(place_random_city, spawnTimeInSeconds * 1000);
	setTimeout(function() {
		place_random_city();
	}, 1000);
}
function stopCitySpawning() {
	clearInterval(spawnCityInterval);
	$(".tripOffer").remove();
	spawnCityInterval = null;
}

var jobTitle = ["Keynote Address", "Director", "Opening Keynote", "Plenary Address", "Closing Address", "Workshop Coordinator", "Visionary Research Award", "Featured Speaker"];
var eventTitles = ["Conference", "Symposium", "Workshop", "Seminar", "Congress", "Summit"];
var eventPrefixes = ["International", "European", "Interdisciplinary", "National", "Decadal", "Biennial", "Annual"];
var ordinal = ["First", "Second", "Third", "Fourth", "Fifth", "Sixth", "Seventh", "Eighth", "Ninth", "Tenth", "Twelfth", "Fifteenth", "Twenty-Third", "Twenty-Fifth"];
var topicPrefixes = ["the Future of", "the State of", "the Development of", "Sustainable"];
var generalTopics = ["Oceanography", "Marine Sciences", "Biodiversity", "Climate Change", "Aquaculture", "Ecological and Life Sciences", "Ecosystems in Crisis", "Fisheries"];
var shrimpTopics = ["Shrimp", "Shrimp", "Decapod Crustaceans", "Crustaceans and Molluscs"];
var lobsterTopics = ["Lobster", "Crustaceans", "Decapoda", "Marine Arthropods"];
var coralTopics = ["Coral Reefs", "Marine Invertebrates", "Australian Reefs"];


function makeConferenceName() {
	var oneOf = function(arr) {
		return arr[getRandomInt(1, arr.length)-1];
	}
	var title = oneOf(jobTitle) + ", ";
	if (getRandomInt(1, 100) > 33) {
		title += oneOf(ordinal) + " ";
	}
	if (getRandomInt(1, 100) > 50) {
		title += oneOf(eventPrefixes) + " ";
	}
	title += oneOf(eventTitles) + " on ";
	if (getRandomInt(1, 100) > 66) {
		title += oneOf(topicPrefixes) + " ";
	}
	if (getRandomInt(1, 100) > 50) {
		var career = store.get("career");
		if (career === 0) {
			title += oneOf(shrimpTopics) + " ";
		} else if (career === 1) {
			title += oneOf(lobsterTopics) + " ";
		} else {
			title += oneOf(coralTopics) + " ";
		}
	} else {
		title += oneOf(generalTopics);
	}
	return title;
}

var cities = [{'id': 'Madrid', 	'x': 60, 'y':240},
			  {'id': 'Paris', 	'x': 110, 'y':195},
			  {'id': 'Berlin', 	'x': 170, 'y':170},
			  {'id': 'Rome', 	'x': 165, 'y':240},
			  {'id': 'Warsaw', 	'x': 210, 'y':170},
			  {'id': 'Moscow', 	'x': 290, 'y':110},
			  {'id': 'Reykjavík', 'x': 60, 'y':40},
			  {'id': 'London', 'x': 103, 'y':160}
];

// Return a subset of "cities" excluding any city in the current itinerary, or currently on the map.
function getValidCities() {
	var validCities = [];
	cities.forEach(function(city) {
		var ok = true;
		itinerary.forEach(function(destination) {
			if (destination.id === city.id) {
				ok = false;
			}
			if ($("#"+city.id).length > 0) {
				ok = false;
			}
		});
		if (ok) {
			validCities.push(city);
		}
	});
	return validCities;
}

function notEnoughFunds() {
	$(".statusMoney").removeClass("notEnoughMoney");
	setTimeout(function() {
		$(".statusMoney").addClass("notEnoughMoney");
	}, 0); // timeout is necessary to trigger css redraw
}

function place_random_city(){
	// clearCityStats();

	// Clear scene description and cursor.
	$(this).css('cursor','auto');

	// Choose new city.

	var validCities = getValidCities();

	if (validCities.length === 0) return;
	var pos = getRandomIntNoRepeat(1, validCities.length, "citySelection") - 1;
	var random_city = validCities[pos];

	// Don't place the same city twice.
	if ($("#"+random_city.id).length > 0) {
		return;
	}

	place_object(random_city.id, "travel/star-2.png", random_city.x, random_city.y, 25, 25)
	var $city = $('#' + random_city.id);
	$city.addClass("placedCity");

	var random_cost = getRandomInt(tripCostMin/100, tripCostMax/100) * 100;
	var carbon;
	var approxMaxDistanceInPixels = 300;
	if (itinerary.length > 0) {
		var lastCity = $("#"+itinerary[itinerary.length-1].id);
		carbon = calcDist($city, lastCity);
		carbon = carbon / (approxMaxDistanceInPixels / maxCarbonTons); // scale
		carbon = Math.round(carbon * 100) * 10; // round to 1 decimal place
	} else {
		carbon = Math.round(getRandomInt(minCarbonTons*100, (maxCarbonTons/2)*100)) * 10;
	}
	var random_fame = getRandomInt(minFame, maxFame);

	var d = document.getElementById(random_city.id);
	d.className = "tripOffer";
	$city.addClass("cityStar placedCity").data('data', { location: random_city.id, cost: random_cost, carbon: carbon, fame: random_fame, conference: makeConferenceName()});

	// Set up to show expire warning and removal.
	setTimeout(function() {
		if ($city.hasClass("tripOffer")) {
			$city.addClass("expiring");
		}
	}, (citiesPersistInSeconds - flashTime) * 1000);

	setTimeout(function() {
		if ($city.hasClass("tripOffer")) {
			$city.remove();
			console.log("'" + $("#city-stats").data("showing") + "', '" + random_city.id + "'");
			if ($("#city-stats").data("showing") === random_city.id) {
				clearCityStats();
			}
		}

	}, citiesPersistInSeconds * 1000);

	// On mouseover, show city stats.
	$('.tripOffer').mouseover(function(){
		showCityStats(this);
		if ($(this).hasClass("tripOffer")) {
			set_src(this.id, "travel/star.png");
		}
	}).mouseout(function(){
		clearCityStats();
		if ($(this).hasClass("tripOffer")) {
		    set_src(this.id, "travel/star-2.png");
		}
	});

	// On click, add city to itinerary.
	$('.tripOffer').off("click").click(function(){
		console.log("store.get('player_funds')", store.get('player_funds'));
		console.log("getItineraryCost()", getItineraryCost());
		if (store.get('player_funds') - getItineraryCost() - $(this).data("data").cost < 0) {
			notEnoughFunds();
		} else if (itinerary.length < maxCitiesOnItinerary) {
			addTripLeg(this);
			showItinerary();
			$("#city-stats").removeClass("expiring");
			$(this).removeClass("expiring");
			$(this).off("click");
			$(this).addClass("tripItinerary");
			$(this).removeClass("tripOffer");
			set_src(this.id, "travel/starSelected.png");
			clearCityStats();

			// Now that we've added, if we've exceeded, stop spawning.
			if (itinerary.length >= maxCitiesOnItinerary) {
				stopCitySpawning();
			}
		}
	});
}

function startTrip() {
	// store.set("player_location",$("#"+this.id).data("data").location);
	clearInterval(gameTimerTimeout);
	store.set("player_funds",store.get("player_funds") - getItineraryCost());
	store.set("player_fame",store.get("player_fame") + getItineraryFame());
	var newCarbon = store.get("player_CO2") + getItineraryCarbon();
	newCarbon = Math.round(newCarbon*10)/10;
	store.set("player_CO2",newCarbon);
	store.set("current_fame",getItineraryFame());
	store.set("num_flights",store.get("num_flights")+1);
	clearCanvas();

	$(".tripOffer, .tripItinerary, .placedCity").remove();
	$("#gameTimer").removeClass("expiring");

	stopCitySpawning();
	startPassages("newspaper.json","Start");
	$(".tripOffer").remove();
	change_scene("canvas", "travel/plane-flying.png");

	// If user clicks, start reading article of their choice.
	$(document).on({
		    'click.myevent2': function () {
		      beginReading();
	    		$(document).off('click.myevent2', '.choice-point');
		    }
		}, '.choice-point');
}

function writeGameFrame() {
	document.getElementById('scene-description').innerHTML = "<div id='scene-description-header'></div><div id='status'></div><div id='itinerary'></div>";
}

function startGame(){
	writeGameFrame();
	itinerary = [];
	showHeader();
	showTravelerStats();
	document.getElementById('choice-points').innerHTML = ("<div class='choice-point'></div>");

	change_scene("canvas", "travel/europe-map.png");

	// Repeat process after a delay.
	startCitySpawning();
	showItinerary();
	gameTimer = gameLengthInSeconds;
	gameTick();
}

function gameTick() {
	gameTimer -= 1;
	$("#gameTimer").html(gameTimer);
	if (gameTimer > 0 && gameTimer < 10) {
		$("#gameTimer").addClass("expiring");
	}
	if (gameTimer <= 0) {
		outOfTime();
	} else {
		gameTimerTimeout = setTimeout(function(){
			gameTick();
		}, 1000);
	}
}

function outOfTime() {
	// alert("Out of time!");
	startTrip();
}

function beginReading() {
	// If user clicks, check if all articles have been read.
		$(document).on({
			    'click.myevent3': function () {
			      checkArticlesRead();
			    }
			}, '.choice-point');
}

function checkArticlesRead(){
	if ((store.get("readFood")||store.get("readAirport")||store.get("readSpecies")||store.get("readRefugees"))&&store.get("reading")===0){
		$(document).off('click.myevent3', '.choice-point');
		endReading();
	}
}

function endReading(){
	clearInterval(updatePassage);
	change_scene("canvas", "travel/emmaRelaxed.jpg");
	$("#progress-bar").hide();
	// passages["End"].render();
	writeGameFrame();
	changeArea("scene-description-header", "<p>You gained +" + store.get('current_fame') + " fame on that trip!</p>");
	if (store.get("num_flights") < numberOfTrips){
		changeArea("choice-points", "<div class='choice-point' onclick='startGame()'>Plan your next trip.</div>");
	}
	else{
		changeArea("scene-description-header", "<p>Exhausted from traveling, you decide to fly home.</p>");
		showTravelerStats();

		// Stop updating passage.
		clearInterval(updatePassage);

		//Add choice point to point back to menu.
		changeArea("choice-points", "<a class='choice-point' href='../index.html'>End of Chapter Three.</a>");
	}

}

/* LINE DRAWING */

var canvas = $("#svgCanvas")[0]; // Assumes an element with id "canvas" in DOM
var ctx = canvas.getContext("2d");
var defaultLineColor = "#65e348";
var defaultLineWidth = 3;

var line = function(fromX, fromY, toX, toY, params) {
	params = params || {}; // If params is undefined, make empty object
	ctx.strokeStyle = params.color ? params.color : defaultLineColor;
	ctx.lineWidth = params.width ? params.width : defaultLineWidth;
	ctx.beginPath();
	ctx.moveTo(fromX, fromY);
	ctx.lineTo(toX, toY);
	ctx.closePath();
	ctx.stroke();
}

// Only works on jQuery objects.
function calcDist(point1, point2) {
	var pos1 = point1.offset();
	var pos2 = point2.offset();
	var x = pos2.left - pos1.left;
	var y = pos2.top - pos1.top;
	var dist = Math.sqrt(x*x + y*y);
	return dist;
}


// Draw a line between two points, specified as either IDs or jQuery objects.
var lineBetween = function(id1, id2, params) {
	var dom1 = id1;

	if (typeof id1 === "string") {
		dom1 = $("#"+id1);
	}
	var dom2 = id2;
	if (typeof id2 === "string") {
		dom2 = $("#"+id2);
	}

	var pos1 = dom1.offset();
	var pos2 = dom2.offset();
	var x1 = pos1.left + (dom1.width() / 2);
	var y1 = pos1.top + (dom1.height() / 2);
	var x2 = pos2.left + (dom2.width() / 2);
	var y2 = pos2.top + (dom2.height() / 2);

	line(x1, y1, x2, y2, params);
}

var clearCanvas = function() {
	ctx.clearRect(0, 0, canvas.width, canvas.height);
}

