
entity(hand).
entity(sand).
resource(sand_count).

singular(hand).
many(sand).


physicsLogic(hand,follows(cursor)).

overlapLogic(hand,sand).

%Don't know if collision and overlaps should be separate, 
% probably they should be since that has a 1-1 mapping with Phaser

% Specify which controllers we are using i.e. controlLogic(button)
% then look for control_event(button,state)
% buttons - mouse_button, up,down,left,right,space
% states - pressed, held, released
controlLogic(mouse_button).


resourceLogic(sandAmount,count(sand)).

modeLogic(playing).

placement(sand,uniform_field).


precondition(control_event(mouse_button,held),scrub).
precondition(overlaps(ball,sand,true),scrub).
result(scrub,delete(sand)).


precondition(le(sand_count,50), progress).
result(progress,mode_change(narrative_progression)).

