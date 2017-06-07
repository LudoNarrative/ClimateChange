
:- action(move(Entity,direction(towards,Other))),
   not result(tick,apply_restitution(Entity,Other)),
   entity(Other).


:- not player_controls(_).

:- action(move(Entity,direction(away,_))),
   not action(apply_restitution(Entity,Entity)).



:- action(move(Entity,direction(towards,_))),
   not action(apply_restitution(Entity,Entity)).


:- 2{precondition(compare(_,_),O)},
   outcome(O).

:- result(O,mode_change(_)),
   not precondition(overlaps(_),O),
   not precondition(compare(_,_),O).

:- only_one_precondition(O),
   precondition(compare(_,_),O),
   result(O,modify(_,_)).



:-  result(O,move(E2,direction(away,E1))),
    result(O2,move(E1,direction(away,E2))).


:- result(O,add(E,_,_)), every_frame(O).

:- 2{result(O,modify(_,R))}, resource(R), outcome(O).

%:- precondition(control_event(click(Entity)),Outcome),
%   precondition(overlaps(Entity),Outcome).


%:- precondition(overlaps(E,E,P),O),
%   not precondition(collide(E,E),O).



%Limitation of Phaser
:- precondition(control_event(_),O),
   precondition(overlaps(E1,E2,true),O),
   result(tick,apply_restitution(E1,E2)).



:- precondition(overlaps(_,_,false),O),
   result(O,mode_change(_)).



%Don't delete something if you click on it and it's also draggable
:-  controlLogic(draggable(E)),
    precondition(control_event(click(E)),O),
    result(O,delete(E)),
    only_one_precondition(O).


:- result(O,delete(E)),
   singular(E).


:- condition(overlaps(E,E,_)), singular(E).

:- result(O,mode_change(_)),
   2 {result(O,_)}.

:- result(O,mode_change(_)),
   not precondition(overlaps(_),O),
   not precondition(compare(_,_),O).


:- result(O,delete(E)),
    result(O,add(E,_,_)). 

    
:-  result(Outcome,mode_change(game_loss;narrative_gating)),
    player_controls_outcome(Outcome).

:-  result(O,modify(_,property(_,E))),
    result(O,delete(E)).

:- condition(overlaps(entity(e(E1)),entity(e(E2)),POLARITY)),
    E2 < E1.
    
:- action(apply_restituion(entity(e(E1)),entity(e(E2)))),
    E2 < E1.
    
:-  precondition(control_event(click(E)),O),
    result(O,add(E,_,_)).
    
:- action(modify(_,property(Property,E))),
   not balanced(property(Property,E)).

:- 5 { initialize(add(E,L,C))},
   entity(E).
   


:- precondition(overlaps(E1,E2,true),O),
   result(O,move(E1,_)).

:- precondition(overlaps(E1,E2,true),O),
   result(O,move(E2,_)).


:-  precondition(compare(ge,R),O),
    result(O,add(E,_,_)),
    precondition(overlaps(E),O2),
    result(O2,modify(increase,R)).


:-  precondition(compare(le,R),O),
    result(O,add(E,_,_)),
    precondition(overlaps(E),O2),
    result(O2,modify(decrease,R)).

buttonPriority(mouse,space).
buttonPriority(space,down_arrow).
buttonPriority(down_arrow,up_arrow).
buttonPriority(up_arrow,left_arrow).
buttonPriority(up_arrow,right_arrow).
buttonPriority(A,C) :-
    buttonPriority(A,B),
    buttonPriority(B,C).

:- not condition(control_event(button(BUTTON1,_))),
   condition(control_event(button(BUTTON2,_))),
   buttonPriority(BUTTON1,BUTTON2).

:- precondition(overlaps(E1,E2,false),O),
   result(O,move(E1,direction(away,E2))).
:- precondition(overlaps(E2,E1,false),O),
   result(O,move(E1,direction(away,E2))).


movement(move(E,D)) :- action(move(E,D)).

:- result(outcome(avatar(M1)),A),
   not result(outcome(avatar(M2)),A),
   outcome(outcome(avatar(M2))),
   not movement(A).


:- 3{result(outcome(avatar(M)),A)}.



:- initialize(set_sprite(E1,S)),
   initialize(set_sprite(E2,S)),
   initialize(set_color(E1,C)),
   initialize(set_color(E2,C)),
   E1 != E2.
   
:- result(O,move(E,_)),
   result(O,delete(E)).

:- result(tick,move(E,direction(towards,E))).


:- result(O,move(E,direction(T_A,E2))),
   2 {result(O2,move(E,direction(T_A,E2)))}.
   
   
:- 2 {initialize(add(_,_,L))},
   initialize(add(_,_,L)).


:- action(move(E,direction(_,E2))),
   2 {action(move(E,direction(_,E2)))}.

:- player_model(Outcome,player_will_attempt),
   trivial(Outcome).

:- player_model(Outcome,player_will_avoid),
   trivial(Outcome).

:- initialize(set_color(E1,C)),
   initialize(set_color(E2,C)),
   initialize(set_sprite(E1,S)),
   initialize(set_sprite(E2,S)),
   E1 != E2.
   

:- player_controls(entity(e(E2))),
   not player_controls(entity(e(E1))),
   entity(entity(e(E1))),
   E1 < E2.


:- precondition(timer_elapsed(_),O1),
   result(O1,modify(increase,R)),
   precondition(timer_elapsed(_),O2),
   result(O2,modify(decrease,R)).

:- reading(good,O),
   trivial(O).

:- action(apply_restitution(E,E)),
   static(E).


:- condition(overlaps(E1,E2,true)),
   action(move(E1,direction(away,E2))),
   {action(move(E1,_))} 1.


:- condition(overlaps(E1,E2,true)),
   action(move(E2,direction(away,E1))),
   {action(move(E2,_))} 1.

{label(entity(E),E)} :- entity(entity(E)).
{label(resource(E),E)} :- resource(resource(E)).
:- 2 {label(E,_)}, entity(E).