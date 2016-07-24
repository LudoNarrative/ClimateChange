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
:- static(ENTITY), interaction(OTHER,ENTITY,collide).
:- static(ENTITY), result(Outcome,moves(ENTITY,AMOUNT)).
:- static(Entity), effect(move_away(E, E_prime)).
:- static(Entity), effect(move_towards(E, E_prime)).
:- static(ENTITY), effect(apply_restitution(ENTITY,AMOUNT)).

% cleanliness
:- entity(E2), not entity(E1), entityOrdering(E1,E2).
:- resource(E2), not resource(E1), resourceOrdering(E1,E2).

% so, if it says it helps/hurts, it actually should
actuallyHelps(help(ENTITY1,ENTITY2)) :- 
    result(help(ENTITY1,ENTITY2),increase(G_RESOURCE)), good(RESOURCE). 
actuallyHelps(help(ENTITY1,ENTITY2)) :-
    result(help(ENTITY1,ENTITY2),decrease(B_RESOURCE)), bad(RESOURCE).
% actuallyHelps(help(ENTITY1,ENTITY2)) :-
    % result(help(ENTITY1,ENTITY2),spawn(ENTITY)), helpful(ENTITY).
actuallyHurts(hurt(ENTITY1,ENTITY2)) :-
    result(hurt(ENTITY1,ENTITY2),increase(G_RESOURCE)), bad(G_RESOURCE).   
actuallyHurts(hurt(ENTITY1,ENTITY2)) :-
    result(hurt(ENTITY1,ENTITY2),decrease(B_RESOURCE)), good(B_RESOURCE).     
% actuallyHurts(hurt(ENTITY1,ENTITY2)) :-
    % result(hurt(ENTITY1,ENTITY2),spawn(ENTITY)),  harmful(ENTITY).
        

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
% Don't overlap with itself
:- precondition(overlaps(ENTITY,ENTITY,POLARITY),OUTCOME).

% can only change at most N resources per outcome
:- max_resource_change_per + 1  {changes(OUTCOME,CHANGE, CV,V) :
				 resource(CV),
				 potentialValues(V), 
				 change(CHANGE)}, 
   outcome(OUTCOME).
:-  2 {changes(OUTCOME,CHANGE,CV,V)}, 
    outcome(OUTCOME), 
    resource(CV).        
        
% can't try to prevent and achieve an outcome        
:- goal(prevent(OUTCOME)), goal(achieve(OUTCOME)).

% same - can't be good and bad
:- bad(RESOURCE), good(RESOURCE).


        
%tick must occur alone
:-  precondition(tick,OUTCOME), 
    2 { precondition(CONDITION,OUTCOME) : condition(CONDITION)}.

%priority(Outcome,high) :- precondition(control_event(E),Outcome).
%:- priority(OUTCOME1,high), not priority(OUTCOME2), outcomeOrder(OUTCOME2,OUTCOME1).
  
    
% outcomes must be different - perhaps this is overly strong
% should subsets be allowed?  
% CRM 6/15/2016 commented out for debugging
% :-  not differentL(OUTCOME1,OUTCOME2), 
%    outcome(OUTCOME1),outcome(OUTCOME2),
%    outcomeOrder(OUTCOME1,OUTCOME2),
%    same(OUTCOME1,OUTCOME2). 
 
%:-  not differentR(OUTCOME1,OUTCOME2), 
%    outcome(OUTCOME1),outcome(OUTCOME2),
%    outcomeOrder(OUTCOME1,OUTCOME2),
%    same(OUTCOME1,OUTCOME2). 
 
% not sure if these are needed
% was trying to have something about how certain outcomes
% are more important
modeChanging(Outcome) :-
    result(Outcome,mode_change(MODE)).
    
moreSevere(OutcomeA,OutcomeB) :- 
    modeChanging(OutcomeA),
    outcome(OutcomeB),
    not modeChanging(OutcomeB). 
    
% Don't compare 1 resource for more than 1 value   
:-  2 {precondition(lt(RESOURCE,VALUE),OUTCOME) :
            potentialValues(VALUE)}, 
        outcome(OUTCOME), 
        resource(RESOURCE).
        
