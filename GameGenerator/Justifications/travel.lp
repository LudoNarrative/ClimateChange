
entity(pointer).
entity(city).

resource(money).
resource(fame).
resource(co2).

resource(citiesSelected).

resource(timeTilNext).

resource(turns).

% perhaps abusing notation, need to think about Objectness
resource(city(money)).
resource(city(fame)).
resource(city(co2)).
resource(city(lifetime)).
resource(city(name)).

physicsLogic(pointer, follows(cursor)).


controlLogic(mouse_button).
controlLogic(cursor).

collisionLogic(city,pointer).


% this should perhaps just be a bunch of other entity specific resources
% but I thought that the idea of selecting,deselecting, etc. should perhaps 
% show up as a specialized thing
selectionLogic(city).

%I prefer to think of pooling as a poolingLogic 
poolingLogic(city,urn_without_replacement). %other poolingLogics - stack, queue, urn_with_replacement


mode_logic(playing).
mode_logic(narrative_turn).
mode_logic(game_end).
mode_logic(game_loss).

% these are at the start of the game
initialize(set_to(money,5000)).
initialize(set_to(fame,0)).
initialize(set_to(co2,0)).
initialize(set_sprite(city,circle)).
initialize(set_color(city,light_grey)).
initialize(set_depth(city,front)).
initialize(set_mode(playing)).
initialize(set_to(turns,0)).

%we want every time we return to playing to have a
% consistent set of things happen - 
on_mode_change_to(playing, set_to(timeTilNext,0)).
on_mode_change_to(playing, set_to(citiesSelected,0)).


%This is some wonkiness below but again, I'm trying to imagine something convertable to code
% generally, I think something like decreases(city(lifetime),1) iterates over all cities in the 
% simulation and decreases their lifetime by 1
% but for something like deleting a city whose lifetime has run out
% e.g. 
% precondition(below(city(lifetime),0), delete_city).
% result(delete_city,select(city,inPrecondition)). 
% result(delete_city,delete(city)).
% I have "select" which allows you to specify a specific object that holds for the rest of the result
% e.g. result(delete_city,delete(city)) only deletes the city referenced in the precondition
% now, this does have trouble if there is something like 2 objects are touching, destroy the smaller one,
% so we might need some sort of way of referencing entities from the precondition in the result

precondition(tick,updateTimers).
result(updateTimers,decreases(timeTilNext,1)).
result(updateTimers,decreases(city(lifetime),1)).

precondition(below(timeTilNext,0),generate_city).
result(generate_city,add(city)).  %add/delete are overridden by the pooling logic to know to pull from/return to the pool given its settings
result(generate_city,set_to(timeTilNext,exponential_distribution(short))).

precondition(below(city(lifetime),0), delete_city).
result(delete_city,select(city,inPrecondition)). 
result(delete_city,delete(city)).



%% Again, some wonkiness - generally, theres just a lot going on here
% but the biggest wonkiness is the idea of create_inverse 
% which I see as a sort of meta_command that looks at what the result is doing
% and creates a callback that can be called later that resets everything to its original value
% or does as close as it can 
% e.g. increasing, decreasing just do the opposite
% setting to something, it just sets it to the original value
% adding/deleting again do the opposite - (unless it shouldn't? need to think abot this?)
precondition(control_event(mouse_button,pressed),add_city).
precondition(collides(pointer,city,true),add_city).
precondition(true(city(selectable)),add_city).
precondition(above(money,city(money)),add_city).
result(add_city,select(city,inPrecondition)). 
result(add_city,decreases(money,city(money))).
result(add_city,increases(fame,city(fame))).
result(add_city,increases(co2,city(co2))).
result(add_city,set(city(lifetime),pos_infinity)).
result(add_city,set(city(selectable),false)).
result(add_city,increases(citiesSelected,1)).
result(add_city,set_color(city,dark_grey)).
result(add_city,create_inverse(city)).



%% Reverse the previous
precondition(control_event(mouse_button,pressed),remove_city).
precondition(collides(pointer,city,true),remove_city).
precondition(false(city(selectable)),remove_city).
result(remove_city,apply_inverse(city)).



%% move the narrative forward
precondition(above(citiesSelected,4),progress_narrative).
result(progress_narrative,mode_change(narrative_turn)).
result(progress_narrative,delete(city)). %without specifying a selection this deletes all active cities
result(progress_narrative,set_to(citiesSelected,0)).
result(progress_narrative,increases(turns,1)).

% done the back and forth with the narrative enough
precondition(above(turns,4),end).
result(end,mode_change(game_end)).

% no money, mo problems
precondition(below(money,0), no_money).
result(no_money,mode_change(game_loss)).