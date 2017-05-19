
    
:- action(move(Entity,direction(away,_))),
   not action(apply_restitution(Entity,Entity)).



:- action(move(Entity,direction(towards,_))),
   not action(apply_restitution(Entity,Entity)).

:- action(move(Entity,direction(towards,Other))),
   not action(apply_restitution(Entity,Other)).


%:-  precondition(overlaps(E1,E2,POLARITY),O),
%    precondition(control_event(click(E3)),O).
    
:- outcome(outcome(o(N))), N >= 2, not outcome(outcome(o(N-1))).
:- resource(resource(r(N))), N >= 2, not resource(resource(r(N-1))).
:- entity(entity(e(N))), N >= 2, not entity(entity(e(N-1))).
:- timer(t(N)), N >= 2, not timer(t(N-1)).


:- outcome(O), not has_precondition(O).
:- outcome(O), not has_result(O).

:- 2 {precondition(C,tick)}.

   
:- every_frame(O), precondition(compare(ge,R),O), result(O,modify(decrease,R)).
:- every_frame(O), precondition(compare(le,R),O), result(O,modify(increase,R)).

:- result(tick,move(E,direction(_,E))).


:- condition(overlaps(entity(e(N)),entity(e(N2)),_)),
   N2 < N.

:- action(move(entity(e(E1)),direction(_,entity(e(E2))))),
   E2 < E1.

:- not condition(control_event(click(entity(e(E1))))),
   condition(control_event(click(entity(e(E2))))),
   entity(entity(e(E1))),
   E1 < E2.

:- precondition(overlaps(E1,E2,_),O),
   precondition(control_event(_),O),
   1 { precondition(overlaps(E1,E2,_),_) } 1.

:- precondition(overlaps(E1,E2,true),O1),
   result(O1,delete(entity(E))),
   precondition(overlaps(E1,E2,true),O2),
   precondition(control_event(C),O2),
   O1 != O2.


:- result(O,delete(E1)),
   not precondition(overlaps(_,E1,true),O),
   not precondition(overlaps(E1,_,true),O),
   not precondition(control_event(click(E1)),O).

% Don't have more than 1 control event per outcome
:- 2 {precondition(control_event(EVENT),OUTCOME) }, outcome(OUTCOME).     
:- not playerControls.

%AJS - GETTING RID OF THIS Only 1 avatar
%:-  avatar(ENTITY), 
%    many(ENTITY).



% Don't check more than 1 collision
:- 2 {precondition(overlaps(E1,E2,POLARITY),OUTCOME)}, outcome(OUTCOME).



% simply Don't have more than 2 preconditions
:- 5 {precondition(CONDITION,Outcome)}, outcome(Outcome).



%% different_precondition(O1,O2) :-
%%     precondition(P,O1),
%%     not precondition(P,O2),
%%     outcome(O2).
%% different_precondition(O1,O2) :-
%%     not precondition(P,O1),
%%     precondition(P,O2),
%%     outcome(O1).

different_precondition(O1,O2) :-
    1 {precondition(P,O1);precondition(P,O2)} 1,
    condition(P),
    outcome(O1),
    outcome(O2).

:- has_precondition(O1),
   has_precondition(O2),
   not different_precondition(O1,O2),
   O1 != O2.


:- spatial_condition(E1,E2), not moves(E1), not moves(E2).

  
% require entities
:- entity(Entity), not required(Entity).

% only destroy that which you can create, if it isn't intended to be depleted
:-  required(Entity),
   action(delete(Entity)),
   not action(add(Entity,_,_)),
   not reading(Entity,depletable).

:- action(add(Entity,_,_)),
   not action(delete(Entity)).

% only allow something to decrease on tick if it can be increased
:- result(tick, modify(decrease,R)),
   not action(modify(increase,R)).


% Don't check more than 1 collision
:- 2 {precondition(overlaps(E1,E2,POLARITY),OUTCOME)}, outcome(OUTCOME).



:- resource(Resource), not freeResource(_,Resource).


% simple feedback loop exclusion
% Don't increase a resource on a positive check of it
:- result(Outcome,modify(increase,Resource)),
  precondition(compare(ge,Resource),Outcome).
% don't decrease a resource on negative check of it
:- result(Outcome,modify(decrease,Resource)),
   precondition(compare(le,Resource),Outcome).


:- action( add(Entity,_,_)), singular(Entity).


% constraint on reachability
:- outcome( O), unreachableOutcome(O).


%% Don't check for "mouse button pressed" and "clicking" an entity in the
%  same game
:- condition(control_event(button(mouse,pressed))),
   condition(control_event(click(_))).


% Don't let something move away from the cursor if we need to click on it.
%:- result(O, move(E, direction(away,cursor))),
%   condition(control_event(click(E))).

:- precondition(timer_elapsed(T),Outcome), 2 { precondition(C,Outcome)}.


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

:- 2{precondition(compare(_,_),O)},
   outcome(O).

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
   

% Phaser doesn't allow this
:-  controlLogic(draggable(E)),
    action(apply_restitution(E,_)).
:-  controlLogic(draggable(E)),
    action(apply_restitution(_,E)).

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
{label(resource(E),E)} :- resource(resoruce(E)).
:- 2 {label(E,_)}, entity(E).
:- 2 {label(E,_)}, resource(E).
:- entity(E), not label(E,_).
:- resource(E), not label(E,_).

:-  controlLogic(draggable(E)),
    action(move(E,_)).

:- precondition(control_event(click(E)),O),
   precondition(overlaps(E),O),
   computer_controls(E).