% Don't compare 1 resource for more than 1 value   
:-  2 {precondition(ge(RESOURCE,VALUE),OUTCOME) :
            potentialValues(VALUE)}, 
        outcome(OUTCOME), 
        resource(RESOURCE).
        
% Don't compare 1 resource for more than 1 value   
:-  2 {precondition(gt(RESOURCE,VALUE),OUTCOME) :
            potentialValues(VALUE)}, 
        outcome(OUTCOME), 
        resource(RESOURCE).
    
% Don't compare 1 resource for more than 1 value   
:-  precondition(le(RESOURCE,VALUE),OUTCOME), 
    precondition(lt(RESOURCE,VALUE2),OUTCOME).
    
% Don't compare 1 resource for more than 1 value   
:-  precondition(ge(RESOURCE,VALUE),OUTCOME), 
    precondition(gt(RESOURCE,VALUE2),OUTCOME).

    

%generic above below to do interval reasoning 
below(RESOURCE,VALUE,OUTCOME) :- 
    precondition(le(RESOURCE,VALUE),OUTCOME).

below(RESOURCE,VALUE,OUTCOME) :-     
    precondition(lt(RESOURCE,VALUE),OUTCOME).
    
above(RESOURCE,VALUE,OUTCOME) :- 
    precondition(ge(RESOURCE,VALUE),OUTCOME).
above(RESOURCE,VALUE,OUTCOME) :- 
    precondition(gt(RESOURCE,VALUE),OUTCOME).

%helpers
conditionedOnResource(RESOURCE,OUTCOME) :- above(RESOURCE,VALUE,OUTCOME).
conditionedOnResource(RESOURCE,OUTCOME) :- below(RESOURCE,VALUE,OUTCOME).


%it should not be the case that you care about a value being above a high value and below a low value
:-  below(RESOURCE,VALUE_L,OUTCOME), 
    above(RESOURCE,VALUE_H,OUTCOME), 
    lower_than(VALUE_L,VALUE_H).
    
outcome(A) :- result(A,E).    
% cleanliness - choose e1 before e2
:- entity(B), not entity(A), entityOrdering(A,B).
:- condition(overlaps(A,B,POLARITY)), entityOrdering(B,A).

:- outcome(B), not outcome(A), outcomeOrder(A,B).


%an outcome shouldn't result in game win and game loss simultaneously
:-  result(OUTCOME,mode_change(END)), 
    end_mode(END),
    2 {result(OUTCOME,EFFECT) : effect(EFFECT)}.

% CRM 7/4/2016: Actually, let's not have a mode change outcome create any
% results other than the mode change.
:- result(Outcome, mode_change(M)), result(Outcome, R_prime),
    R_prime != mode_change(M).
    
%Don't tie losing or winning to a button press (press space to lose feels odd)
:-  precondition(control_event(BUTTON,STATE),OUTCOME),
    result(OUTCOME,mode_change(END)), 
    end_mode(END).
:-  precondition(control_event(EVENT),OUTCOME),
    result(OUTCOME,mode_change(END)), 
    end_mode(END).
 
% certain things tick shouldn't do
:-  precondition(tick,OUTCOME), 
    result(OUTCOME,set_to(RESOURCE,VALUE)).
:-  precondition(tick,OUTCOME), 
    result(OUTCOME,mode_change(MODE)).
:-  precondition(tick,OUTCOME), 
    result(OUTCOME,change_color(ENTITY,COLOR,TIME)).
:-  precondition(tick,OUTCOME), 
    result(OUTCOME,set_sprite(ENTITY,SPRITE)). 
:-  precondition(tick,OUTCOME),
    changes(OUTCOME,CHANGE,CV,high).
:-  precondition(tick,OUTCOME),
    changes(OUTCOME,CHANGE,CV,mid).
    

    
% Don't check resources against multiple things per outcome per direction    
:- 2 { precondition(le(RESOURCE,VALUE1),OUTCOME) ; precondition(lt(RESOURCE,VALUE2),OUTCOME) : potentialValues(VALUE1),potentialValues(VALUE2)} , resource(RESOURCE), outcome(OUTCOME).
% Don't check resources against multiple things per outcome per direction
:- 2 { precondition(ge(RESOURCE,VALUE1),OUTCOME) ; precondition(gt(RESOURCE,VALUE2),OUTCOME) : potentialValues(VALUE1),potentialValues(VALUE2)} , resource(RESOURCE), outcome(OUTCOME).

