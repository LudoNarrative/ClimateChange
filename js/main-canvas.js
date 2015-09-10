/*** MAIN CODE ****/

// Global Parameters
store.set("score",60);
store.set("required_percent",-1);
store.set("difficulty",1);
store.set("update",1); // tells the game to end when update is 0

// Stats specific to the travel game.
store.set("reading",0);                       // Whether the player is currently reading an article.

store.set("readFood",0);                      // Whether you have read the article about food or not.
store.set("readAirport",0);
store.set("readSpecies",0);
store.set("readRefugees",0);

store.set("player_fame",0);                   // How much fame the player has.
store.set("current_fame",0);                  // How much fame the player is going to increase by.
store.set("player_CO2",0);                    // The player's carbon footprint.
store.set("player_time", 14);                 // How much time (in days) the player has to spend at conferences.
store.set("player_location", "Santa Cruz");   // Player's current location.
store.set("player_funds", 3000);              // Player's current funds.
store.set("max_flights", 2);                  // How many times you can travel.
store.set("num_flights", 0);                  // How many times the player has already traveled.

spawnCity = null;
checkEnd = null;

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
