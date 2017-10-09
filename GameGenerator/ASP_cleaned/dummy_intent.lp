#const min_entities = 1.
#const max_entities = 2.
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




max_scalars(N) :- N = {precondition(compare(_,_),_);
		     result(_,modify(_,_))}.

scalar(M) :- M = 1..N,max_scalars(N).

:- not scalar(2).

{apply_scalar(precondition(compare(A,B),C),scalar(S))} :- scalar(S),precondition(compare(A,B),C).
{apply_scalar(result(A,modify(B,C)),scalar(S))} :- scalar(S),result(A,modify(B,C)).

:- 2 {apply_scalar(_,scalar(S))},
   scalar(S).

applied(scalar(S)) :- apply_scalar(_,scalar(S)).
not_applied(S) :- not applied(scalar(S)),
		  scalar(S).

:- not_applied(_).

