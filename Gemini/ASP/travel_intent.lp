#const min_entities = 1.
#const max_entities = 3.
#const min_resources = 3.
#const max_resources = 3.
#const min_outcomes = 2.
#const max_outcomes = 6.
#const min_timers = 0.
#const max_timers = 2.

#const min_end_outcomes = 0.
#const max_end_outcomes = 0.
#const max_resource_change_per = 4.
#const max_conditions_per = 2.


label(resource(r(1)),money,write) .
label(resource(r(2)),co2,write) .
label(resource(r(3)),fame,write) .

required(tradeoff).


allowed(monotonic(resource(r(1)))).

allowed(monotonic(resource(r(2)))).

allowed(monotonic(resource(r(3)))).

%:- not monotonic(resource(r(1))).
 
:- action(modify(decrease,resource(r(2)))).
:- action(modify(decrease,resource(r(3)))).


:- action(mode_change(_)).


{choice(O,higher)} :- result(O,modify(decrease,resource(r(1)))),
		      result(O,modify(increase,resource(r(2)))),
		      result(O,modify(increase,resource(r(3)))).

{choice(O,lower)} :- result(O,modify(decrease,resource(r(1)))),
		     result(O,modify(increase,resource(r(2)))),
		     result(O,modify(increase,resource(r(3)))).

:- choice(O,higher),
   choice(O,lower).

:- 2 {choice(O,higher)}.
:- 2 {choice(O,lower)}.
:- 0 {choice(O,higher)} 0.
:- 0 {choice(O,lower)} 0.

:- result(O,modify(increase,resource(r(2)))),
   not choice(O,_).
:- result(O,modify(increase,resource(r(3)))),
   not choice(O,_).

:- action(modify(_,resource(r(1)),_)).
:- action(modify(_,resource(r(2)),_)).
:- action(modify(_,resource(r(3)),_)).


constraint(ge,
	   result(Higher,modify(increase,resource(r(2)))),
	   result(Lower,modify(increase,resource(r(2))))) :-
    choice(Higher,higher),
    choice(Lower,lower).


constraint(ge,
	   result(Higher,modify(increase,resource(r(3)))),
	   result(Lower,modify(increase,resource(r(3))))) :-
    choice(Higher,higher),
    choice(Lower,lower).


constraint(eq,
	   result(Higher,modify(decrease,resource(r(1)))),
	   result(Lower,modify(decrease,resource(r(1))))) :-
    choice(Higher,higher),
    choice(Lower,lower).



similar_conditions :- precondition(control_event(click(_)),Higher),
		      precondition(control_event(click(_)),Lower),
		      choice(Higher,_),
		      choice(Lower,_).



similar_conditions :- precondition(overlaps(_),Higher),
		      precondition(overlaps(_),Lower),
		      choice(Higher,_),
		      choice(Lower,_).

:- not similar_conditions.


:- not player_controls_outcome(O),
   choice(O,_).
