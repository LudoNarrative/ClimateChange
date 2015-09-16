/*** MAIN CODE ****/
/*global $, store, change_scene, place_object, getRandomInt, set_src, startPassages, updatePassage  */

var spawnCityInterval;
var spawnTimeInSeconds = 8;

$(document).ready(function(){
	startGame();
});

function changeArea(id, content) {
	document.getElementById(id).innerHTML = content;
}

function showHeader() {
	changeArea("scene-description-header", "Click on a city to travel there.<p class='instructionDetail'>Hover over a city to see details of that trip. New trips will spawn every " + spawnTimeInSeconds + " seconds.</p>");
	changeArea("status", "<p id='status-header'>Emma's Current Status:</p><p><div class='statusItem'><span class='label'>Travel Funds</span><img src='../img/travel/money.png' width=30px>&nbsp;$"+ store.get('player_funds')+"</div><div class='statusItem'><span class='label'>Fame Level</span><img src='../img/travel/crown.png' width=30px>&nbsp;"+ store.get('player_fame')+"</div><div class='statusItem'><span class='label'>Carbon Footprint</span><img src='../img/travel/CO2.png' width=40px>&nbsp;"+ store.get('player_CO2')+"</div></p>");
}

function showCityStats(cityEl) {
	changeArea("city-stats", "<p class='round'>"+cityEl.id.toUpperCase() + "&nbsp;<span class='glyphicon glyphicon-star' aria-hidden='true' style='color:orange'></span></p>" + "<ul class='round'><li class='moneyItem'>-$" + $("#"+cityEl.id).data("data").cost + "&nbsp;<img src='../img/travel/money.png' width=30px></li><li class='fameItem'>+"+$("#"+cityEl.id).data("data").fame+"&nbsp;<img src='../img/travel/crown.png' width=30px></li><li class='carbonItem'>+" + $("#"+cityEl.id).data("data").carbon + " tons <img src='../img/travel/CO2.png' width=50px></li></ul>");
}

function clearCityStats() {
	document.getElementById('city-stats').innerHTML = "";
}

function selectCity(){
	showHeader();
	document.getElementById('choice-points').innerHTML = ("<div class='choice-point'></div>");

	change_scene("canvas", "travel/europe-map.png");

	// Place cities.
	place_random_city();

	// Repeat process after a delay.
	spawnCityInterval = setInterval(place_random_city, spawnTimeInSeconds * 1000);

}

function place_random_city(){
	// Remove all previous nodes.
	$(".node").remove();
	clearCityStats();

	// Clear scene description and cursor.
	$(this).css('cursor','auto');

	// Choose new city.
	var cities = [{'id': 'Madrid', 	'x': 60, 'y':240},
								{'id': 'Paris', 	'x': 110, 'y':195},
								{'id': 'Berlin', 	'x': 170, 'y':170},
								{'id': 'Rome', 		'x': 165, 'y':240},
								{'id': 'Warsaw', 	'x': 210, 'y':170},
								{'id': 'Moscow', 	'x': 290, 'y':110},
					 		 ]

	var random_city = cities[Math.floor(Math.random() * cities.length)];

	place_object(random_city.id, "travel/star-2.png", random_city.x, random_city.y, 25, 25)

	var random_cost = getRandomInt(300,1200);
	var random_carbon = getRandomInt(0.1,5);
	var random_fame = getRandomInt(25,300);

	var d = document.getElementById(random_city.id);
	d.className = "node";
	$('#' + random_city.id).addClass("cityStar").data('data', { location: random_city.id, cost: random_cost, carbon: random_carbon, fame: random_fame});

	// On mouseover, show city stats.
	$('.node').mouseover(function(){
		showCityStats(this);
		set_src(this.id, "travel/star.png");
	}).mouseout(function(){
		clearCityStats();
	    set_src(this.id, "travel/star-2.png");
	});

	// On click, travel to that city.
	$('.node').click(function(){
		store.set("player_location",$("#"+this.id).data("data").location);
		store.set("player_funds",store.get("player_funds") - $("#"+this.id).data("data").cost);
		store.set("player_fame",store.get("player_fame") + $("#"+this.id).data("data").fame);
		store.set("player_CO2",store.get("player_CO2") + $("#"+this.id).data("data").carbon);
		store.set("current_fame",$("#"+this.id).data("data").fame);
		store.set("num_flights",store.get("num_flights")+1);

		clearInterval(spawnCityInterval);
		startPassages("newspaper.json","Start");
		$(".node").remove();
		change_scene("canvas", "travel/plane-flying.gif");

		// If user clicks, start reading article of their choice.
		$(document).on({
			    'click.myevent2': function () {
			      beginReading();
		    		$(document).off('click.myevent2', '.choice-point');
			    }
			}, '.choice-point');

	});
}

function startGame(){
	document.getElementById('scene-description').innerHTML = "<div id='scene-description-header'></div><div id='status'></div><div id='city-stats'></div>";
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
	changeArea("scene-description", "<p>You gained +" + store.get('current_fame') + " fame for attending the conference in " + store.get('player_location') + "!</p>");
	if (store.get("num_flights") < 2){
		changeArea("choice-points", "<div class='choice-point' onclick='startGame()'>Fly to your next conference.</div>");
	}
	else{
		changeArea("scene-description", "<p>Exhausted from traveling, you decide to fly home.</p>");

		// Stop updating passage.
		clearInterval(updatePassage);

		//Add choice point to point back to menu.
		changeArea("choice-points", "<a class='choice-point' href='../index.html'>End of Chapter Three.</a>");
	}

}