% Don't have complex button pressing states
:- 2 {precondition(control_event(BUTTON,STATE),OUTCOME)
 : buttons(BUTTON), buttonStates(STATE)}, outcome(OUTCOME).

% Don't move in multiple ways per outcome
:- 2{result(OUTCOME,moves(ENTITY,DIRECTION,AMOUNT)) :direction(DIRECTION), potentialValues(AMOUNT)}, outcome(OUTCOME),entity(ENTITY).

thresholded(RESOURCE) :-
    1{ precondition(ge(RESOURCE,THRESH),OUTCOME);
       precondition(le(RESOURCE,THRESH),OUTCOME);
       precondition(gt(RESOURCE,THRESH),OUTCOME);
       precondition(lt(RESOURCE,THRESH),OUTCOME)}, resource(RESOURCE).
       
       
changes(RESOURCE) :-
    1{ result(OUTCOME,increase(RESOURCE,AMOUNT));
        result(OUTCOME,decrease(RESOURCE,AMOUNT))}, resource(RESOURCE).

%resources should both change and be compared against
meaningfulResource(RESOURCE) :- 
    changes(RESOURCE),
    thresholded(RESOURCE).
:- resource(RESOURCE),
    not meaningfulResource(RESOURCE).


% CRM 6/23/2016 - what about deleting it and then adding it in a new place?
%   maybe that should be a distinct "set location" result.
% Don't add and delete an entity as part of outcome
:- result(Outcome,add(Entity, Place)),
   result(Outcome,delete(Entity)).
    

%an entity only matters if something wants to collide against it/click it
required(Entity) :- precondition(control_event(click(Entity)), Outcome).
required(Entity) :- precondition(overlaps(Entity,_,_), Outcome).
required(Entity) :- precondition(overlaps(_,Entity,_), Outcome).
% CRM 6/23/2016 - or if something requires it to be present
required(Entity) :- precondition(present(Entity), Outcome).
% CRM 6/23/2016 - or if something generates it, maybe?
% CRM 6/27/2016 - or if it_primes required according to rules
required(Entity) :- requires(_, Entity).

% require entities
:- entity(Entity), not required(Entity).

% only destroy that which you can create
:-  required(Entity),
   effect(delete(Entity)),
   not effect(add(Entity, _)).

%screen stuff
:- many(E), screen(E).
:- precondition(overlaps(E1,E2,Polarity),Outcome), screen(E1),screen(E2).

% only allow something to increase on tick if it can be decreased
% :- result(tick, increase(Resource,Amount)),
%    not effect(decrease(Resource,Amt)),
%    potentialValues(Amt).
% Define the above as a "score" value.
score(R)
  :- effect(increase(R, Amount)),
     not effect(decrease(R, _)),
     not lhThreshold(_, R).

% only allow something to decrease on tick if it can be increased
:- result(tick, decrease(R, A)),
   not effect(increase(R, _)).

% more screen stuff
:- effect(delete(E)), screen(E).
:- effect(add(E, Place)), screen(E).
:- interaction(E1,E2,TYPE), screen(E1), screen(E2).
:- placement(E,_,_), screen(E).

% Don't threshold an outcome on 2 things
:-  2{precondition(COND,Outcome) : lhThreshold(COND,Resource,Thresh)},
  outcome(Outcome).

% Don't care about counting something if it_primes count can't change
:- resourceLogic(Resource,count(Entity)), 
    {effect(delete(Entity));
    effect(add(Entity, Place))} 0.
% counting something means it can only be changed by addition/deletion
:- resourceLogic(Resource,count(Entity)), 
    1 {effect(increase(Resource,Amount));
        effect(decrease(Resource,Amount))}.
        
% helper
effect(EFFECT) :- 
    result(OUTCOME,EFFECT).
