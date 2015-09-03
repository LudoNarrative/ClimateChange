/*** MAIN CODE ****/

// Global Parameters
store.set("score",60);
store.set("required_percent",-1);
store.set("difficulty",1);
store.set("update",1); // tells the game to end when update is 0

// Stats specific to the travel game.
store.set("reading",0);												// Whether the player is currently reading an article.

store.set("readFood",0);											// Whether you have read the article about food or not.
store.set("readAirport",0);
store.set("readSpecies",0);
store.set("readRefugees",0);

store.set("player_fame",0);										// How much fame the player has.
store.set("current_fame",0);									// How much fame the player is going to increase by.
store.set("player_CO2",0);										// The player's carbon footprint.
store.set("player_time", 14);									// How much time (in days) the player has to spend at conferences.
store.set("player_location", "Santa Cruz");		// Player's current location.
store.set("player_funds", 3000);							// Player's current funds.
store.set("max_flights", 2);									// How many times you can travel.
store.set("num_flights", 0);									// How many times the player has already traveled.

spawnCity = null;
checkEnd = null;

$(document).ready(function(){
	selectCity();
});

function selectCity(){
	document.getElementById('scene-description').innerHTML = ("Click on a city to travel there.<p><i style='color:grey;font-size:16px;'>New offers will spawn every 8 seconds.</i></p><p><span style='margin:10px'><img src='img/money.png' width=30px>&nbsp;$"+ store.get('player_funds')+"</span><span style='margin:10px'><img src='img/crown.png' width=30px>&nbsp;"+ store.get('player_fame')+"</span><span style='margin:10px'><img src='img/CO2.png' width=40px>&nbsp;"+ store.get('player_CO2')+"</span></p>");
	document.getElementById('choice-points').innerHTML = ("<div class='choice-point'></div>");

	change_scene("canvas", "europe-map.png");

	// Place stats.
	// place_object("money-icon", "money.png", 20,310,40,40);
	// place_object("fame-icon", "crown.png", 150,310,40,40);
	// place_object("co2-icon", "CO2.png", 280,310,55,40);


	// Place cities.
	place_random_city();

	// Repeat process after a delay.
	spawnCity = setInterval(place_random_city, 8000);

}

function place_random_city(){
	// Remove all previous nodes.
	$(".node").remove();

	// Clear scene description and cursor.
	document.getElementById('scene-description').innerHTML = ("Click on a city to travel there.<p><i style='color:grey;font-size:16px;'>New offers will spawn every 8 seconds.</i></p><p><span style='margin:10px'><img src='img/money.png' width=30px>&nbsp;$"+ store.get('player_funds')+"</span><span style='margin:10px'><img src='img/crown.png' width=30px>&nbsp;"+ store.get('player_fame')+"</span><span style='margin:10px'><img src='img/CO2.png' width=40px>&nbsp;"+ store.get('player_CO2')+"</span></p>");
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

	place_object(random_city.id, "star-2.png", random_city.x, random_city.y, 25, 25)

	var random_cost = getRandomInt(300,1200);
	var random_carbon = getRandomInt(0.1,5);
	var random_fame = getRandomInt(25,300);

	var d = document.getElementById(random_city.id);
	d.className = "node";
	$('#' + random_city.id).data('data', { location: random_city.id, cost: random_cost, carbon: random_carbon, fame: random_fame});

	// On mouseover, show city stats.
	$('.node').mouseover(function(){
		document.getElementById('scene-description').innerHTML = ("Click on a city to travel there.<p><i style='color:grey;font-size:16px;'>New offers will spawn every 8 seconds.</i></p><p><span style='margin:10px'><img src='img/money.png' width=30px>&nbsp;$"+ store.get('player_funds')+"</span><span style='margin:10px'><img src='img/crown.png' width=30px>&nbsp;"+ store.get('player_fame')+"</span><span style='margin:10px'><img src='img/CO2.png' width=40px>&nbsp;"+ store.get('player_CO2')+"</span></p><br><b class='round' style='background-color:lightgoldenrodyellow; color:orange; border:2px solid gold;padding:2px'>"+this.id.toUpperCase() + "&nbsp;<span class='glyphicon glyphicon-star' aria-hidden='true' style='color:orange'></span></b>" + "<ul class='round' style='list-style-type:none;border:1px solid #fff; border:2px solid grey; background:#ffe;width:174px;padding:10px;line-height:38px'><li style='color:red'>-$" + $("#"+this.id).data("data").cost + "&nbsp;<img src='img/money.png' width=30px></li><li style='color:purple'>+"+$("#"+this.id).data("data").fame+"&nbsp;<img src='img/crown.png' width=30px></li><li style='color:black'>+" + $("#"+this.id).data("data").carbon + " tons <img src='img/CO2.png' width=50px></li></ul>");
		$(this).css('cursor','pointer');
		set_src(this.id, "star.png");
	}).mouseout(function(){
	  document.getElementById('scene-description').innerHTML = ("Click on a city to travel there.<p><i style='color:grey;font-size:16px;'>New offers will spawn every 8 seconds.</i></p><p><span style='margin:10px'><img src='img/money.png' width=30px>&nbsp;$"+ store.get('player_funds')+"</span><span style='margin:10px'><img src='img/crown.png' width=30px>&nbsp;"+ store.get('player_fame')+"</span><span style='margin:10px'><img src='img/CO2.png' width=40px>&nbsp;"+ store.get('player_CO2')+"</span></p>");
	  $(this).css('cursor','auto');
	  set_src(this.id, "star-2.png");
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
		passages["Start"].render();
		$(".node").remove();
		change_scene("canvas", "plane-flying.gif");

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
	change_scene("canvas", "scrubGame_chill_3.png");
	$("#progress-bar").hide();
	// passages["End"].render();
	document.getElementById('scene-description').innerHTML = ("<p>You gained +" + store.get('current_fame') + " fame for attending the conference in " + store.get('player_location') + "!</p>");
	if (store.get("num_flights") < 2){
		document.getElementById('choice-points').innerHTML = ("<div class='choice-point' onclick='selectCity()'>Fly to your next conference.</div>");
	}
	else{
		document.getElementById('scene-description').innerHTML += ("<p>Exhausted from traveling, you decide to fly home.</p>")
		document.getElementById('choice-points').innerHTML = ("");
	}

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

// Change the background image of a canvas.
function change_scene(canvasID, image){
	$('#'+canvasID).css('background-image', 'url("img/'+image+'")');
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
