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

%if something helps it must help in some way
:- {result(help(ENTITY1,ENTITY2),ACTION) : actions(ACTION) } 0, interaction(ENTITY1,ENTITY2,help) .

%if something hurts it must hurt in some way
:- {result(hurt(ENTITY1,ENTITY2),ACTION) : actions(ACTION) } 0, interaction(ENTITY1,ENTITY2,hurt) .

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
:- precondition(overlaps(ENTITY,ENTITY),OUTCOME).