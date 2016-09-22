

moving(ENTITY) :-   entity(ENTITY),
                    1{avatar(ENTITY) ;
                    controlScheme(ENTITY,SCHEME);
                    movementScheme(ENTITY,SCHEME);
                    interaction(OTHER,ENTITY,push);
                    interaction(OTHER,ENTITY,bounce);
                    result(Outcome,moves(ENTITY,Direction));
                    effect(move_away(E, E_prime));
                    effect(move_towards(E, E_prime))}.
static(ENTITY) :- entity(ENTITY), not moving(ENTITY).


% so, if it says it helps/hurts, it actually should
actuallyHelps(ENTITY1,ENTITY2) :- 
    result(help(ENTITY1,ENTITY2),increase(G_RESOURCE)), good(RESOURCE). 
actuallyHelps(ENTITY1,ENTITY2) :-
    result(help(ENTITY1,ENTITY2),decrease(B_RESOURCE)), bad(RESOURCE).
% actuallyHelps(help(ENTITY1,ENTITY2)) :-
    % result(help(ENTITY1,ENTITY2),spawn(ENTITY)), helpful(ENTITY).
actuallyHurts(ENTITY1,ENTITY2) :-
    result(hurt(ENTITY1,ENTITY2),increase(G_RESOURCE)), bad(G_RESOURCE).   
actuallyHurts(ENTITY1,ENTITY2) :-
    result(hurt(ENTITY1,ENTITY2),decrease(B_RESOURCE)), good(B_RESOURCE).     
% actuallyHurts(hurt(ENTITY1,ENTITY2)) :-
    % result(hurt(ENTITY1,ENTITY2),spawn(ENTITY)),  harmful(ENTITY).
        

% % same - can't be good and bad
% :- bad(RESOURCE), good(RESOURCE).


        
 
    
% % % outcomes must be different - perhaps this is overly strong
% % % should subsets be allowed?  
% % % CRM 6/15/2016 commented out for debugging
% % % :-  not differentL(OUTCOME1,OUTCOME2), 
% % %    outcome(OUTCOME1),outcome(OUTCOME2),
% % %    outcomeOrder(OUTCOME1,OUTCOME2),
% % %    same(OUTCOME1,OUTCOME2). 
 
% % %:-  not differentR(OUTCOME1,OUTCOME2), 
% % %    outcome(OUTCOME1),outcome(OUTCOME2),
% % %    outcomeOrder(OUTCOME1,OUTCOME2),
% % %    same(OUTCOME1,OUTCOME2). 
 
% not sure if these are needed
% was trying to have something about how certain outcomes
% are more important
modeChanging(Outcome) :-
    result(Outcome,mode_change(MODE)).
    
moreSevere(OutcomeA,OutcomeB) :- 
    modeChanging(OutcomeA),
    outcome(OutcomeB),
    not modeChanging(OutcomeB).

%generic above below to do interval reasoning 
below(RESOURCE,OUTCOME) :- 
    precondition(le(RESOURCE),OUTCOME).

above(RESOURCE,OUTCOME) :- 
    precondition(ge(RESOURCE),OUTCOME).

%helpers
conditionedOnResource(RESOURCE,OUTCOME) :- above(RESOURCE,OUTCOME).
conditionedOnResource(RESOURCE,OUTCOME) :- below(RESOURCE,OUTCOME).


outcome(A) :- result(A,E).    

thresholded(RESOURCE) :-
    1{ precondition(ge(RESOURCE),OUTCOME);
       precondition(le(RESOURCE),OUTCOME)}, resource(RESOURCE).
       
       
changes(RESOURCE) :-
    1{ result(OUTCOME,increase(RESOURCE));
        result(OUTCOME,decrease(RESOURCE))}, resource(RESOURCE).

%resources should both change and be compared against
meaningfulResource(RESOURCE) :- 
    changes(RESOURCE),
    thresholded(RESOURCE).
%:- resource(RESOURCE),
%    not meaningfulResource(RESOURCE).



%an entity only matters if something wants to collide against it/click it
required(Entity) :- precondition(control_event(click(Entity)), Outcome).
required(Entity) :- precondition(overlaps(Entity,_,_), Outcome).
required(Entity) :- precondition(overlaps(_,Entity,_), Outcome).
% CRM 6/23/2016 - or if something requires it to be present
required(Entity) :- precondition(present(Entity), Outcome).
% CRM 6/23/2016 - or if something generates it, maybe?
% CRM 6/27/2016 - or if it's required according to rules
required(Entity) :- requires(_, Entity).

