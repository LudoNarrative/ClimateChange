
%%%%% SOUP OF THINGS TO PULL FROM %%%%%


pools(inventory).
potential_paths(p1;p2;p3;p4;p5).

opposite(north,south).
opposite(east,west).
opposite(forward,backward).
opposite(left,right).
opposite(B,A) :- opposite(A,B).

vertical(north;south;forward;backward).
horizontal(east;west;left;right).
direction(north;south;east;west;forward;backward;left;right).
cardinal(north;south;east;west).
local(forward;backward;left;right).
place(center;random;upper_left;upper_right;lower_left;lower_right).


buttons(mouse_button;space;up_arrow;down_arrow;left_arrow;right_arrow).
buttonOrder(mouse_button,up_arrow).
buttonOrder(space,up_arrow).
buttonOrder(up_arrow,down_arrow).
buttonOrder(down_arrow,left_arrow).
buttonOrder(left_arrow,right_arrow).
buttonOrder(A,C) :- buttonOrder(A,B), buttonOrder(B,C).
buttonStates(pressed;held;released).
controls(cursor). % OTHERS?
controls(BUTTON) :- buttons(BUTTON).

% sprites(square;circle;upset_face;anxious_face;happy_face).
% CRM 7/6/2016: adding things that correspond to phaser assets
sprite(purple_square; pink_square; red_A; aqua_ball; right_arrow; green_B;
  wooden_block; blue_ball; car; car_turned; carrot; diamond; eggplant;
  health_kit; green_ball; giant_hotdog; long_right_arrow;
  long_left_arrow; trefoil_knot; melon; mushroom; onion; orb_blue; orb_green;
  orb_red; big_orb_blue; pepper; pineapple; plane; platform; red_ball;
  purple_ball; shiny_ball; rocket_ship; slime; glowing_panda;
  glowing_rainbow; glowing_unicorn; glowing_smiley; glowing_guitar;
  glowing_candy; glowing_watermelon; glowing_radio; tetris_t; tetris_z;
  tetris_L; tomato; ufo; rabbit; yellow_ball).

colors(red;green;blue;yellow;magenta;cyan;white;light_grey;dark_grey;black).

potentialEntities(e1;e2;e3;e4;e5).
entityOrdering(e1,e2).
entityOrdering(e2,e3).
entityOrdering(e3,e4).
entityOrdering(e4,e5).
entityOrdering(A,C) :- entityOrdering(A,B), entityOrdering(B,C).

potentialResources(r1;r2;r3;r4;r5).
resourceOrdering(r1,r2).
resourceOrdering(r2,r3).
resourceOrdering(r3,r4).
resourceOrdering(r4,r5).
resourceOrdering(A,C) :- resourceOrdering(A,B), resourceOrdering(B,C).
potentialOutcomes(o1;o2;o3;o4;o5).
potentialEndOutcomes(eo1;eo2;eo3;eo4;eo5).
outcomeOrder(o1,o2).
outcomeOrder(o2,o3).
outcomeOrder(o3,o4).
outcomeOrder(o4,o5).
outcomeOrder(A,C) :- outcomeOrder(A,B), outcomeOrder(B,C).

potentialTimer(t1;t2;t3;t4).
% XXX add ordering

constants(0;low;medium;high).
potentialValues(V) :- constants(V).

% CRM 6/28/2016
potentialValues(R) :- resource(R).

potentialModes(playing;narrative_progress;game_loss;game_win).
polarity(true;false).


%end modes
end_mode(game_loss;game_win).

%ordering of values  
lower_than(low,mid).
lower_than(low,high).
lower_than(mid,high).


spawnTimings(steady;at_a_time(1);at_a_time(2);at_a_time(3);at_a_time(4);poisson;condition).

change(increases;decreases;set_to).

:-  monotonicallyIncreases(Resource), 
    precondition(Condition,Outcome),
    lowThreshold(Condition,Resource,Threshold).
    
:-  monotonicallyDecreases(Resource), 
    precondition(Condition,Outcome),
    highThreshold(Condition,Resource,Threshold).
