/*** MAIN CODE ****/
/*global $, store, change_scene, place_object, getRandomInt, set_src, startPassages, updatePassage, getRandomIntNoRepeat */

var spawnCityInterval;
var spawnTimeInSeconds = 3;

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
	changeArea("scene-description-header", "Click on a city to travel there.<p class='instructionDetail'>Hover over a city to see details of that trip. New trips will spawn every " + spawnTimeInSeconds + " seconds.</p>");
}

function showCityStats(cityEl) {
	changeArea("city-stats", "<p class='round'>"+cityEl.id.toUpperCase() + "&nbsp;<span class='glyphicon glyphicon-star' aria-hidden='true' style='color:orange'></span></p>" + "<ul class='round'><li class='moneyItem'>-$" + $("#"+cityEl.id).data("data").cost + "&nbsp;<img src='../img/travel/money.png' width=30px></li><li class='fameItem'>+"+$("#"+cityEl.id).data("data").fame+"&nbsp;<img src='../img/travel/crown.png' width=30px></li><li class='carbonItem'>+" + $("#"+cityEl.id).data("data").carbon + " tons <img src='../img/travel/CO2.png' width=50px></li></ul>");
}

function clearCityStats() {
	document.getElementById('city-stats').innerHTML = "";
}


function cancelButtonClick() {
	var lastLeg = cancelLatestLeg();
	$("#"+lastLeg.id).remove();
	showItinerary();
}
function beginTripClick() {
	startTrip();
}


var itinerary = [];
function addTripLeg(el) {
	itinerary.push(el);
} 
function cancelLatestLeg() {
	if (itinerary.length > 0) {
		return itinerary.pop();
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

function showItinerary() {
	var destinationNames = itinerary.map(function(destination) {
		return destination.id;
	});
	var output = destinationNames.join(", ");
	var cancelButton = "<button class='cancelLeg' onclick='cancelButtonClick();'>x</button>"

	var tripSummary;
	if (itinerary.length > 0) {
		tripSummary = "Trip Cost: " + getItineraryCost() + "<br>Trip Fame: " + getItineraryFame() + "<br>Carbon Impact: " + getItineraryCarbon() + "<br><br>";
		if (itinerary.length < minCitiesOnItinerary) {
			var left = minCitiesOnItinerary - itinerary.length;
			tripSummary += "Add " + left + " more destination" + (left !== 1 ? "s" : "") + " to your itinerary";
		} else {
			tripSummary += "<button id='beginTrip' onclick='beginTripClick();'>Begin Trip</button>";
		}
	} else {
		tripSummary = "No destinations scheduled yet.";
	}

	changeArea("itinerary", "<p>" + output + cancelButton + "</p><p id='tripSummary'>" + tripSummary + "</p>");
}


function selectCity(){
	showHeader();
	showTravelerStats();
	document.getElementById('choice-points').innerHTML = ("<div class='choice-point'></div>");

	change_scene("canvas", "travel/europe-map.png");

	// Place cities.
	place_random_city();

	// Repeat process after a delay.
	spawnCityInterval = setInterval(place_random_city, spawnTimeInSeconds * 1000);

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
	$('#' + random_city.id).addClass("cityStar").data('data', { location: random_city.id, cost: random_cost, carbon: random_carbon, fame: random_fame});

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
			$(this).off("click");
			$(this).addClass("tripItinerary");
			$(this).removeClass("tripOffer");
			set_src(this.id, "travel/starSelected.png");
			clearCityStats();
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

	clearInterval(spawnCityInterval);
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
	document.getElementById('scene-description').innerHTML = "<div id='scene-description-header'></div><div id='status'></div><div id='city-stats'></div><div id='itinerary'></div>";	
}

function startGame(){
	writeGameFrame();
	itinerary = [];
	selectCity();
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
	change_scene("canvas", "conversation/scrubGame_chill_3.png");
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