% probably overly strong - but Don't have the same effect pop up multiple places
% :- 2 {result(OUTCOME,EFFECT)}, effect(EFFECT).

% an outcome needs result and precondition
completeOutcome(OUTCOME) :- 
    result(OUTCOME,EFFECT),
    precondition(CONDITION,OUTCOME).
:- outcome(OUTCOME), not completeOutcome(OUTCOME).

% Don't have 2 separate ways of overlapping for an outcome
:- precondition(overlaps(ENTITY1,ENTITY2,POLARITY), OUTCOME),
   precondition(overlaps(ENTITY2,ENTITY1,OTHER), OUTCOME).

% Don't check more than 1 collision
:- 2 {precondition(overlaps(E1,E2,POLARITY),OUTCOME)}, outcome(OUTCOME).

% simply Don't have more than 2 preconditions
:- 3 {precondition(CONDITION,Outcome)}, outcome(Outcome).

% a resource is free if there is a way to decrease/increase not conditioned on the same resource - i.e. some way to change things
freeResource(Resource) :- 
    resource(Resource), 
    1{result(Outcome,increase(Resource,Amount));
      result(Outcome,decrease(Resource,Amount_prime))},
    not conditionedOnResource(Resource,Outcome),
    outcome(Outcome).
:- resource(Resource), not freeResource(Resource).

% simple feedback loop exclusion
% Don't increase a resource on a positive check of it
:- result(Outcome,increase(Resource,Amount)),
  precondition(ge(Resource,Other),Outcome).
% dont_prime decrease a resource on negative check of it
 :- result(Outcome,decrease(Resource,Amount)),
   precondition(le(Resource,Other),Outcome).

% CRM 6/27/2016
% Removing this constraint for now:
% Don't want things popping away because of other things (although maybe
% clicking is ok?)
% :-  result(Outcome,delete(Entity)), 
%     {precondition(overlaps(Entity,Other),Outcome);
%      precondition(overlaps(Other,Entity),Outcome)} 0.

% Don't have more than 1 control event per outcome
:- 2 {precondition(control_event(EVENT),OUTCOME) }, outcome(OUTCOME).     

%players must have controls or it_primes just a weird movie
playerControls :- precondition(control_event(EVENT),OUTCOME).
:- not playerControls.

% count number of results

% outcomes(N) :- N = #count{outcome(OUTCOME) : outcome(OUTCOME)}.

% results(N) :- N = #count{result(OUTCOME,EFFECT) : result(OUTCOME,EFFECT)}.

% %count number of preconditions
% preconditions(N) :- N = #count{precondition(CONDITION,OUTCOME) : precondition(CONDITION,OUTCOME)}.

% :- outcomes(N), N > 4.

:- singular(E), 
    result(Outcome, delete(Entity)), 
    not result(Outcome, add(Entity)).

% CRM 6/27/2016 - only add a singular entity if it_primes absent beforehand.
maintains_singular(Outcome, Entity)
  :- precondition(absent(Entity), Outcome).
maintains_singular(Outcome, Entity)
  :- result(Outcome, delete(Entity)).

:- result(Outcome, add(Entity, Place)), singular(Entity), 
   not maintains_singular(Outcome, Entity).

% require something to be present before deleting it
:- result(Outcome, delete(Entity)), not requires(Outcome, Entity).

%%%% CRM 6/28/2016 - moved these over from constraint-experiments
%% Implication and contradiction
:- precondition(X, O), precondition(Y, O), implies(X, Y), X != Y.
:- precondition(X, O), precondition(Y, O), contradictory(X, Y).

%% Don't condition on presence/absence unless the entity is deleted.
:- condition(present(E)), not effect(delete(E)).
:- condition(absent(E)), not effect(delete(E)).

% can't test for a spatial condition unless at least one of the entities
% can move.

:- condition(C), spatial_condition(C, E1, E2), not one_moves(E1, E2).

one_moves(E1, E2)
  :- moves(E1), entity(E2).

one_moves(E1, E2)
  :- moves(E2), entity(E1).

moves(E)
  :- effect(move_toward(E, X)).

moves(E)
  :- effect(move_away(E, X)).

moves(E)
  :- controlScheme(E, Scheme).

