
initialize(set(r(1),0)).


precondition(compare(le,r(1)),o(1)).
result(o(1),modify(increase,r(1))).



precondition(compare(ge,r(1)),o(2)).
result(o(2),modify(decrease,r(1))).


outcome(O) :- precondition(C,O).

outcome_occurs(O) :- outcome_occurs_at(O,T),
                     T > 0.
:- outcome(O),
   not outcome_occurs(O).
   