
:- outcome(OUTCOME), not completeOutcome(OUTCOME).

:- precondition(overlaps(E1,E2,_),O),
   precondition(control_event(_),O),
   1 { precondition(overlaps(E1,E2,_),_) } 1.


% Don't have more than 1 control event per outcome
:- 2 {precondition(control_event(EVENT),OUTCOME) }, outcome(OUTCOME).     
:- not playerControls.

% Only 1 avatar
:-  avatar(ENTITY), 
    many(ENTITY).

% avatar precludes movement
:-  movementScheme(ENTITY,SCHEME),
    avatar(ENTITY).

% things can have multiple movement - but only 1 way to follow a path
:-  2 {movementScheme(ENTITY,path(TYPE))}, 
    entity(ENTITY).

% Don't be attracted to yourself
:- attracted_to(ENTITY,ENTITY).

% Don't be repulsed by yourself
:- repeled_by(ENTITY,ENTITY).

% Don't be attracted to and repulsed by at the same time
:- attracted_to(ENTITY,OTHER), repeled_by(ENTITY,OTHER).
:- attracted_to(ENTITY,OTHER), repeled_by(OTHER,ENTITY).

% static means it doesn_primet move
:- static(ENTITY), avatar(ENTITY).
:- static(ENTITY), controlScheme(ENTITY,SCHEME).
:- static(ENTITY), movementScheme(ENTITY,SCHEME).
:- static(ENTITY), interaction(OTHER,ENTITY,push).
:- static(ENTITY), interaction(OTHER,ENTITY,bounce).
:- static(ENTITY), result(Outcome,moves(ENTITY,Direction)).
:- static(Entity), effect(move_away(E, E_prime)).
:- static(Entity), effect(move_towards(E, E_prime)).



% cleanliness
:- entity(E2), not entity(E1), entityOrdering(E1,E2).
:- resource(E2), not resource(E1), resourceOrdering(E1,E2).


%if something helps it must help in some way
:- not actuallyHelps(ENTITY1,ENTITY2), interaction(ENTITY1,ENTITY2,help) .

%if something hurts it must hurt in some way
:- not actuallyHurts(ENTITY1,ENTITY2), interaction(ENTITY1,ENTITY2,hurt) .

%if something is placed on a path must have a valid one.
:- placement(ENTITY,TYPE,path(TYPE)), not validPathPlacement.

%if goal is to reach end must have a start and end
:- goal(reach(end)), not placement(ENTITY, path(start)), avatar(ENTITY).  
:- goal(reach(end)), not placement(ENTITY, path(end)), avatar(ENTITY).   

% Don't increase or decrease in more than 1 way per resource, per outcome
% CRM and MM 6/20/2016: We could turn this into a proceduralist reading
% constraint with a notion of "confusingness."
:- 2 {result(OUTCOME, decrease(RESOURCE,AMOUNT)) : potentialValues(AMOUNT)}, 
    resource(RESOURCE), 
    outcome(OUTCOME). 
    
:- 2 {result(OUTCOME, increase(RESOURCE,AMOUNT)): potentialValues(AMOUNT)}, 
    resource(RESOURCE), 
    outcome(OUTCOME). 
    
% Don't increase and decrease at the same time
:-  result(OUTCOME,increase(RESOURCE,AMOUNT1)), 
    result(OUTCOME,decrease(RESOURCE,AMOUNT2)).
    
% Don't have 2 resources counting the same thing
:- 2 {resourceLogic(RESOURCE,count(ENTITY)) : resource(RESOURCE)},
    entity(ENTITY).
% Don't have 2 entities counted by the same thing
:- 2 {resourceLogic(RESOURCE,count(ENTITY)) : entity(ENTITY)},
    resource(RESOURCE).
% Don't count and do transactions on a resource
:-  resourceLogic(RESOURCE,count(ENTITY)), 
    transaction(RESOURCE,TRANSACTION).
    
% can only change at most N resources per outcome
:- max_resource_change_per + 1  {changes(OUTCOME,CHANGE, CV,V) :
				 resource(CV),
				 potentialValues(V), 
				 change(CHANGE)}, 
   outcome(OUTCOME).