moves(E)
  :- effect(move_selected(E)).

moves(E)
  :- effect(moves(E, Direction, Amount)).
%%%%

%% Don't initialize things in a way that could change the mode right away
:- precondition(C, O), result(O, mode_change(Mode)),
    initialize(R), result_enables_condition(R, C). 

% Game loss should have just one precond - simplifies things.
% Could be relaxed.
:- result(O, mode_change(game_loss)), not onlyOnePrecondition(O).

%% Don't decrease an entity by itself
:- effect(decrease(R, R)).

%% Don't decrease or increase by 0
:- effect(increase(R, 0)).
:- effect(decrease(R, 0)).


%%%% Reachability %%%%

reachableResult(R)
  :- initialize(R).

reachableCondition(C)
  :- result_enables_condition(R, C),
      reachableResult(R).

reachableCondition(control_event(E))
  :- condition(control_event(E)).

reachableCondition(tick)
  :- condition(tick).

reachableCondition(timerElapsed(T))
  :- condition(timerElapsed(T)).
  
reachableOutcome(O)
  :- precondition(_, O), not unreachableOutcome(O).

unreachableOutcome(O)
  :- precondition(C, O), not reachableCondition(C).

reachableResult(R)
  :- result(O, R), reachableOutcome(O).

% constraint on reachability
:- precondition(_, O), unreachableOutcome(O).


similar(C,O1,O2) :- 
    precondition(C,O1),
    precondition(C,O2),
    O1 != O2,
    outcomeOrder(O1,O2).

similar(below(RESOURCE,VALUE1),O1,O2) :- 
    below(RESOURCE,VALUE1,O1),
    below(RESOURCE,VALUE2,O2),
    O1 != O2,
    outcomeOrder(O1,O2).
   
   
similar(below(RESOURCE,VALUE2),O1,O2) :- 
    below(RESOURCE,VALUE1,O1),
    below(RESOURCE,VALUE2,O2),
    O1 != O2,
    outcomeOrder(O1,O2).
    
similar(timerElapsed(T1),O1,O2) :- 
    precondition(timerElapsed(T1),O1),
    precondition(timerElapsed(T2),O2),
    O1 != O2,
    outcomeOrder(O1,O2).
  
similar(timerElapsed(T1),O1,O2) :- 
    precondition(tick(T1),O1),
    precondition(timerElapsed(T2),O2),
    O1 != O2,
    outcomeOrder(O1,O2).
    
similar(timerElapsed(T1),O1,O2) :- 
    precondition(timerElapsed(T1),O1),
    precondition(tick(T2),O2),
    O1 != O2,
    outcomeOrder(O1,O2).
similar(above(RESOURCE,VALUE1),O1,O2) :- 
    above(RESOURCE,VALUE1,O1),
    above(RESOURCE,VALUE2,O2),
    O1 != O2,
    outcomeOrder(O1,O2).
    
similar(above(RESOURCE,VALUE2),O1,O2) :- 
    above(RESOURCE,VALUE1,O1),
    above(RESOURCE,VALUE2,O2),
    O1 != O2,
    outcomeOrder(O1,O2).
    
similar(near(E1,E2),O1,O2) :-
    precondition(near(E1,E2),O1),
    precondition(overlaps(E1,E2,true),O2),
    outcomeOrder(O1,O2).
    
similar(overlaps(E1,E2,true),O1,O2) :-
    precondition(near(E1,E2),O1),
    precondition(overlaps(E1,E2,true),O2),
    outcomeOrder(O1,O2).
 
similar(far(E1,E2),O1,O2) :-
    precondition(far(E1,E2),O1),
    precondition(overlaps(E1,E2,false),O2),
    outcomeOrder(O1,O2).
    
similar(overlaps(E1,E2,false),O1,O2) :-
    precondition(far(E1,E2),O1),
    precondition(overlaps(E1,E2,false),O2),
    outcomeOrder(O1,O2).
    
    
similar(ge(R,V),O1,O2) :- similar(above(R,V),O1,O2).
similar(gt(R,V),O1,O2) :- similar(above(R,V),O1,O2).


