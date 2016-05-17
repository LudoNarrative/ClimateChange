% Only 1 avatar
:-  avatar(ENTITY), 
    many(ENTITY).

% avatar precludes movement
:-  movementScheme(ENTITY,SCHEME),
    avatar(ENTITY).

% things can have multiple movement - but only 1 way to follow a path
:-  2 {movementScheme(ENTITY,path(TYPE))}, 
    entity(ENTITY).

% don't be attracted to yourself
:- attracted_to(ENTITY,ENTITY).

% don't be repulsed by yourself
:- repeled_by(ENTITY,ENTITY).

% don't be attracted to and repulsed by at the same time
:- attracted_to(ENTITY,OTHER), repeled_by(ENTITY,OTHER).
:- attracted_to(ENTITY,OTHER), repeled_by(OTHER,ENTITY).

% static means it doesn't move
:- static(ENTITY), avatar(ENTITY).
:- static(ENTITY), controlScheme(ENTITY,SCHEME).
:- static(ENTITY), movementScheme(ENTITY,SCHEME).
:- static(ENTITY), interaction(OTHER,ENTITY,push).


{ result(help(ENTITY1,ENTITY2),increases(G_RESOURCE)) } :- interaction(ENTITY1,ENTITY2,help), good(G_RESOURCE).   
{ result(help(ENTITY1,ENTITY2),decreases(B_RESOURCE)) } :- interaction(ENTITY1,ENTITY2,help), bad(B_RESOURCE).     
{ result(help(ENTITY1,ENTITY2),spawn(ENTITY)) } :- interaction(ENTITY1,ENTITY2,help), helpful(ENTITY).


actuallyHelps(help(ENTITY1,ENTITY2)) :- 
    result(help(ENTITY1,ENTITY2),increases(G_RESOURCE)), good(RESOURCE). 
actuallyHelps(help(ENTITY1,ENTITY2)) :-
    result(help(ENTITY1,ENTITY2),decreases(B_RESOURCE)), bad(RESOURCE).
actuallyHelps(help(ENTITY1,ENTITY2)) :-
    result(help(ENTITY1,ENTITY2),spawn(ENTITY)), helpful(ENTITY).


        

actuallyHurts(hurt(ENTITY1,ENTITY2)) :-
    result(hurt(ENTITY1,ENTITY2),increases(G_RESOURCE)), bad(G_RESOURCE).   
actuallyHurts(hurt(ENTITY1,ENTITY2)) :-
    result(hurt(ENTITY1,ENTITY2),decreases(B_RESOURCE)), good(B_RESOURCE).     
actuallyHurts(hurt(ENTITY1,ENTITY2)) :-
    result(hurt(ENTITY1,ENTITY2),spawn(ENTITY)),  harmful(ENTITY).
        

%if something helps it must help in some way
:- not actuallyHelps(ENTITY1,ENTITY2), interaction(ENTITY1,ENTITY2,help) .

%if something hurts it must hurt in some way
:- not actuallyHurts(ENTITY1,ENTITY2), interaction(ENTITY1,ENTITY2,hurt) .

%if something is placed on a path must have a valid one.
:- placement(ENTITY,TYPE,path(TYPE)), not validPathPlacement.

%if goal is to reach end must have a start and end
:- goal(reach(end)), not placement(ENTITY, path(start)), avatar(ENTITY).  
:- goal(reach(end)), not placement(ENTITY, path(end)), avatar(ENTITY).   

%don't increase or decrease in more than 2 ways
:- 2 {result(OUTCOME, decreases(RESOURCE,AMOUNT)): 
    potentialValues(AMOUNT)}, 
    resource(RESOURCE), 
    outcome(OUTCOME). 
    
:- 2 {result(OUTCOME, increases(RESOURCE,AMOUNT)): 
    potentialValues(AMOUNT)}, 
    resource(RESOURCE), 
    outcome(OUTCOME). 
    
% don't increase and decrease at the same time
:-  result(OUTCOME,increases(RESOURCE,AMOUNT1)), 
    result(OUTCOME,decreases(RESOURCE,AMOUNT2)).
    
