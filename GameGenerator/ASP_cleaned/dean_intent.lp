#const min_entities = 3.
#const max_entities = 3.
#const min_resources = 2.
#const max_resources = 2.
#const min_outcomes = 2.
#const max_outcomes = 7.
#const min_timers = 0.
#const max_timers = 2.

#const min_end_outcomes = 1.
#const max_end_outcomes = 1.
#const max_resource_change_per = 2.
#const max_conditions_per = 2.

required(survive).
required(help).
required(maintenance).

label(resource(r(1)),composure).
label(resource(r(2)),tension).
label(entity(e(1)),yourself).
label(entity(e(2)),help).
label(entity(e(3)),harm).


read_only(resource(r(2))).
:- many(entity(e(1))).

:- not same_movement(entity(e(2)),entity(e(3))).
:- not computer_controls(entity(e(2))).

:- not reading(maintenance,resource(r(1))).
:- not reading(survive,entity(e(3))).
:- not reading(help,relation(entity(e(2)),player)).

:- action(mode_change(game_win)).
:- action(mode_change(game_win)).
:- not reading(good,resource(r(1))).

%:- action(add(entity(e(2)),_)).
%:- action(delete(entity(e(2)))).

%:- not entity(entity(wall)).

%:- controlLogic(_).


outcomes(N) :- N = {outcome(O)}.
:- outcomes(N),
	N > max_outcomes.
%#minimize{N : outcomes(N)}.

%:-  action(modify(_,property(_,_))).