similar(le(R,V),O1,O2) :- similar(below(R,V),O1,O2).
similar(lt(R,V),O1,O2) :- similar(below(R,V),O1,O2).
disjunction(O1,O2) :-
    not similar(C,O1,O2),
    precondition(C,O1),
    outcome(O2).
    
disjunction(O1,O2) :-
    not similar(C,O1,O2),
    precondition(C,O2),
    outcome(O1).
:- not disjunction(O1,O2), 
    outcome(O1),
    outcome(O2), 
    outcomeOrder(O1,O2).
    
similarResult(increase(R,A1),O1,O2) :-
    result(O1,increase(R,A1)),
    result(O2,increase(R,A2)), 
    outcomeOrder(O1,O2).

similarResult(decrease(R,A1),O1,O2) :-
    result(O1,decrease(R,A1)),
    result(O2,decrease(R,A2)), 
    outcomeOrder(O1,O2).  
    
similarResult(increase(R,A2),O1,O2) :-
    result(O1,increase(R,A1)),
    result(O2,increase(R,A2)), 
    outcomeOrder(O1,O2).

similarResult(decrease(R,A2),O1,O2) :-
    result(O1,decrease(R,A1)),
    result(O2,decrease(R,A2)), 
    outcomeOrder(O1,O2).

disjunctionResult(O1,O2) :-
    not similarResult(R,O1,O2),
    result(O1,R),
    outcome(O2).    
disjunctionResult(O1,O2) :-
    not similarResult(R,O1,O2),
    result(O2,R),
    outcome(O1).
:- not disjunctionResult(O1,O2), 
    outcome(O1),
    outcome(O2), 
    outcomeOrder(O1,O2).
    
    
    


%%%

%%%% Adding and deleting entities %%%%
% Don't add or delete an entity unless it_primes because of (a) collision or (b)
% control event
controlled(O) :- precondition(control_event(_), O).
controlled(O) :- precondition(overlaps(_,_, true), O).
% 7/4/2016 - maybe we want things added/deleted with time?
% Future work: use timer instead.
controlled(tick).

:- result(O, add(E, P)), not controlled(O).
:- result(O, delete(E)), not controlled(O).

%%%% Misc - should be organized at some point.

%% Don't have a result that_primes also a result of tick
:- result(O, R), result(tick, R), O != tick.

%% Don't precondition on something being compared to itself.
:- condition(C), lhThreshold(C, R, R).


:- condition(near(E2,E1)), entityOrdering(E1,E2).
:- condition(far(E2,E1)), entityOrdering(E1,E2).

%% Outcomes should have at least one precondition that_primes not shared with
%%  another outcome
preconditionCovered(P, O) :- precondition(P_prime, O), implies(P_prime, P).

duplicatesPrecondition(O1, P) :- 
  precondition(P, O1), preconditionCovered(P, O2), O1 != O2.

% for every O, exists a P that_primes not shared(P, O1, O2)
differentiated(O) :- 
  precondition(P, O), not duplicatesPrecondition(O, P).

:- outcome(O), not differentiated(O).


%%%% Controls
%% Don't check for "mouse button pressed" and "clicking" an entity in the
%  same game
:- condition(control_event(button(mouse_button,pressed))),
   condition(control_event(click(_))).


%%%% Immediacy %%%%

immediate_condition(C)
  :- initialize(R), result_enables_condition(R, C).

immediate_condition(C)
  :- immediate_condition(C_prime), implies(C_prime, C).

immediate_condition(equal(R1, R2))
  :- initialize(R1, X), initialize(R2, X).


intermediate_outcome(O)
  :- precondition(C, O), not immediate_condition(C).

:- outcome(O), not intermediate_outcome(O).

% %%%% The below are not necessarily definitive, but seem to rule out weird
% %cases %%%%
% %% no controls except mouse.
nonMouseControls  :- 
    condition(control_event(button(B, Action))), 
    B != mouse_button. 
:- condition(control_event(button(mouse_button, Action))), Action != held.
:- nonMouseControls.

:- near(E2,E1), entityOrdering(E1,E2).