% only allow something to increase on tick if it can be decreased
% :- result(tick, increase(Resource)),
%    not effect(decrease(Resource,Amt)),
%    potentialValues(Amt).
% Define the above as a "score" value.

        
% helper
effect(EFFECT) :- 
    result(OUTCOME,EFFECT).
% probably overly strong - but Don't have the same effect pop up multiple places
% :- 2 {result(OUTCOME,EFFECT)}, effect(EFFECT).

% an outcome needs result and precondition
completeOutcome(OUTCOME) :- 
    result(OUTCOME,EFFECT),
    precondition(CONDITION,OUTCOME).

% a resource is free if there is a way to decrease/increase not conditioned on the same resource - i.e. some way to change things
freeResource(Resource) :- 
    resource(Resource), 
    1{result(Outcome,increase(Resource));
      result(Outcome,decrease(Resource))},
    not conditionedOnResource(Resource,Outcome),
    outcome(Outcome).

% CRM 6/27/2016
% Removing this constraint for now:
% Don't want things popping away because of other things (although maybe
% clicking is ok?)
% :-  result(Outcome,delete(Entity)), 
%     {precondition(overlaps(Entity,Other),Outcome);
%      precondition(overlaps(Other,Entity),Outcome)} 0.

%players must have controls or it's just a weird movie
playerControls :- precondition(control_event(EVENT),OUTCOME).
playerControls :- controlLogic(_).

% CRM 6/27/2016 - only add a singular entity if it's absent beforehand.
maintains_singular(Outcome, Entity)
  :- precondition(absent(Entity), Outcome).
maintains_singular(Outcome, Entity)
  :- result(Outcome, delete(Entity)).

%% Don't condition on presence/absence unless the entity is deleted.
% REEXAMINE THESE LATER XXX
% :- condition(present(E)), not effect(delete(E)).
% :- condition(absent(E)), not effect(delete(E)).

% can't test for a spatial condition unless at least one of the entities
% can move.

one_moves(E1, E2)
  :- moves(E1), entity(E2).

one_moves(E1, E2)
  :- moves(E2), entity(E1).

moves(E)
  :- effect(move_towards(E, X)).

moves(E)
  :- effect(move_away(E, X)).
moves(E) :-
    effect(moves(E,D)).
moves(E)
  :- controlScheme(E, Scheme).
moves(E)
  :- controlLogic(draggable(E)).

moves(E)
  :- effect(move_selected(E)).

moves(E)
  :- effect(moves(E, Direction, Amount)).
%%%%

%%% Reachability %%%%

reachableResult(R)
  :- initialize(R).

reachableCondition(C)
  :- result_enables_condition(R, C),
      reachableResult(R).

reachableCondition(overlaps(E1,E2,POLARITY))
:- precondition(overlaps(E1,E2,POLARITY),O),
   controlLogic(draggable(E1)).

reachableCondition(overlaps(E1,E2,POLARITY))
:- precondition(overlaps(E1,E2,POLARITY),O),
   controlLogic(draggable(E2)).

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


similar(C,O1,O2) :- 
    precondition(C,O1),
    precondition(C,O2),
    O1 != O2,
    outcomeOrder(O1,O2).

similar(below(RESOURCE),O1,O2) :- 
    below(RESOURCE,O1),
    below(RESOURCE,O2),
    O1 != O2,
    outcomeOrder(O1,O2).
   
   
similar(below(RESOURCE),O1,O2) :- 
    below(RESOURCE,O1),
    below(RESOURCE,O2),
    O1 != O2,
    outcomeOrder(O1,O2).
    
similar(timerElapsed(T1),O1,O2) :- 
    precondition(timerElapsed(T1),O1),
    precondition(timerElapsed(T2),O2),
    O1 != O2,
    outcomeOrder(O1,O2).
  
similar(timerElapsed(T2),O1,O2) :- 
    precondition(timerElapsed(T1),O1),
    precondition(timerElapsed(T2),O2),
    O1 != O2,
    outcomeOrder(O1,O2).
similar(timerElapsed(T),O1,O2) :- 
    precondition(tick,O1),
    precondition(timerElapsed(T),O2),
    O1 != O2,
    outcomeOrder(O1,O2).
    
similar(timerElapsed(T1),O1,O2) :- 
    precondition(timerElapsed(T1),O1),
    precondition(tick,O2),
    O1 != O2,
    outcomeOrder(O1,O2).
