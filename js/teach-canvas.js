/*** MAIN CODE ****/

var successfulClickStressRestoreAmount = 23;
var maxStress = 60;
var stressLossNormDiff = 1;
var stressLossMedDiff = 3;
var stressLossHighDiff = 8;
var chillStressLevel = 40;
var neutralStressLevel = 20;
var highStressLevel = 0;
var stressLostPerMissedClick = 20;
var failPoint = -25;
var ballSpeed = 1500;

$(document).ready(function(){
  // set (top) canvas height to 100px
  $('#canvas').height('100px');
  $("#canvas").css("background-color","#222");

  startTutorial();
});

function startTutorial(){
  startPassages("teacher.json","Intro");

  // Set score at a scary place
  store.set("score",40);

  // Place the sweet spot in the scene.
  place_div('sweet-spot', 175,10,80,80, {color: "#666"});

  // Place the ball in the scene.
  place_object('ball','balance/ball.png',175,10,80,80);
  $('#ball').hide();

  // Make the ball move to the left and right.
  back_and_forth('#ball',350,0,ballSpeed);

  // Once delay for movement has completed, show the ball.
  //setTimeout(function(){
   if (store.get("update")){
     $('#ball').show();
   }

  //}, 3000);

  // Check if ball in middle of target on click.
  $('#ball').click(function(e){
    e.preventDefault();
    checkCool();
  });
  $('#sweet-spot').click(function(e){
    e.preventDefault();
    checkCool();
  });
  $("#canvas").on("click", function(e) {
    e.preventDefault();
    checkCool();
  });



  lose_cool();
  loseCool = setInterval ( lose_cool, 1000 );


  // If user clicks...
  $(document).on({
        'click.myevent2': function () {
            startGame();
          $(document).off('click.myevent2', '.choice-point');
        }
    }, '.choice-point');
}

function checkCool(){
  // console.log("check");
  // Only update score if game is in progress.
  if (store.get("update")==1){
    if (check_collision("#ball","#sweet-spot")){
      if (store.get("score")+successfulClickStressRestoreAmount < maxStress){
        store.set("score",store.get("score")+successfulClickStressRestoreAmount);
      }
      else{
        store.set("score",maxStress);

      }
    // console.log("green");
    flash_color("#sweet-spot","green", "background-color");
    }
    else{
      store.set("score",store.get("score")-stressLostPerMissedClick);
      flash_color("#sweet-spot","red", "background-color");
      // console.log("red");
    }
    update_score();
  }
}

function startGame(){
  passages["Start"].render();
  store.set("score", maxStress);
  store.set("difficulty",1);
  setTimeout(function(){
    check_end();
    checkEnd = setInterval ( check_end, 500 );
  }, 2000);
}



// Make an object move horizontally back and forth.
function back_and_forth(id,distance,x,halfTime){
  // var halfTime = 1500;

  setInterval(function(){

    $(id).stop(true,true).animate({left: distance}, halfTime,
          function(){
            $(this).stop(true,true).animate({left: x}, halfTime);
        });
  }, halfTime*2);

}

function check_collision(id1, id2){
  // add extended safe zone based on difficulty
  var extra_width = 0;
  var diff = store.get("difficulty");

  if (diff<=0){
    extra_width=50;

  }
  else if (diff<=1){
    extra_width=25;
  }
  else{
    extra_width=0;
  }

  var ax = get_pos(id1).x;
  var ay = get_pos(id1).y;
  var bx = get_pos(id2).x;
  var by = get_pos(id2).y;

  var width = $(id1).width() + extra_width;

  return !(
        ((ay + $(id1).height()) < (by)) ||
        (ay > (by + $(id2).height())) ||
        ((ax + width) < bx) ||
        (ax > (bx + width))
    );
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

function lose_cool(){
  // Update stress image.
  var score = store.get("score");
  if (score > chillStressLevel){
    set_src("stressface","balance/teaching_chill.png");
  }
  else if (score > neutralStressLevel){
    set_src("stressface","balance/teaching_neutral.png");
  }
  else if (score > highStressLevel){
    set_src("stressface","balance/teaching_stressed.png");
  }
  else{
    set_src("stressface","balance/teaching_ultrastressed.png");
  }

  // Determine how much cool is lost based on difficulty level.
  var losecool = 0;
  var diff = store.get("difficulty");

  if (diff<=0){
    store.set("difficulty",0);
    losecool=stressLossNormDiff;
  }
  else if (diff <=1){
    losecool=stressLossMedDiff;
  }
  else{
    store.set("difficulty",2);
    losecool=stressLossHighDiff;
  }

  // Update score.
  store.set("score",store.get("score")-losecool);
  update_score();

}

function check_end(){
  // If the score is super bad, end game early
  if (store.get("score") <= failPoint){
    store.set("update",0);
  }
  // If the game is done,
  if (!store.get("update")){
    // Stop changing score.
    clearInterval(loseCool);

    // Stop checking for end.
    clearInterval(checkEnd);
    clearInterval(updatePassage);

    // Render the fail screen if score was bad.
    if (store.get("score") <= failPoint){
      passages["fail"].render();
      store.set("profession","activist");
    }
    else{
      // Render the good ending.
      passages["ClassEnds"].render();
      store.set("profession","professor");

    }

    // Hide the ball.
    $("#ball").hide();

    // Hide the target.
    $("#sweet-spot").hide();

    // Stop updating passage.
    clearInterval(updatePassage);

    //Add choice point to point back to menu.
    document.getElementById('choice-points').innerHTML = ("<a class='choice-point' href='../index.html'>End of Chapter Two.</a>");

    // Update chapter.
    store.set("chapter",store.get("chapter")+1);
  }
}