:- 3 {precondition(overlaps(E1,E2,POLARITY),OUTCOME); precondition(near(E1,E2),OUTCOME) },
    entity(E1),
    entity(E2),
    polarity(POLARITY).

% canTouch(E1,E2) :-
    % result(O, move_toward(E1, E2)).
% canTouch(E1,E2) :-
    % entity(E2),humanControlled(E1).
% canTouch(E2,E1) :- canTouch(E1,E2).

% :- precondition(overlaps(E1,E2,POLARITY),OUTCOME), not canTouch(E1,E2).


% misc
:- effect(increase(R,R)).
:- effect(decrease(R,R)).

% Don't let something move away from the cursor if we need to click on it.
:- result(O, move_away(E, cursor)), condition(control_event(click(E))).

:- precondition(timerElapsed(T),Outcome), 2 { precondition(C,Outcome)}.

:-  betterWithTime(R1),
    worseWithTime(R1).
    
:-  onlyOnePrecondition(O),
    above(R,V,O),
    result(O,increase(R2,A)).
    
:-  onlyOnePrecondition(O),
    above(R,V,O),
    result(O,decrease(R2,A)).
          
:-  onlyOnePrecondition(O),
    below(R,V,O),
    result(O,increase(R2,A)).
    
:-  onlyOnePrecondition(O),
    below(R,V,O),
    result(O,decrease(R2,A)).
    
:-  result(O,move_away(E2,E1)),
    result(O2,move_away(E1,E2)).

:-  result(O,increase(R1,R2)),
    result(O,increase(R2,R1)).

:-  result(O,decrease(R1,R2)),
    result(O,decrease(R2,R1)).
    
move(move_away(E,T),E) :-
    result(O,move_away(E,T)).
move(move_towards(E,T),E) :-
    result(O,move_towards(E,T)).

:- 3 {move(T,E)}, entity(E).

:- speed(E,0).

:- 2 {result(O,add(E,L))}, outcome(O).


clickOnOverlap(E1,E2,O) :- precondition(overlaps(E1,E2,true),O),
			   precondition(control_event(click(E1)),O).
clickOnOverlap(E1,E2,O) :- precondition(overlaps(E1,E2,true),O),
			   precondition(control_event(click(E2)),O).
:- 2 { clickOnOverlap(E1,E2,O)}, entity(E1),entity(E2).

perEntity(health(E)) :- entity(E).
perEntity(target(E)) :- entity(E).

% Nested for loops are weird
:- 2{   precondition(ge(PE,V),O);precondition(le(PE,V),O);
        precondition(gt(PE,V),O);precondition(lt(PE,V),O)},
    outcome(O).
% for simplicity - don't allow perEntity things on the right hand side
:- 1 {precondition(ge(V,PE),O);precondition(le(V,PE),O);
        precondition(gt(V,PE),O);precondition(lt(V,PE),O)},
    perEntity(PE).
        
%only have per entity checks if it affects the given entity
:-  1 { precondition(ge(PV,V),O); precondition(gt(PV,V),O);
        precondition(lt(PV,V),O); precondition(le(PV,V),O) },
    {result(O,increases(PV2,A));result(O,decreases(PV2,A))} 0,
    perEntity(PV),
    perEntity(PV2).
    
    
every_frame(O) :- precondition(tick,O).
    
not_every_frame(O) :- precondition(ge(R,V),O), result(O,decreases(R,V2)).
not_every_frame(O) :- precondition(gt(R,V),O), result(O,decreases(R,V2)).
not_every_frame(O) :- precondition(le(R,V),O), result(O,increases(R,V2)).
not_every_frame(O) :- precondition(lt(R,V),O), result(O,increases(R,V2)).

every_frame(O) :- not not_every_frame(O), precondition(C,O).

not_every_frame(O) :- precondition(control_event(click(E)),O).
not_every_frame(O) :- precondition(overlaps(E1,E2,true),O).
not_every_frame(O) :- precondition(control_event(button(B,pressed)),O).
not_every_frame(O) :- precondition(control_event(button(B,released)),O).
not_every_frame(O) :- precondition(timerElapsed(T),O) .

:- result(O,delete(E)), every_frame(O).
:- result(O,add(E)), every_frame(O).
