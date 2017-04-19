#const min_entities = 1.
#const max_entities = 2.
#const min_resources = 1.
#const max_resources = 2.
#const min_outcomes = 2.
#const max_outcomes = 6.
#const min_timers = 0.
#const max_timers = 2.

#const min_end_outcomes = 1.
#const max_end_outcomes = 1.
#const max_resource_change_per = 2.
#const max_conditions_per = 2.


:- not reading(sharing,relation(entity(e(1)),entity(e(2)))).
:- not reading(goal(produce),resource(r(1))).
:- not action(mode_change(narrative_gating)).
:- 2 {action(mode_change(N))}.

:- not static(entity(e(2))).


:- total_count(entity(e(2)),N),
   N > 3.
:- total_count(entity(e(2)),N),
   N < 2.

:- action(delete(entity(e(2)))).

:- 0 {controlScheme(_,_)} 0.

:- controlScheme(_,click_and_drag).


:- action(add(entity(e(2)),_)).

%:- not entity(entity(wall)).
