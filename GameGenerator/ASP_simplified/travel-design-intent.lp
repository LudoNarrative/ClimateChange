#const min_entities = 1.
#const max_entities = 2.
#const min_resources = 1.
#const max_resources = 3.
#const min_outcomes = 0.
#const max_outcomes = 7.

#const min_end_outcomes = 1.
#const max_end_outcomes = 1.
#const max_resource_change_per = 2.
#const max_conditions_per = 2.


%% Prose version:
% Decision making for how to spend a resource between several choices
% Spending a resource creates a tradeoff between r2 and r3
% r2 represents something harmful related to climate

existsAllocationChoice :- allocation_choice(_, _, _).
goesNegative(R)
  :- result(O, decrease(R, Amount)),
      not precondition(O, ge(R, Amount)). 
representsMoney(R)
  :- allocation_choice(_, _, R), not goesNegative(R).
has_money :- representsMoney(r1).
     
:- not has_money.

% two monotically increasing resources, for carbon and fame
twoMIRs :-
  monotonicallyIncreases(Resource1),
  monotonicallyIncreases(Resource2),
  Resource1 != Resource2.

:- not twoMIRs.

% player decides when game ends
playerEndsGame :- result(O, mode_change(M)), playerDetermines(O).
:- not playerEndsGame.

% At most 2 control events
% :- precondition(control_event(X), O1), precondition(control_event(Y), O2),
%     precondition(control_event(Z), O3),
%     O1 != O2, O2 != O3, O1 != O3.
