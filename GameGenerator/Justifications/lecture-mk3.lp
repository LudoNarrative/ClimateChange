
%%% Biggest things missing - We probably want some reasoning over control/visuals
%% I think we have resource flows/events pretty well handled 
%% I'm thinking things like - it would be an odd design if ++confidence occurred on mouse down
%% and --confidence occurred on mouse up ,i.e. the symmetry is important
%% this reasoning should obviously be in the rules (not in the game) but I'm just using this as a journal
%% 


% graphic(class)
graphic(ball).
graphic(square).
graphic(face).

%resource(class)
resource(confidence).



physicsLogic(ball,spring).

overlapLogic(ball,square).

%Don't know if collision and overlaps should be separate, 
% probably they should be since that has a 1-1 mapping with Phaser

% Specify which controllers we are using i.e. controlLogic(button)
% then look for control_event(button,state)
% buttons - mouse, up,down,left,right,space
% states - pressed, held, released
control_logic(mouse).

mode_logic(playing).
mode_logic(game_loss).


%Ok, so communication strategies - I think the idea that a given
% sprite communicates is something to be handled by the rules -
% i.e. the fact that change_color of a sprite occurs as the result
% of an outcome that also increases a good resource means it is should
% communicate a good response - so the choice of how to do that should 
% incorporate "good" cultural knowledge - Mario coin collection noise, "good" colors (green v red)
% particle effect shower, etc. 

precondition(below(confidence,5),bad_face).
result(bad_face,change_sprite(face, upset_face)).  
%I'm thinking we have a pool of tagged sprites we can pull from

precondition(below(confidence,10),neutral_face).
precondition(above(confidence,5),neutral_face).
result(neutral_face,change_sprite(face,anxious_face)).

precondition(above(confidence,10),good_face).
result(good_face,change_sprite(face, happy_face)). 

%I've decided I prefer tick as opposed to time as I tend to think of tick as 
% a discrete event that happens every update


precondition(tick,drain).
result(drain,decreases(confidence,1)).

% I think it's actually mouse,released? 
% this is me capturing how I would design it, not how it is

precondition(control_event(mouse,pressed),gain).
precondition(overlaps(ball,square,true),gain).
result(gain,increases(confidence,2)).
result(gain,change_color(square,green,1)).

precondition(control_event(mouse,pressed),loss).
precondition(overlaps(ball,square,false),loss).
result(loss,decreases(confidence,2)).
result(gain,change_color(square,red,1)).


precondition(below(confidence,0), lose).
result(lose,mode_change(game_loss)).

