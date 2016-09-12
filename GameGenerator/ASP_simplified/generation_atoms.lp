
%%%%% SOUP OF THINGS TO PULL FROM %%%%%

counts(1..10).

pools(inventory).
potential_paths(p1;p2;p3;p4;p5).

columns(left;center;right).
rows(top;middle;bottom).

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

place(field).%place(center;random;upper_left;upper_right;lower_left;lower_right).

speeds(slow;normal;fast).

duration(1;3;5;10;
	 stochastic(exponential,1);
	 stochastic(exponential,3);
	 stochastic(exponential,5);
	 stochastic(exponential,10);
	 stochastic(gaussian,3);
	 stochastic(gaussian,5);
	 stochastic(gaussian,10);
	 stochastic(gausssian,1)
	).

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
sprite(square;circle;triangle;pentagon;star).

colors(red;green;blue;yellow;magenta;cyan;white;gray;black).

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
potentialOutcomes(o1;o2;o3;o4;o5;o6;o7;o8;o9;o10).
potentialEndOutcomes(eo1;eo2;eo3;eo4;eo5).
outcomeOrder(o1,o2).
outcomeOrder(o2,o3).
outcomeOrder(o3,o4).
outcomeOrder(o4,o5).
outcomeOrder(o5,o6).
outcomeOrder(o6,o7).
outcomeOrder(o7,o8).
outcomeOrder(o8,o9).
outcomeOrder(o9,o10).
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
