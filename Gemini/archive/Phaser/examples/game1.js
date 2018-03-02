function preload() {

    game.load.baseURL = 'http://examples.phaser.io/assets/';
    game.load.crossOrigin = 'anonymous';

    game.load.image('e1', 'sprites/hotdog.png');
    game.load.image('e2', 'sprites/mushroom.png');
}

var low = 1;
var med = 10; 
var high = 100;

var r1; 
var e1; 
var e2; 


function create() {

    r1 = 0;
    
    // Because e1 has a click precondition
    e1 = game.add.button(game.world.centerX - 95, 100, 'e1', e1_onClick, this, 2, 1, 0);
    e2_group = game.add.group();

    add_at_random_place(e2_group, 'e2');
    
    text = game.add.text(0, 0, "hello world");
}

function randomInt(min, max) {
  return Math.floor(Math.random() * (max - min)) + min;
}

function random_place() {
    x = randomInt(0, game.world.width-1);
    y = randomInt(0, game.world.height-1);
    return {x: x, y: y}
}

function add_at_random_place(group, sprite) {
    place = random_place();
    group.create(place.x, place.y, sprite);
}

function e1_onClick() {
    add_at_random_place(e2_group, 'e2');
    r1 += low;
}

function update() {

    if(r1 >= med) {
        o2();
    }
}

function o2() {
    game_win();
}

win = 1;

function game_win() {
    mode = win;
    game.world.removeAll();
    display_text("YOU WIN!")
}

function display_text(t) {
    var style = { font: "bold 32px Arial", fill: "#fff", boundsAlignH: "center", boundsAlignV: "middle" };

    //  The Text is positioned at 0, 100
    text = game.add.text(0, 0, t, style);
}