% don't have 2 resources counting the same thing
:- 2 {resourceLogic(RESOURCE,count(ENTITY)) : resource(RESOURCE)},
    entity(ENTITY).
% don't have 2 entities counted by the same thing
:- 2 {resourceLogic(RESOURCE,count(ENTITY)) : entity(ENTITY)},
    resource(RESOURCE).
% don't count and do transactions on a resource
:-  resourceLogic(RESOURCE,count(ENTITY)), 
    transaction(RESOURCE,TRANSACTION).
% don't overlap with itself
:- precondition(overlaps(ENTITY,ENTITY,POLARITY),OUTCOME).


:- max_resource_change_per + 1  {changes(OUTCOME,CHANGE, CV,V) :
    resource(CV),
    potentialValues(V), 
    change(CHANGE)}, 
        outcome(OUTCOME).
:-  2 {changes(OUTCOME,CHANGE,CV,V)}, 
    outcome(OUTCOME), 
    resource(CV).        
        
        
:- goal(prevent(OUTCOME)), goal(achieve(OUTCOME)).

:- bad(RESOURCE), good(RESOURCE).


        
%tick must occur alone
:-  precondition(tick,OUTCOME), 
    2 { precondition(CONDITION,OUTCOME) : condition(CONDITION)}.
 
% no precondition without outcome 
% :-  precondition(CONDITION,OUTCOME), 
    % not outcome(OUTCOME).
% % no result without outcome    
% :-  result(OUTCOME,EFFECT), 
    % not outcome(OUTCOME).
    
    
% 2 outcomes are the same if they share a precondition
same(OUTCOME1, OUTCOME2) :- 
    precondition(CONDITION,OUTCOME1),
    precondition(CONDITION,OUTCOME2),
    outcomeOrder(OUTCOME1,OUTCOME2).
  
% 2 outcomes are different if one has a precondition the other doesn't  
differentL(OUTCOME1,OUTCOME2) :- 
    precondition(CONDITION,OUTCOME1),
    not precondition(CONDITION,OUTCOME2),
    condition(CONDITION),
    outcomeOrder(OUTCOME1,OUTCOME2),
    same(OUTCOME1,OUTCOME2).
  
%vice versa  
differentR(OUTCOME1,OUTCOME2) :- 
    not precondition(CONDITION,OUTCOME1),
    precondition(CONDITION,OUTCOME2),
    condition(CONDITION),
    outcomeOrder(OUTCOME1,OUTCOME2),
    same(OUTCOME1,OUTCOME2).
    
% outcomes must be different - perhaps this is overly strong
% should subsets be allowed?  
:-  not differentL(OUTCOME1,OUTCOME2), 
    outcome(OUTCOME1),outcome(OUTCOME2),
    outcomeOrder(OUTCOME1,OUTCOME2),
    same(OUTCOME1,OUTCOME2). 
 
:-  not differentR(OUTCOME1,OUTCOME2), 
    outcome(OUTCOME1),outcome(OUTCOME2),
    outcomeOrder(OUTCOME1,OUTCOME2),
    same(OUTCOME1,OUTCOME2). 
    
    
% don't compare 1 resource for more than 1 value   
:-  2 {precondition(lt(RESOURCE,VALUE),OUTCOME) :
            potentialValues(VALUE)}, 
        outcome(OUTCOME), 
        resource(RESOURCE).
        
% don't compare 1 resource for more than 1 value   
:-  2 {precondition(ge(RESOURCE,VALUE),OUTCOME) :
            potentialValues(VALUE)}, 
        outcome(OUTCOME), 
        resource(RESOURCE).
        
% don't compare 1 resource for more than 1 value   
:-  2 {precondition(gt(RESOURCE,VALUE),OUTCOME) :
            potentialValues(VALUE)}, 
        outcome(OUTCOME), 
        resource(RESOURCE).
    