similar(above(RESOURCE),O1,O2) :- 
    above(RESOURCE,O1),
    above(RESOURCE,O2),
    O1 != O2,
    outcomeOrder(O1,O2).
    
similar(above(RESOURCE),O1,O2) :- 
    above(RESOURCE,O1),
    above(RESOURCE,O2),
    O1 != O2,
    outcomeOrder(O1,O2).
  
    
similar(ge(R),O1,O2) :- similar(above(R),O1,O2).


similar(le(R),O1,O2) :- similar(below(R),O1,O2).
%% disjunction(O1,O2) :-
%%     not similar(C,O1,O2),
%%     precondition(C,O1),
%%     outcome(O2).
    
%% disjunction(O1,O2) :-
%%     not similar(C,O1,O2),
%%     precondition(C,O2),
%%     outcome(O1).
    
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

%% disjunctionResult(O1,O2) :-
%%     not similarResult(R,O1,O2),
%%     result(O1,R),
%%     outcome(O2).    
%% disjunctionResult(O1,O2) :-
%%     not similarResult(R,O1,O2),
%%     result(O2,R),
%%     outcome(O1).
% % NEED TO REASSESS XXXX 
% % :- not disjunctionResult(O1,O2), 
    % % outcome(O1),
    % % outcome(O2), 
    % % outcomeOrder(O1,O2).
    
    
    


%%%

%%%% Adding and deleting entities %%%%
% Don't add or delete an entity unless it's because of (a) collision or (b)
% control event
controlled(O) :- precondition(control_event(_), O).
controlled(O) :- precondition(overlaps(_,_, true), O).
% 7/4/2016 - maybe we want things added/deleted with time?
% Future work: use timer instead.
controlled(tick).

%% Outcomes should have at least one precondition that's not shared with
%%  another outcome
preconditionCovered(P, O) :- precondition(P_prime, O), implies(P_prime, P).

duplicatesPrecondition(O1, P) :- 
  precondition(P, O1), preconditionCovered(P, O2), O1 != O2.

% for every O, exists a P that's not shared(P, O1, O2)
differentiated(O) :- 
  precondition(P, O), not duplicatesPrecondition(O, P).

% :- outcome(O), not differentiated(O).



%%%% Immediacy %%%%

immediate_condition(C)
  :- initialize(R), result_enables_condition(R, C).

immediate_condition(C)
  :- immediate_condition(C_prime), implies(C_prime, C).

immediate_condition(equal(R1, R2))
  :- initialize(R1, X), initialize(R2, X).


intermediate_outcome(O)
  :- precondition(C, O), not immediate_condition(C).

% canTouch(E1,E2) :-
    % result(O, move_toward(E1, E2)).
% canTouch(E1,E2) :-
    % entity(E2),humanControlled(E1).
% canTouch(E2,E1) :- canTouch(E1,E2).

% :- precondition(overlaps(E1,E2,POLARITY),OUTCOME), not canTouch(E1,E2).


move(move_away(E,T),E) :-
    result(O,move_away(E,T)).
move(move_towards(E,T),E) :-
    result(O,move_towards(E,T)).

clickOnOverlap(E1,E2,O) :- precondition(overlaps(E1,E2,true),O),
			   precondition(control_event(click(E1)),O).
clickOnOverlap(E1,E2,O) :- precondition(overlaps(E1,E2,true),O),
			   precondition(control_event(click(E2)),O).

perEntity(health(E)) :- entity(E).
perEntity(target(E)) :- entity(E).

every_frame(O) :- precondition(tick,O).
    
not_every_frame(O) :- precondition(ge(R),O), result(O,decrease(R)).
not_every_frame(O) :- precondition(le(R),O), result(O,increase(R)).

every_frame(O) :- not not_every_frame(O), precondition(C,O).

not_every_frame(O) :- precondition(control_event(click(E)),O).
%not_every_frame(O) :- precondition(overlaps(E1,E2,true),O).
not_every_frame(O) :- precondition(control_event(button(B,pressed)),O).
not_every_frame(O) :- precondition(control_event(button(B,released)),O).
not_every_frame(O) :- precondition(timerElapsed(T),O) .


timer_length(Timer,long) :-
    timerLogic(Timer,N,_),
    N >= 5.

timer_length(Timer,long) :-
    timerLogic(Timer,stochastic(D,N),_),
    N >= 5.

timer_length(Timer,short) :-
    timerLogic(Timer,_,_),
    not timer_length(Timer,long).