% :-  2 {changes(OUTCOME,CHANGE,CV,V)}, 
    % outcome(OUTCOME), 
    % resource(CV).        
        
% can't try to prevent and achieve an outcome        
:- goal(prevent(OUTCOME)), goal(achieve(OUTCOME)).

%tick must occur alone
:-  precondition(tick,OUTCOME), 
    2 { precondition(CONDITION,OUTCOME) : condition(CONDITION)}.
% cleanliness - choose e1 before e2
:- condition(overlaps(A,B,POLARITY)), entityOrdering(B,A).
:- condition(collide(A,B)), entityOrdering(B,A).
%:- condition(collide(A,A)).

:- outcome(B), not outcome(A), outcomeOrder(A,B).


%an outcome shouldn't result in game win and game loss simultaneously
:-  result(OUTCOME,mode_change(END)), 
    end_mode(END),
    2 {result(OUTCOME,EFFECT) : effect(EFFECT)}.



%it should not be the case that you care about a value being above a high value and below a low value
:-  below(RESOURCE_L,OUTCOME), 
    above(RESOURCE_H,OUTCOME), 
    lower_than(VALUE_L_H).
    
% CRM 7/4/2016: Actually, let's not have a mode change outcome create any
% results other than the mode change.
:- result(Outcome, mode_change(M)), result(Outcome, R_prime),
    R_prime != mode_change(M).
    
%Don't tie losing or winning to a button press (press space to lose feels odd)
:-  precondition(control_event(EVENT),OUTCOME),
    result(OUTCOME,mode_change(END)), 
    end_mode(END).
 
% certain things tick shouldn't do
:-  precondition(tick,OUTCOME), 
    result(OUTCOME,set_to(RESOURCE)).
:-  precondition(tick,OUTCOME), 
    result(OUTCOME,mode_change(MODE)).
:-  precondition(tick,OUTCOME), 
    result(OUTCOME,change_color(ENTITY,COLOR,TIME)).
:-  precondition(tick,OUTCOME), 
    result(OUTCOME,set_sprite(ENTITY,SPRITE)). 

% Don't have complex button pressing states
:- 2 {precondition(control_event(BUTTON,STATE),OUTCOME)
 : buttons(BUTTON), buttonStates(STATE)}, outcome(OUTCOME).

% Don't move in multiple ways per outcome
:- 2{result(OUTCOME,moves(ENTITY,DIRECTION,AMOUNT)) :direction(DIRECTION), potentialValues(AMOUNT)}, outcome(OUTCOME),entity(ENTITY).

% CRM 6/23/2016 - what about deleting it and then adding it in a new place?
%   maybe that should be a distinct "set location" result.
% Don't add and delete an entity as part of outcome
:- result(Outcome,add(Entity,Place)),
   result(Outcome,delete(Entity)).
    
% require entities
:- entity(Entity), not required(Entity).

% only destroy that which you can create
:-  required(Entity),
   effect(delete(Entity)),
   not effect(add(Entity,_)).

%screen stuff
:- many(E), screen(E).
:- precondition(overlaps(E1,E2,Polarity),Outcome), screen(E1),screen(E2).


% only allow something to decrease on tick if it can be increased
:- result(tick, decrease(R, A)),
   not effect(increase(R, _)).

% more screen stuff
:- effect(delete(E)), screen(E).
:- effect(add(E, Place)), screen(E).
:- interaction(E1,E2,TYPE), screen(E1), screen(E2).
:- placement(E,_,_), screen(E).


% Don't care about counting something if its count can't change
:- resourceLogic(Resource,count(Entity)), 
    {effect(delete(Entity));
    effect(add(Entity, Place))} 0.
% counting something means it can only be changed by addition/deletion
:- resourceLogic(Resource,count(Entity)), 
    1 {effect(increase(Resource));
       effect(decrease(Resource))}.


% Don't have 2 separate ways of overlapping for an outcome