% don't compare 1 resource for more than 1 value   
:-  precondition(le(RESOURCE,VALUE),OUTCOME), 
    precondition(lt(RESOURCE,VALUE2),OUTCOME).
    
% don't compare 1 resource for more than 1 value   
:-  precondition(ge(RESOURCE,VALUE),OUTCOME), 
    precondition(gt(RESOURCE,VALUE2),OUTCOME).

    
% sanity check on outcome - only allow it have it has a result and precondition
% result_outcome(OUTCOME) :-     result(OUTCOME,EFFECT).
% precondition_outcome(OUTCOME) :-     precondition(CONDITION,OUTCOME).
% validOutcome(OUTCOME) :- result_outcome(OUTCOME), 
    % precondition_outcome(OUTCOME).
% :- outcome(OUTCOME), not validOutcome(OUTCOME).

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
    
    
:- entity(B), not entity(A), entityOrdering(A,B).
% cleanliness - choose e1 before e2
:- condition(overlaps(A,B,POLARITY)), entityOrdering(B,A).



effect(EFFECT) :- result(OUTCOME,EFFECT).

%an outcome shouldn't result in game win and game loss simultaneously
:-  result(OUTCOME,mode_change(END)), 
    end_mode(END),
    2 {result(OUTCOME,EFFECT) : effect(EFFECT)}.
    
%don't tie losing or winning to a button press (press space to lose feels odd)
:-  precondition(control_event(BUTTON,STATE),OUTCOME),
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
    
    
%%%%% Go the reverse direction:


avatarMoveUp(ENTITY) :- 
    precondition(control_event(up_arrow, held),OUTCOME),
    precondition(empty(ENTITY,up,low),OUTCOME),
    result(OUTCOME,moves(ENTITY, up, low)).
    
avatarMoveDown(ENTITY) :- 
    precondition(control_event(down_arrow, held),OUTCOME),
    precondition(empty(ENTITY,down,low),OUTCOME),
    result(OUTCOME,moves(ENTITY,down, low)).
    
avatarMoveLeft(ENTITY) :- 
    precondition(control_event(left_arrow, held),OUTCOME),
    precondition(empty(ENTITY,left,low),OUTCOME),
    result(OUTCOME,moves(ENTITY, left, low)).
    
avatarMoveRight(ENTITY) :- 
    precondition(control_event(right_arrow, held),OUTCOME),
    precondition(empty(ENTITY,right,low),OUTCOME),
    result(OUTCOME,moves(ENTITY,right, low)).
    
avatarMoveForward(ENTITY) :-
    precondition(control_event(up_arrow, held),OUTCOME),
    precondition(empty(ENTITY,forward,low),OUTCOME),
    result(OUTCOME,moves(ENTITY, forward, low)).
    
avatarMoveBackward(ENTITY) :-
    precondition(control_event(down_arrow, held),OUTCOME),
    precondition(empty(ENTITY,behind,low),OUTCOME),
    result(OUTCOME,moves(ENTITY, behind, low)).
    
avatarRotateCCW(ENTITY) :-
    precondition(control_event(left_arrow, held),OUTCOME),
    result(OUTCOME,rotates(ENTITY, ccw, low)).
avatarRotateCW(ENTITY) :-
    precondition(control_event(right_arrow, held),OUTCOME),
    result(OUTCOME,rotates(ENTITY, cw, low)).

avatarJump(ENTITY) :-
    precondition(control_event(up_arrow, pressed),OUTCOME),
    result(OUTCOME,moves(ENTITY, up, high)).
        
clickAndDrag(ENTITY) :-
    precondition(control_event(mouse_button, pressed),OUTCOME_CLICK),
    precondition(overlaps(cursor,ENTITY,true),OUTCOME_CLICK),
    resource(ENTITY,dragged),
    result(OUTCOME_CLICK, set(dragged,true)),
    precondition(eq(dragged,true),OUTCOME_DRAG),
    result(OUTCOME_DRAG, move_towards(ENTITY,cursor)),
    precondition(control_event(mouse_button, released),OUTCOME_END_DRAG),
    %result(OUTCOME_END_DRAG, select(ENTITY)),
    result(OUTCOME_END_DRAG, set(dragged,false)).
  
