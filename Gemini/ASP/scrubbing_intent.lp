#const min_entities = 0.
#const max_entities = 1.
#const min_resources = 1.
#const max_resources = 1.
#const min_outcomes = 2.
#const max_outcomes = 6.
#const min_timers = 0.
#const max_timers = 2.

#const min_end_outcomes = 0.
#const max_end_outcomes = 1.
#const max_resource_change_per = 2.
#const max_conditions_per = 2.

required(maintenance).

reading(bad,orange).
% reading(goal(produce),orange).

palette(orange).
allowed(monotonic(orange)).

label(resource(r(1)),effort,write).
allowed(monotonic(resource(r(1)))).
allowed(monotonic(r(1))).
allowed(superfluous(resource(r(1)))).
:- not monotonic(orange,decrease).
:- not initialize(fill(all,orange)).




:- action(mode_change(_)).

:- not player_controls(_).
:- not player_creates_effect(clear(_)).
:- player_doesnt_create_effect(clear(_)).

:- player_model(O,player_must_do),
   not result(O,modify(increase,resource(r(1)))).
   
:- not monotonic(resource(r(1)),increase).

initialize(set_value(resource(r(1)),scalar(0))).

allowed(frivolous(resource(r(1)))).
allowed(frivolous_color(orange)).
allowed(frivolous_color(clear)).
:- condition(compare(_,resource(r(1)))).
:- condition(compare(_,resource(r(1)),_)).
% TODO: try to use the following three constraints as well; the color ones are probably blocked on something about uses color?? 
:- condition(compare(_,amount(_))).
:- condition(compare(_,amount(_),_)).

:- action(modify(_,property(_,_))).

:- result(O,modify(increase,_)),
  super_trivial(O).
