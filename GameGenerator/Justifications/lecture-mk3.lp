
%%% Biggest things missing - We probably want some reasoning over control/visuals
%% I think we have resource flows/events pretty well handled 
%% I'm thinking things like - it would be an odd design if ++confidence occurred on mouse_button down
%% and --confidence occurred on mouse_button up ,i.e. the symmetry is important
%% this reasoning should obviously be in the rules (not in the game) but I'm just using this as a journal
%% 
%% Something about the fairness/difficulty of the initialization/constants chosen?
%% There is still no reasoning about the speed of the spring as well
%% maybe something like set_constants(ball,spring,fast), set_constants(ball,spring,slow), etc.
%% and we just have some hand tuned values for each type of physicsy thing (gravity, pendulum, acceleration, impulse, etc.)




%I tend to think there are 2 classes of things - entities and resources
% or in OO land something like objects and primitives 
% I'd say be default all entities have things like x,y, v_x,v_y, a_x,a_y even 
% if that entity has no use for those fields (i.e. it is a container for other information)

% entity(class)
entity(ball).
entity(square).
entity(face).

singular(ball).
singular(square).
singular(face).
%resource(class)
resource(confidence).

physicsLogic(ball,spring).

overlapLogic(ball,square).

%Don't know if collision and overlaps should be separate, 
% probably they should be since that has a 1-1 mapping with Phaser

% Specify which controllers we are using i.e. controlLogic(button)
% then look for control_event(button,state)
% buttons - mouse_button, up,down,left,right,space
% states - pressed, held, released
controlLogic(mouse_button).

modeLogic(playing).
modeLogic(game_loss).

initialize(set_to(confidence,50)).

initialize(set_sprite(ball,circle)).
initialize(set_color(ball,light_grey)).
initialize(set_depth(ball,front)).

initialize(set_sprite(square,square)).
initialize(set_color(square,dark_grey)).
initialize(set_depth(square,back)).


initialize(set_sprite(face,anxious_face)).
initialize(set_depth(face,front)).
%% Ordering of sprites? 


%Ok, so communication strategies - I think the idea that a given
% sprite communicates is something to be handled by the rules -
% i.e. the fact that change_color of a sprite occurs as the result
% of an outcome that also increases a good resource means it is should
% communicate a good response - so the choice of how to do that should 
% incorporate "good" cultural knowledge - Mario coin collection noise, "good" colors (green v red)
% particle effect shower, etc. 

precondition(lt(confidence,5),bad_face).
result(bad_face,set_sprite(face, upset_face)).  
%I'm thinking we have a pool of tagged sprites we can pull from

precondition(lt(confidence,10),neutral_face).
precondition(ge(confidence,5),neutral_face).
result(neutral_face,set_sprite(face,anxious_face)).

precondition(ge(ge,10),good_face).
result(good_face,set_sprite(face, happy_face)). 

%I've decided I prefer tick as opposed to time as I tend to think of tick as 
% a discrete event that happens every update


precondition(tick,drain).
result(drain,decreases(confidence,frac(1,600))).

% I think it's actually mouse_button,released? 
% this is me capturing how I would design it, not how it is

precondition(control_event(mouse_button,pressed),gain).
precondition(overlaps(ball,square,true),gain).
result(gain,increases(confidence,10)).
result(gain,change_color(square,green,16)).

precondition(control_event(mouse_button,pressed),loss).
precondition(overlaps(ball,square,false),loss).
result(loss,decreases(confidence,10)).
result(loss,change_color(square,red,16)).


precondition(le(confidence,0), lose).
result(lose,mode_change(game_loss)).