%cursor is electromagnet
attractedToOnClick(ENTITY,OTHER) :-
    precondition(control_event(mouse_button, held),OUTCOME),
    result(OUTCOME, move_towards(ENTITY,OTHER)).

repeledByOnClick(ENTITY,OTHER) :-
    precondition(control_event(mouse_button, held),OUTCOME),
    result(OUTCOME, move_away(ENTITY,OTHER)).
    

%click on something, then move it
%simplest version, click on something
moveAfterSelectedOnClick(ENTITY) :- 
    precondition(control_event(mouse_button, pressed),OUTCOME_SELECT),
    precondition(overlaps(cursor,ENTITY,true),OUTCOME_SELECT),
    resource(ENTITY,selected),
    resource(ENTITY,target),
    result(OUTCOME_SELECT, set(selected,true)),
    precondition(control_event(mouse_button, pressed),OUTCOME_SET_TARGET),
    precondition( eq(selected,true),OUTCOME_SET_TARGET),
    result(OUTCOME_SET_TARGET, set(selected,false)),
    result(OUTCOME_SET_TARGET, set(target,cursor)),
    result(tick,move_towards(ENTITY,target)).
%%%%%%%%%% NPC   %%%%%%%%%%%%%%%%%%


% %pick a speed for a projectile
% 1 {speed(ENTITY,AMOUNT) : constants(AMOUNT)} 1 :- 
    % movementScheme(ENTITY,projectile).
% %projectiles go straight
% result(tick,moves(ENTITY, forward, AMOUNT)) :- 
    % movementScheme(ENTITY,projectile), speed(ENTITY,AMOUNT). 

% %Random walkers walk in a given direction for a given amount of time    
% outcome(change_direction(ENTITY)) :- 
    % movementScheme(ENTITY,random_walk).
% timerLogic(ENTITY,change_direction,duration) :- 
    % movementScheme(ENTITY,random_walk).
% %time's up - change direction
% precondition(timerElapsed(ENTITY,change_direction), change_direction(ENTITY)) :-
    % movementScheme(ENTITY,random_walk).
% result(change_direction(ENTITY), rotate(ENTITY,random_int(0,360))) :- 
    % movementScheme(ENTITY,random_walk).
% %normally, just walk forwards ?slowly?
% result(tick,moves(ENTITY, forward, low)) :- 
    % movementScheme(ENTITY,random_walk). 

% %random pathfinder - changes target every once in a while
% outcome(change_target(ENTITY)) :- 
    % movementScheme(ENTITY,random_pathfind).
% timerLogic(ENTITY,change_target,duration) :- 
    % movementScheme(ENTITY,random_pathfind).
% precondition(timerElapsed(ENTITY,change_target), change_target(ENTITY)) :-
    % movementScheme(ENTITY,random_pathfind).
    
% resource(ENTITY,target) :- movementScheme(ENTITY,random_pathfind).
% result(change_target(ENTITY), set(target,random_point)) :- 
    % movementScheme(ENTITY,random_pathfind).
% result(tick,move_towards(ENTITY,target)) :- 
    % movementScheme(ENTITY,random_pathfind). 


% outcome(get_next_point(ENTITY)) :- 
    % movementScheme(ENTITY,path(TYPE)).
% precondition(overlaps(ENTITY,next_point,true), get_next_point(ENTITY)) :-
    % movementScheme(ENTITY,path(TYPE)).
    
% result(get_next_point(ENTITY), set(next_point,pop(waypoints))) :- 
    % movementScheme(ENTITY,path(TYPE)).
% resource(ENTITY,waypoints) :- movementScheme(ENTITY,path(TYPE)). 
% resource(ENTITY,next_point) :- movementScheme(ENTITY,path(TYPE)). 
% result(tick,move_towards(ENTITY,next_point)) :- 
    % movementScheme(ENTITY,path(TYPE)). 
    
    
    