% Don't check more than 1 collision
:- 2 {precondition(overlaps(E1,E2,POLARITY),OUTCOME)}, outcome(OUTCOME).



% simply Don't have more than 2 preconditions
:- 3 {precondition(CONDITION,Outcome)}, outcome(Outcome).
:- resource(Resource), not freeResource(Resource).

% simple feedback loop exclusion
% Don't increase a resource on a positive check of it
:- result(Outcome,increase(Resource)),
  precondition(ge(Resource),Outcome).
% don't decrease a resource on negative check of it
:- result(Outcome,decrease(Resource)),
   precondition(le(Resource),Outcome).


:- result(Outcome, add(Entity, Place)), singular(Entity), 
   not maintains_singular(Outcome, Entity).

% require something to be present before deleting it
:- result(Outcome, delete(Entity)), not requires(Outcome, Entity).

%%%% CRM 6/28/2016 - moved these over from constraint-experiments
%% Implication and contradiction
:- precondition(X, O), precondition(Y, O), implies(X, Y), X != Y.
:- precondition(X, O), precondition(Y, O), contradictory(X, Y).

:- condition(C), spatial_condition(C, E1, E2), not one_moves(E1, E2).

%% Don't initialize things in a way that could change the mode right away
:- precondition(C, O), result(O, mode_change(Mode)),
    initialize(R), result_enables_condition(R, C). 


%% Don't decrease an entity by itself
:- effect(decrease(R, R)).

%% Don't decrease or increase by 0
:- effect(increase(R, 0)).
:- effect(decrease(R, 0)).


% constraint on reachability
:- precondition(_, O), unreachableOutcome(O).

%:- result(O, add(E,Amount, P)), not controlled(O).
:- result(O, delete(E)), not controlled(O).

%%%% Misc - should be organized at some point.

%% Don't have a result that's also a result of tick
:- condition(far(E2,E1)), entityOrdering(E1,E2).

%%%% Controls
%% Don't check for "mouse button pressed" and "clicking" an entity in the
%  same game
:- condition(control_event(button(mouse_button,pressed))),
   condition(control_event(click(_))).

:- outcome(O), not intermediate_outcome(O).

:- 3 {precondition(overlaps(E1,E2,POLARITY),OUTCOME)},
    entity(E1),
    entity(E2),
    polarity(POLARITY).

% misc
:- effect(increase(R,R)).
:- effect(decrease(R,R)).

% Don't let something move away from the cursor if we need to click on it.
:- result(O, move_away(E, cursor)), condition(control_event(click(E))).

:- precondition(timerElapsed(T),Outcome), 2 { precondition(C,Outcome)}.

    
:-  onlyOnePrecondition(O),
    above(R,O),
    result(O,increase(R2,A)).
    
:-  onlyOnePrecondition(O),
    above(R,O),
    result(O,decrease(R2,A)).
          
:-  onlyOnePrecondition(O),
    below(R,O),
    result(O,increase(R2,A)).
    
:-  onlyOnePrecondition(O),
    below(R,O),
    result(O,decrease(R2,A)).
    
:-  result(O,move_away(E2,E1)),
    result(O2,move_away(E1,E2)).

:-  result(O,increase(R1,R2)),
    result(O,increase(R2,R1)).

:-  result(O,decrease(R1,R2)),
    result(O,decrease(R2,R1)).
    
:- 3 {move(T,E)}, entity(E).

:- speed(E,0).

:- 2 {result(O,add(E,L))}, outcome(O).


% Nested for loops are weird
:- 2{   precondition(ge(PE),O);precondition(le(PE),O)},
    outcome(O).
% for simplicity - don't allow perEntity things on the right hand side
        
%only have per entity checks if it affects the given entity
:-  1 { precondition(ge(PV),O); 
        precondition(le(PV),O) },
    {result(O,increase(PV2));result(O,decrease(PV2))} 0,
    perEntity(PV),
    perEntity(PV2).    
    
%:- result(O,delete(E)), every_frame(O).
:- result(O,add(E,L)), every_frame(O).


