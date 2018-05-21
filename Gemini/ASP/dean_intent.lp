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

label(resource(r(1)),composure,write).
label(resource(r(2)),tension,read_only).
label(entity(e(1)),yourself).
label(entity(e(2)),help).
label(entity(e(3)),harm).


:- many(entity(e(1))).

:- not same_movement(entity(e(2)),entity(e(3))).
:- not computer_controls(entity(e(2))).
opposite(increase,decrease).

opposite_results_on_overlap :-
    precondition(overlaps(entity(e(1)),entity(e(2)),POLARITY),O2),
    precondition(overlaps(entity(e(1)),entity(e(3)),POLARITY),O3),
    result(O2,modify(D2,R)),
    result(O3,modify(D3,R)),
    opposite(D2,D3).


:- not opposite_results_on_overlap.
:- not reading(maintenance,resource(r(1))).
:- not reading(survive,entity(e(3))).
:- not reading(help,relation(entity(e(2)),player)).

:- action(mode_change(game_win)).
:- action(mode_change(game_win)).
:- not reading(good,resource(r(1))).
:- not reading(difficulty,resource(r(2))).


%:- action(add(entity(e(2)),_)).
%:- action(delete(entity(e(2)))).

%:- not entity(entity(wall)).

%:- controlLogic(_).


outcomes(N) :- N = {outcome(O)}.
:- outcomes(N),
	N > max_outcomes.
%#minimize{N : outcomes(N)}.

%:-  action(modify(_,property(_,_))).
