var low = 1;
var med = 10;
var high = 100;

var r1;
var e1;
var e2;

var text;
var timer_text;
var timer;
var timeout;

function create() {
    r1 = 0;
    timer = 0;
    timeout = med;
    
    // Because e2 has a click precondition
    e2 = game.add.button(game.world.centerX - 95, 100, 'e2', e2_onClick, this, 2, 1, 0);
   // e2 = game.add.sprite(50, 50, 'e2');
    e1 = game.add.sprite(game.world.centerX, 0, 'e1');
    
    // Because e1 has a move_toward result
    game.physics.arcade.enable(e1);
    
    
    // communication
    text = game.add.text(16, 16, '', { fill: '#ffffff' });
    timer_text = game.add.text(game.world.centerX, 16, '', { fill: '#ffffff' })
}

function e2_onClick() {
    if(checkOverlap(e1, e2)) {
       r1 += med;
   }
}
