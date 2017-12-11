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

palette(orange).
allowed(monotonic(orange)).
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



%:- not condition(compare(_,_,amount(_))).
