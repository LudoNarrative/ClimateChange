%%%%%%% SHOULDN"T HAVE TO CHANGE
:- outcome(O), not has_precondition(O).
:- outcome(O), not has_result(O).

:- result(O,mode_change(_)),
   2 {result(O,_)}.


has_both(O) :-   precondition(control_event(click(_)),O),
		 precondition(control_event(button(mouse,pressed)),O).

:- 2 {precondition(control_event(_),O)},
   not has_both(O),
   outcome(O).


:- precondition(timer_elapsed(_),O),
   2{ precondition(_,O)}.


:- precondition(compare(_,distance(_,_,_),_),O),
   result(O,draw(_,_)).

:- precondition(compare(_,distance(_,_,_),_),O),
   result(O,clear(_)).


:- precondition(overlaps(_,_,_),O),
   result(O,draw(_,_)).

:- precondition(overlaps(_,_,_),O),
   result(O,clear(_)).

:- 2 {precondition(compare(_,amount(Color),_),O)}.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
:- reading(good,O),
   trivial(O),
   not entity_related(O).