% outcome(tick) :- result(tick,ELSE).
% precondition(tick,tick) :- outcome(tick).

% attractions(ENTITY) :- entity(ENTITY).
% attractions(cursor).
% 1 {attracted_to(ENTITY,OTHER) : attractions(OTHER) } :- 
    % movementScheme(ENTITY,attract).
    

% result(tick,move_towards(ENTITY,OTHER)) :- 
    % movementScheme(ENTITY,attract), 
    % attracted_to(ENTITY,OTHER). 
    
    
% 1 {repeled_by(ENTITY,OTHER) : attractions(OTHER) } :- movementScheme(ENTITY,repel).


% result(tick,move_away(ENTITY,OTHER)) :- 
    % movementScheme(ENTITY,repel),
    % repeled_by(ENTITY,OTHER). 
       

% resource(ENTITY,target) :- movementScheme(ENTITY,patrol).
% precondition(overlaps(ENTITY,target,true), next_target(ENTITY)) :-
    % movementScheme(ENTITY,patrol).
% result(next_target(ENTITY), set_next_patrol_point(ENTITY)) :-
    % movementScheme(ENTITY,patrol).
    
% result(tick,move_to(ENTITY,target)) :-
    % movementScheme(ENTITY,patrol).
    

% {physicsLogic(ENTITY,gravity) : entity(ENTITY)}  :- controlScheme(AVATAR,platformer).
% physicsLogic(AVATAR,gravity) :- controlScheme(AVATAR,platformer).

% result(tick,apply_force(ENTITY,down,middle)) :-
    % physicsLogic(ENTITY,gravity).
    

% 1 {bounceLogic(ENTITY1,ENTITY2) : entity(ENTITY2)} :- movementScheme(ENTITY1,bounce).
% :- bounceLogic(ENTITY1,ENTITY2), ENTITY1 = ENTITY2.

% precondition(overlaps(ENTITY1,ENTITY2,true),bounce(ENTITY1,ENTITY2)) :-
    % bounceLogic(ENTITY1,ENTITY2).
% result(bounce(ENTITY1,ENTITY2),
    % reflect_velocity(ENTITY1,collision_normal(ENTITY1,ENTITY2))) :-
    % bounceLogic(ENTITY1,ENTITY2).
    
% outcome(OUTCOME) :- precondition(CONDITION,OUTCOME).
% outcome(OUTCOME) :- result(OUTCOME,EFFECT).

% interactions(help;collide;harm;help;make_invulnerable).

% 1 {interaction(ENTITY1,ENTITY2,INTERACTION) : interactions(INTERACTION)} 
    % :-  entity(ENTITY1), 
        % entity(ENTITY2), 
        % ENTITY1 != ENTITY2 .
        
% precondition(overlaps(ENTITY1,ENTITY2,true), push(ENTITY1,ENTITY2)) :- interaction(ENTITY1,ENTITY2,push).
% result(push(ENTITY1,ENTITY2),apply_force(ENTITY2,direction_from(ENTITY1,ENTITY2))) :- interaction(ENTITY1,ENTITY2,push).




% precondition(overlaps(ENTITY1,ENTITY2,true), collide(ENTITY1,ENTITY2)) :- 
    % interaction(ENTITY1,ENTITY2,collide).
% result(collide(ENTITY1,ENTITY2),apply_restitution(ENTITY1,ENTITY2)) :- 
    % interaction(ENTITY1,ENTITY2,collide).

% {static(ENTITY) : entity(ENTITY)}.


% precondition(overlaps(ENTITY1,ENTITY2,true), help(ENTITY1,ENTITY2)) :- 
    % interaction(ENTITY1,ENTITY2,help).
% { result(help(ENTITY1,ENTITY2),increases(G_RESOURCE)) } :- interaction(ENTITY1,ENTITY2,help), good(G_RESOURCE).   
% { result(help(ENTITY1,ENTITY2),decreases(B_RESOURCE)) } :- interaction(ENTITY1,ENTITY2,help), bad(B_RESOURCE).     
% { result(help(ENTITY1,ENTITY2),spawn(ENTITY)) } :- interaction(ENTITY1,ENTITY2,help), helpful(ENTITY).


        

