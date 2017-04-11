
%potentialEntities(e(1..max_entities)).
%potentialResources(r(1..max_resources)).

constants(0..3).

modes(narrative_gating;narrative_progress;game_loss;game_win).

buttons(mouse;space;up_arrow;down_arrow;left_arrow;right_arrow).
buttonStates(pressed;held;released).

sprite(square;circle;triangle;pentagon;star).

colors(red;green;blue;yellow;magenta;cyan;white;gray;black).

potentialValues(V) :- constants(V).
potentialValues(R) :- resource(R).

polarity(true;false).
