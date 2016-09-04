#const min_entities = 1.
#const max_entities = 3.
#const min_resources = 1.
#const max_resources = 2.
#const min_outcomes = 2.
#const max_outcomes = 10.

#const min_end_outcomes = 1.
#const max_end_outcomes = 1.
#const max_resource_change_per = 2.
#const max_conditions_per = 2.
 

tick :- precondition(tick,O).
:- not tick.


false_overlaps :- precondition(overlaps(E,E2,false),O).
:- not false_overlaps.
% :- onlyOnePrecondition(O), consumedBy(R,O).

% :- not consumedBy(r1,o1).