% precondition(overlaps(ENTITY1,ENTITY2,true), hurt(ENTITY1,ENTITY2)) :- 
    % interaction(ENTITY1,ENTITY2,hurt).
% { result(hurt(ENTITY1,ENTITY2),increases(G_RESOURCE)) } :- interaction(ENTITY1,ENTITY2,hurt), bad(G_RESOURCE).   
% { result(hurt(ENTITY1,ENTITY2),decreases(B_RESOURCE)) } :- interaction(ENTITY1,ENTITY2,hurt), good(B_RESOURCE).     
% { result(hurt(ENTITY1,ENTITY2),spawn(ENTITY)) } :- interaction(ENTITY1,ENTITY2,hurt), harmful(ENTITY).


% placements(field(random);field(uniform);field(corner);path(center);path(random);path(endpoints);path(uniform);path(start)).
% placementModality(one_shot;spawn).

% 1 {placement(ENTITY,TYPE,MODE) : placements(TYPE), placementModality(MODE)} 1 :- entity(ENTITY).

% validPathPlacement :- placement(ENTITY,TYPE,path(TYPE)), path(PATH,PTYPE).

% 1 {spawnLogic(ENTITY,TYPE,spawn,RATE) : spawnTimings(RATE)} 1 :- placement(ENTITY,TYPE,spawn).




% movementProfiles(constant;logarithmic;ease_in;ease_out;ease_in_out;teleport).

% 1 {movementLogic(ENTITY,PROFILE) : movementProfiles(PROFILE)} 1 :- entity(ENTITY), not static(ENTITY).

% 1 {result(OUTCOME,spawn(ENTITY)) : potentialOutcomes(OUTCOME) } :- spawnLogic(ENTITY,TYPE,MODE,condition).


% %%% RESOURCES %%%
% initialResourceValues(0;low;medium;high).


% 1 {initialize(set(RESOURCE,VALUE)) : initialResourceValues(VALUE)} 1 :- resource(RESOURCE).

% resourceTransactions(convert;pay_cost;gain;lose).

% {transaction(RESOURCE,TRANSACTION) : resourceTransactions(TRANSACTION)} :-
    % resource(RESOURCE).

% 1 {result(OUTCOME, decreases(RESOURCE,AMOUNT)): potentialOutcomes(OUTCOME), potentialValues(AMOUNT) } :- 
    % transaction(RESOURCE,convert).


% 1 { result(OUTCOME,increases(RESOURCE2,AMOUNT2)) : resource(RESOURCE2), potentialValues(AMOUNT2) }:- 
    % result(OUTCOME, decreases(RESOURCE,AMOUNT)), 
    % transaction(RESOURCE,convert).
 


    
% 1 {precondition(gt(RESOURCE,AMOUNT),OUTCOME);precondition(ge(RESOURCE,AMOUNT),OUTCOME) } 1 :- 
    % result(OUTCOME, decreases(RESOURCE,AMOUNT)), 
    % transaction(RESOURCE,convert).
 

% %PAY COST
% 1 {result(OUTCOME, decreases(RESOURCE,AMOUNT)): potentialOutcomes(OUTCOME), potentialValues(AMOUNT) } :- 
    % transaction(RESOURCE,pay_cost). 
% 1 {precondition(gt(RESOURCE,AMOUNT),OUTCOME);precondition(ge(RESOURCE,AMOUNT),OUTCOME) } 1 :- 
    % result(OUTCOME, decreases(RESOURCE,AMOUNT)), 
    % transaction(RESOURCE,pay_cost).



% %LOSE
% 1 {result(OUTCOME, decreases(RESOURCE,AMOUNT)): potentialOutcomes(OUTCOME), potentialValues(AMOUNT) } :- 
    % transaction(RESOURCE,lose). 
