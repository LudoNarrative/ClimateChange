
resource(r(1)).
resource(r(2)).

initialize(set(r(1),0)).
initialize(set(r(2),6)).

outcome(o(1)).
outcome(o(2)).

precondition(compare(le,r(1)),o(1)).
precondition(control_event(click(e(1))),o(1)).
result(o(1),modify(increase,r(2))).

precondition(compare(ge,r(1)),o(2)).
result(o(2),modify(decrease,r(1))).

precondition(compare(ge,r(2)),o(3)).
result(o(3),modify(increase,r(1))).


precondition(compare(le,r(2)),o(4)).
result(o(4),mode_change(game_win)).
%outcome(O) :- precondition(C,O).

%outcome_occurs(O,K) :- outcome_occurs_at(O,(T,K)),
%                     T > 0.
%:- outcome(O),
%   not outcome_occurs(O,O).
   
