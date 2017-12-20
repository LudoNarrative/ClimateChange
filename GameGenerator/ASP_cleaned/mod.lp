%%%%%%% SHOULDN"T HAVE TO CHANGE

:- 2 {precondition(compare(_,amount(Color),_),O)}.

:- 2 {action(draw(E,C));
      action(clear(E))},
   entity(E).

:- 2{result(O,draw(_,_));
     result(O,clear(_))},
   outcome(O).

:- 3 {precondition(control_event(_),O)},
   outcome(O).
% constraint on reachability
:- outcome(O), unreachableOutcome(O).

:- precondition(overlaps(_,_,_),O),
   result(O,draw(_,_)).

:- precondition(overlaps(_,_,_),O),
   result(O,clear(_)).