% 1 {precondition(gt(RESOURCE,AMOUNT),OUTCOME);precondition(ge(RESOURCE,AMOUNT),OUTCOME) } 1 :- 
    % result(OUTCOME, decreases(RESOURCE,AMOUNT)), 
    % transaction(RESOURCE,lose).
    
    
% %GAIN
% 1 {result(OUTCOME, increases(RESOURCE,AMOUNT)): potentialOutcomes(OUTCOME), potentialValues(AMOUNT) } :- 
    % transaction(RESOURCE,gain). 
    
% {resourceLogic(RESOURCE,count(ENTITY)) : resource(RESOURCE), entity(ENTITY)}.



    
% {result(tick,increases(RESOURCE,AMOUNT)) : resource(RESOURCE), potentialValues(AMOUNT)}.
% {result(tick,decreases(RESOURCE,AMOUNT)) : resource(RESOURCE), potentialValues(AMOUNT)}.

% pools(inventory).
% selectionType(single;double).
% {selection(ENTITY,TYPE) : entity(ENTITY), selectionType(TYPE)}.

% precondition(control_event(mouse_button,pressed),select(ENTITY,single)) :- 
    % selection(ENTITY,single).
% precondition(overlaps(cursor,ENTITY,true),select(ENTITY,single)) :- 
    % outcome(select(ENTITY,single)).
% 1 {result(outcome(select(ENTITY,TYPE)),move_to(ENTITY,POOL)) :pools(POOL)} 1 :- selection(ENTITY,TYPE).


% precondition(control_event(mouse_button,double_pressed),select(ENTITY,double)) :- 
    % selection(ENTITY,double).
% precondition(overlaps(cursor,ENTITY,true),select(ENTITY,double)) :- 
    % outcome(select(ENTITY,double)).
    
% {precondition(ge(RESOURCE,VALUE),OUTCOME) : resource(RESOURCE), potentialValues(VALUE), potentialOutcomes(OUTCOME)}.
% {precondition(gt(RESOURCE,VALUE),OUTCOME) : resource(RESOURCE), potentialValues(VALUE), potentialOutcomes(OUTCOME)}.
% {precondition(lt(RESOURCE,VALUE),OUTCOME) : resource(RESOURCE), potentialValues(VALUE), potentialOutcomes(OUTCOME)}.
% {precondition(le(RESOURCE,VALUE),OUTCOME) : resource(RESOURCE), potentialValues(VALUE), potentialOutcomes(OUTCOME)}.


% {precondition(overlaps(ENTITY1,ENTITY2,true),OUTCOME) :potentialOutcomes(OUTCOME)} :- 
    % entity(ENTITY1),
    % entity(ENTITY2).


% {result(OUTCOME,delete(ENTITY)) : entity(ENTITY), potentialOutcomes(OUTCOME)}.
% {result(OUTCOME,add(ENTITY)) : entity(ENTITY), potentialOutcomes(OUTCOME)}.
% {result(OUTCOME,increases(RESOURCE,VALUE)) : potentialOutcomes(OUTCOME),resource(RESOURCE), potentialValues(VALUE)}.
% {result(OUTCOME,decreases(RESOURCE,VALUE)) : potentialOutcomes(OUTCOME),resource(RESOURCE), potentialValues(VALUE)}.


% modes(narrative_progress;game_win;game_loss;game_over).
% 1 {result(END_OUTCOME,mode_change(MODE)) : modes(MODE)} 1 :- 
    % end_outcome(END_OUTCOME).

% {precondition(le(RESOURCE,VALUE),OUTCOME) : resource(RESOURCE),potentialValues(VALUE)} :- result(OUTCOME,mode_change(MODE)).

% {precondition(ge(RESOURCE,VALUE),OUTCOME,potentialValues(VALUE)) : resource(RESOURCE), potentialValues(VALUE)} :- result(OUTCOME,mode_change(MODE)).



% {precondition(overlaps(ENTITY1,ENTITY2,true),OUTCOME) : entity(ENTITY1),entity(ENTITY2)} :- result(OUTCOME,mode_change(MODE)).