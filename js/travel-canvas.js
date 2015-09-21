/*** MAIN CODE ****/
/*global $, store, change_scene, place_object, getRandomInt, set_src, startPassages, updatePassage, getRandomIntNoRepeat, getRandomInt */

var spawnCityInterval;
var spawnTimeInSeconds = 10;
var flashTime = 4;

var minCitiesOnItinerary = 3;
var maxCitiesOnItinerary = 3;

var numberOfTrips = 2;

$(document).ready(function(){
	startGame();
});

function changeArea(id, content) {
	document.getElementById(id).innerHTML = content;
}

function showTravelerStats() {
	changeArea("status", "<p id='status-header'>Emma's Current Status:</p><p><div class='statusItem'><span class='label'>Travel Funds</span><img src='../img/travel/money.png' width=30px>&nbsp;$"+ store.get('player_funds')+"</div><div class='statusItem'><span class='label'>Fame Level</span><img src='../img/travel/crown.png' width=30px>&nbsp;"+ store.get('player_fame')+"</div><div class='statusItem'><span class='label'>Carbon Footprint</span><img src='../img/travel/CO2.png' width=40px>&nbsp;"+ store.get('player_CO2')+"</div></p>");
}

function showHeader() {
	changeArea("scene-description-header", "Create an itinerary by accepting academic invitations.<p class='instructionDetail'>Hover over a city to see details of that offer. New offers will spawn every " + spawnTimeInSeconds + " seconds.</p>");
}

function showCityStats(cityEl) {
	changeArea("city-stats", "<p class='round'>"+cityEl.id.toUpperCase() + "&nbsp;<span class='glyphicon glyphicon-star' aria-hidden='true' style='color:orange'></span><br><span class='conference'>" + $("#"+cityEl.id).data("data").conference + "</span></p>" + "<ul class='round'><li class='moneyItem'>-$" + $("#"+cityEl.id).data("data").cost + "&nbsp;<img src='../img/travel/money.png' width=30px></li><li class='fameItem'>+"+$("#"+cityEl.id).data("data").fame+"&nbsp;<img src='../img/travel/crown.png' width=30px></li><li class='carbonItem'>+" + $("#"+cityEl.id).data("data").carbon + " tons <img src='../img/travel/CO2.png' width=50px></li></ul>");
}

function clearCityStats() {
	document.getElementById('city-stats').innerHTML = "";
}


function cancelButtonClick() {
	var lastLeg = cancelLatestLeg();
	$("#"+lastLeg.id).remove();
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
		tripSummary = "<span class='lineLabel'>Total Cost:</span> <span>$" + getItineraryCost() + "</span> <img src='../img/travel/money.png' width=21px><br><span class='lineLabel'>Fame Increase:</span> " + getItineraryFame() + " <img src='../img/travel/crown.png' width=21px><br><span class='lineLabel'>Carbon Impact:</span> " + getItineraryCarbon() + " <img src='../img/travel/CO2.png' width=25px><br><br>";
		if (itinerary.length < minCitiesOnItinerary) {
			var left = minCitiesOnItinerary - itinerary.length;
			var amountHint = "at least " + numToWritten(left);
			if (maxCitiesOnItinerary === minCitiesOnItinerary) {
				amountHint = numToWritten(left) + " more";
			}
			tripSummary += "<p id='cantBeginTrip'>Add " + amountHint + " destination" + (left !== 1 ? "s" : "") + " to complete your itinerary</p>";
		} else {
			tripSummary += "<p id='beginButton'><button id='beginTrip' onclick='beginTripClick();'>Begin Trip</button></p>";
		}
	} else {
		tripSummary = "<p id='cantBeginTrip'>No destinations scheduled yet.</p>";
	}

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
var coralTopics = ["Coral Reefs", "Marine Invertebrates", "the Australian Reefs"];


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
];

// Return a subset of "cities" excluding any city in the current itinerary.
function getValidCity() {
	var validCities = [];
	cities.forEach(function(city) {
		var ok = true;
		itinerary.forEach(function(destination) {
			if (destination.id === city.id) {
				ok = false;
			}
		});
		if (ok) {
			validCities.push(city);
		}
	});
	return validCities;
}

function place_random_city(){
	// Remove all previous tripOffers.
	$(".tripOffer").remove();
	clearCityStats();

	// Clear scene description and cursor.
	$(this).css('cursor','auto');

	// Choose new city.

	var validCities = getValidCity();

	if (validCities.length === 0) return;
	var pos = getRandomIntNoRepeat(1, validCities.length, "citySelection") - 1;
	var random_city = validCities[pos];
	place_object(random_city.id, "travel/star-2.png", random_city.x, random_city.y, 25, 25)

	var random_cost = getRandomInt(300,1200);
	var random_carbon = getRandomInt(0.1,5);
	var random_fame = getRandomInt(25,300);

	var d = document.getElementById(random_city.id);
	d.className = "tripOffer";
	var $city = $('#' + random_city.id);
	$city.addClass("cityStar").data('data', { location: random_city.id, cost: random_cost, carbon: random_carbon, fame: random_fame, conference: makeConferenceName()});

	// Set up to show expire warning.
	$("#city-stats").removeClass("expiring");
	setTimeout(function() {
		if ($city.hasClass("tripOffer")) {
			$city.addClass("expiring");
			$("#city-stats").addClass("expiring");
		}
	}, (spawnTimeInSeconds - flashTime) * 1000)

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
	$('.tripOffer').click(function(){
		if (itinerary.length < maxCitiesOnItinerary) {
			addTripLeg(this);
			showItinerary();
			$("#city-stats").removeClass("expiring");
			$(this).removeClass("expiring");
			$(this).off("click");
			$(this).addClass("tripItinerary");
			$(this).removeClass("tripOffer");
			set_src(this.id, "travel/starSelected.png");
			clearCityStats();
			if (itinerary.length >= maxCitiesOnItinerary) {
				stopCitySpawning();
			}
		}
	});
}

function startTrip() {
	// store.set("player_location",$("#"+this.id).data("data").location);
	store.set("player_funds",store.get("player_funds") - getItineraryCost());
	store.set("player_fame",store.get("player_fame") + getItineraryFame());
	var newCarbon = store.get("player_CO2") + getItineraryCarbon();
	newCarbon = Math.round(newCarbon*10)/10;
	store.set("player_CO2",newCarbon);
	store.set("current_fame",getItineraryFame());
	store.set("num_flights",store.get("num_flights")+1);

	$(".tripOffer, .tripItinerary").remove();

	stopCitySpawning();
	startPassages("newspaper.json","Start");
	$(".tripOffer").remove();
	change_scene("canvas", "travel/plane-flying.gif");

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

