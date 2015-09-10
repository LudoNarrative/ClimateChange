/*** MAIN CODE ****/

$(document).ready(function(){

	selectCity();
});

function selectCity(){
	document.getElementById('scene-description').innerHTML = ("Click on a city to travel there.<p><i style='color:grey;font-size:16px;'>New offers will spawn every 8 seconds.</i></p><p><span style='margin:10px'><img src='../img/travel/money.png' width=30px>&nbsp;$"+ store.get('player_funds')+"</span><span style='margin:10px'><img src='../img/travel/crown.png' width=30px>&nbsp;"+ store.get('player_fame')+"</span><span style='margin:10px'><img src='../img/travel/CO2.png' width=40px>&nbsp;"+ store.get('player_CO2')+"</span></p>");
	document.getElementById('choice-points').innerHTML = ("<div class='choice-point'></div>");

	change_scene("canvas", "travel/europe-map.png");

	// Place cities.
	place_random_city();

	// Repeat process after a delay.
	spawnCity = setInterval(place_random_city, 8000);

}

function place_random_city(){
	// Remove all previous nodes.
	$(".node").remove();

	// Clear scene description and cursor.
	document.getElementById('scene-description').innerHTML = ("Click on a city to travel there.<p><i style='color:grey;font-size:16px;'>New offers will spawn every 8 seconds.</i></p><p><span style='margin:10px'><img src='../img/travel/money.png' width=30px>&nbsp;$"+ store.get('player_funds')+"</span><span style='margin:10px'><img src='../img/travel/crown.png' width=30px>&nbsp;"+ store.get('player_fame')+"</span><span style='margin:10px'><img src='../img/travel/CO2.png' width=40px>&nbsp;"+ store.get('player_CO2')+"</span></p>");
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
	$('#' + random_city.id).data('data', { location: random_city.id, cost: random_cost, carbon: random_carbon, fame: random_fame});

	// On mouseover, show city stats.
	$('.node').mouseover(function(){
		document.getElementById('scene-description').innerHTML = ("Click on a city to travel there.<p><i style='color:grey;font-size:16px;'>New offers will spawn every 8 seconds.</i></p><p><span style='margin:10px'><img src='../img/travel/money.png' width=30px>&nbsp;$"+ store.get('player_funds')+"</span><span style='margin:10px'><img src='../img/travel/crown.png' width=30px>&nbsp;"+ store.get('player_fame')+"</span><span style='margin:10px'><img src='../img/travel/CO2.png' width=40px>&nbsp;"+ store.get('player_CO2')+"</span></p><br><b class='round' style='background-color:lightgoldenrodyellow; color:orange; border:2px solid gold;padding:2px'>"+this.id.toUpperCase() + "&nbsp;<span class='glyphicon glyphicon-star' aria-hidden='true' style='color:orange'></span></b>" + "<ul class='round' style='list-style-type:none;border:1px solid #fff; border:2px solid grey; background:#ffe;width:174px;padding:10px;line-height:38px'><li style='color:red'>-$" + $("#"+this.id).data("data").cost + "&nbsp;<img src='../img/travel/money.png' width=30px></li><li style='color:purple'>+"+$("#"+this.id).data("data").fame+"&nbsp;<img src='../img/travel/crown.png' width=30px></li><li style='color:black'>+" + $("#"+this.id).data("data").carbon + " tons <img src='../img/travel/CO2.png' width=50px></li></ul>");
		$(this).css('cursor','pointer');
		set_src(this.id, "travel/star.png");
	}).mouseout(function(){
	  document.getElementById('scene-description').innerHTML = ("Click on a city to travel there.<p><i style='color:grey;font-size:16px;'>New offers will spawn every 8 seconds.</i></p><p><span style='margin:10px'><img src='../img/travel/money.png' width=30px>&nbsp;$"+ store.get('player_funds')+"</span><span style='margin:10px'><img src='../img/travel/crown.png' width=30px>&nbsp;"+ store.get('player_fame')+"</span><span style='margin:10px'><img src='../img/travel/CO2.png' width=40px>&nbsp;"+ store.get('player_CO2')+"</span></p>");
	  $(this).css('cursor','auto');
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

		clearInterval(spawnCity);
		startPassages("newspaper.json","Start");
		$(".node").remove();
		change_scene("canvas", "travel/plane-flying.gif");

		// If user clicks, start reading article of their choice.
		$(document).on({
			    'click.myevent2': function () {
			      startGame();
		    		$(document).off('click.myevent2', '.choice-point');
			    }
			}, '.choice-point');

	});
}

function startGame(){
	// If user clicks, check if all articles have been read.
		$(document).on({
			    'click.myevent3': function () {
			      checkArticlesRead();
			    }
			}, '.choice-point');

}

function checkArticlesRead(){
	if ((store.get("readFood")||store.get("readAirport")||store.get("readSpecies")||store.get("readRefugees"))&&store.get("reading")==0){
		$(document).off('click.myevent3', '.choice-point');
		endGame();
	}
}

function endGame(){
	clearInterval(updatePassage);
	change_scene("canvas", "conversation/scrubGame_chill_3.png");
	$("#progress-bar").hide();
	// passages["End"].render();
	document.getElementById('scene-description').innerHTML = ("<p>You gained +" + store.get('current_fame') + " fame for attending the conference in " + store.get('player_location') + "!</p>");
	if (store.get("num_flights") < 2){
		document.getElementById('choice-points').innerHTML = ("<div class='choice-point' onclick='selectCity()'>Fly to your next conference.</div>");
	}
	else{
		document.getElementById('scene-description').innerHTML += ("<p>Exhausted from traveling, you decide to fly home.</p>")

		// Stop updating passage.
		clearInterval(updatePassage);

		//Add choice point to point back to menu.
		document.getElementById('choice-points').innerHTML = ("<a class='choice-point' href='../index.html'>End of Chapter Three.</a>");
	}

}


