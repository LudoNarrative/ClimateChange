
%potentialEntities(e(1..max_entities)).
%potentialResources(r(1..max_resources)).

constants(0..3).


row(top;middle;bottom).
col(left;center;right).

modes(narrative_gating;narrative_progress;game_loss;game_win).

buttons(mouse;space;up_arrow;down_arrow;left_arrow;right_arrow).
buttonStates(pressed;held).

%sprite(square;circle;triangle;pentagon;star).
sprite(triangle).
conditional_direction(ge;le).
angle_direction(cw;ccw).
%colors(red;green;blue;yellow;magenta;cyan;white;gray;black).
colors(red,1).
colors(blue,2).
colors(green,3).
colors(yellow,4).
colors(magenta,5).
colors(orange,6).

colors(C) :-
    colors(C,N),
    N <= max_entities.

polarity(true;false).