:- result(O,move_towards(E1,E3)),
   result(O,move_towards(E2,E3)),
   result(O,move_towards(E1,E2)).
   

    

:- result(O, mode_change(game_loss)), not onlyOnePrecondition(O).

:- result(O,increase(R)),
   result(O,decrease(R)).

:- precondition(control_event(click(E)),O),
   precondition(overlaps(E,_,true),O).

:- precondition(control_event(click(E)),O),
   precondition(overlaps(_,E,true),O).

:- controlLogic(draggable(E)),
   result(_,moves(E,_)).

:- controlLogic(draggable(E)),
   result(_,move_towards(E,_)).
:- controlLogic(draggable(E)),
   result(_,move_away(E,_)).


:- result(_,add(E,E)).

:- interpretation(E,consumes(R)),
   interpretation(E,creates(R)).

:- precondition(overlaps(E,E,P),O), not precondition(collide(E,E),O).


:- result(O,add(E1,E2)),
   1{precondition(overlaps(E1,E2,POL),O2);
     precondition(collide(E1,E2),O2);
     precondition(overlaps(E2,E1,POL),O2);
     precondition(collide(E2,E1),O2)}.

:- entity(E1),entity(E2),
   2 { precondition(collide(E1,E2),O2)}.




:- precondition(overlaps(E1,E2,true),O),
   result(O,add(E2,E1)).

:- precondition(overlaps(E1,E2,true),O),
   result(O,add(E1,E2)).

:- 2 { clickOnOverlap(E1,E2,O)}, entity(E1),entity(E2).

%Limitation of Phaser
:- precondition(control_event(_),O),
   precondition(overlaps(E1,E2,true),O),
   precondition(collide(E1,E2),_).

:- result(_,add(E1,E2)),
   result(_,add(E2,E1)).


:- result(O,delete(E1)),
   not precondition(overlaps(_,E1,true),O),
   not precondition(overlaps(E1,_,true),O),
   not precondition(overlaps(E1,_,true),O),
   not precondition(control_event(click(E1)),O).

:- result(O,add(E1,E2)),
   precondition(overlaps(E4,E3,true),O),
   E3 != E2,
   E4!=E2.


:- precondition(overlaps(_,_,false),O),
   result(O,mode_change(_)).


:- precondition(control_event(click(E3)),O),
   result(O,add(E1,E2)),
   E2 != E3.

:- precondition(control_event(button(Button,_)),O1),
   precondition(control_event(button(Button,_)),O2),
   1{precondition(Condition,O1)}1,
   1{precondition(Condition,O2)}1,
   O1 != O2.


:- 1 {
	   precondition(le(R),O);
	   precondition(ge(R),O);
	   precondition(lt(R),O);
	   precondition(gt(R),O)},
   1 {
	   result(O,increase(R));
	   result(O,decrease(R))},
   resource(R),
   precondition(_,O),
   1 {precondition(C,O)} 1.


%Don't delete something if you click on it and it's also draggable
:-
    controlLogic(draggable(E)),
    precondition(control_event(click(E)),O),
    result(O,delete(E)),
    1 { precondition(_,O)} 1.

:-precondition(control_event(click(E1)),O),
  precondition(overlaps(E2,E3,false),O).

:- result(tick,add(E,_)).

:- result(_,add(E2,E1)),
   entityOrdering(E1,E2).

:- 2 {result(O,add(E1,E2))},
   result(_,add(E1,E2)).

:- precondition(C,O1),
   result(O1,mode_change(_)),
   2 {precondition(C,_)}.

:- precondition(control_event(_),O),
   result(O,mode_change(_)).

:- playerDetermines(O),
   result(O,mode_change(_)).

:- precondition(control_event(click(E2)),O),
   precondition(overlaps(E1,E3,true),O).


:- result(O,delete(E)),
   singular(E).


differentPreconditions(O1,O2) :-
    precondition(A,O1),
    precondition(B,O2),
    O1 != O2,
    A != B.

:- precondition(_,O1),
   precondition(_,O2),
   O1 != O2,
   not differentPreconditions(O1,O2).
   
