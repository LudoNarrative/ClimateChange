#const min_entities = 1.
#const max_entities = 3.
#const min_resources = 1.
#const max_resources = 2.
#const min_outcomes = 2.
#const max_outcomes = 10.
#const min_timers = 1.
#const max_timers = 2.

#const min_end_outcomes = 1.
#const max_end_outcomes = 1.
#const max_resource_change_per = 2.
#const max_conditions_per = 2.


:- not precondition(collide(e(1),e(2)),_).
:- not reading(chases,relation(e(1),e(2))).
:- not reading(chases,relation(e(1),e(3))).
:- not reading(chases,relation(e(3),e(2))).
:- not reading(flees,relation(e(2),e(1))).

has_goal :- reading(goal(_),_).
:- not has_goal.

:- not precondition(compare(_,_),_).

:- complex(E).
