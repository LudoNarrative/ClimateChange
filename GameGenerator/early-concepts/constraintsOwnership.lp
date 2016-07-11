
actorID(ID) :- actor(_, ID).
transitionID(1..maxTransitionCount).
resourceID(1..resourceCount).

resourceType(Resource_type) :-
	input(_, Resource_type, _, _),
	not abstract(Resource_type).
resourceType(Resource_type) :-
	output(_, Resource_type, _, _),
	not abstract(Resource_type).
resourceType(Resource_type) :-
	hyponym(Resource_type, _),
	not abstract(Resource_type).
resourceType(Resource_type) :-
	hyponym(_, Resource_type),
	not abstract(Resource_type).
hyponym(Resource_type, Resource_type) :-
	resourceType(Resource_type).

{usedResource(Resource_type, ID) : resourceType(Resource_type)} 1 :-
	resourceID(ID).
1 {usedResource(Resource_type, ID) : resourceType(Resource_type),
	resourceID(ID)}.
C {usedResource(Resource_type, ID) : resourceID(ID)} C :-
	resource(Resource_type, C).


input(Transition_type, Resource_type, Actor_ID, Role_ID) :-
	input(Parent_Transition_type, Resource_type, Actor_ID, Role_ID),
	hyponym(Parent_Transition_type, Transition_type).
output(Transition_type, Resource_type, Actor_ID, Role_ID) :-
	output(Parent_Transition_type, Resource_type, Actor_ID, Role_ID),
	hyponym(Parent_Transition_type, Transition_type).
role(Transition_type, Resource_type, Actor_ID, Role_ID) :-
	input(Transition_type, Resource_type, Actor_ID, Role_ID).
role(Transition_type, Resource_type, Actor_ID, Role_ID) :-
	output(Transition_type, Resource_type, Actor_ID, Role_ID).

maxPerConcept(N, C) :- useOnly(N, C).
maxPerConcept(N, C) :-
	concept(N),
	not useOnly(N, _) ,  C = maxPerConcept.

maxPerResource(N, C) :- useOnly(N, C).
maxPerResource(N, C) :-
	usedResource(N, _),
	not useOnly(N, _) ,  C = maxPerResource.

maxPerActor(N, C) :- useOnly(N, C).
maxPerActor(N, C) :-
	actor(N, _),
	not useOnly(N, _) ,  C = maxPerActor.

{transition(N, ID) : transitionID(ID)} C :-
	concept(N),
	maxPerConcept(N, C). 
{transition(N, ID) : concept(N)} 1 :-
	transitionID(ID). 


concept(Transition_type) :- input(Transition_type, _, _, _),
	not abstract(Transition_type).
concept(Transition_type) :- output(Transition_type, _, _, _),
	not abstract(Transition_type).
minTransitionCount {transition(N, ID) : concept(N),
	transitionID(ID)} maxTransitionCount.

transitionRoleID(Transition_ID, Role_ID) :-
	transition(N, Transition_ID),
	role(N, _, _, Role_ID).
transitionPartID(Transition_ID, Role_ID) :-
	transition(N, Transition_ID),
	role(N, _, Role_ID, _).

1 {transitionResourceAssignment(Transition_ID, Role_ID, Resource_ID) : resourceID(Resource_ID)} 1 :-
	transitionRoleID(Transition_ID, Role_ID).
    
C {transitionResourceAssignment(Transition_ID, Role_ID, Resource_ID) : transitionRoleID(Transition_ID, Role_ID)} C :-
	resourceID(Resource_ID),
	maxPerResource(Resource_ID, C).

goodResourceAssignment(Transition_ID, Role_ID, Resource_ID) :-
	transitionResourceAssignment(Transition_ID, Role_ID, Resource_ID),
	role(Transition_type, Resource, _, Role_ID),
	transition(Transition_type, Transition_ID),
    hyponym(Resource, Actual_Resource),
	usedResource(Actual_Resource, Resource_ID).

:- transitionResourceAssignment(Transition_ID, Role_ID, Resource_ID),
	not goodResourceAssignment(Transition_ID, Role_ID, Resource_ID).


1 {transitionActorAssignment(Transition_ID, Part_ID, Actor_ID) : actorID(Actor_ID)} 1 :-
	transitionPartID(Transition_ID, Part_ID).
    
{transitionActorAssignment(Transition_ID, Part_ID, Actor_ID) : transitionPartID(Transition_ID, Part_ID)} C :-
	actorID(Actor_ID),
	maxPerActor(Actor_ID, C).


goodActorAssignment(Transition_ID, Part_ID, Actor_ID) :- 	
    transitionActorAssignment(Transition_ID, Part_ID, Actor_ID),	
	role(Transition_type, _, Part_ID, _),	
    transition(Transition_type, Transition_ID),	
    actor(_, Actor_ID).

:- transitionActorAssignment(Transition_ID, Part_ID, Actor_ID),
	not goodActorAssignment(Transition_ID, Part_ID, Actor_ID).

actorToTransitionPartType(Transition_type,Part_ID,Actor_ID) :-
    transitionActorAssignment(Transition_ID, Part_ID, Actor_ID), 
    transition(Transition_type, Transition_ID).

actorToTransitionPart(Transition_type,Transition_ID,Part_ID,Actor_ID) :-
    transitionActorAssignment(Transition_ID, Part_ID, Actor_ID), 
    transition(Transition_type, Transition_ID).
    
:- actorToTransitionPartType(Transition_type,Part_ID,Actor_ID), 2 {actorToTransitionPart(Transition_type,Transition_ID,Part_ID,Actor_ID)}.
  
actorToTransition(Transition_ID,Actor_ID) :-  transitionActorAssignment(Transition_ID, Part_ID, Actor_ID).

:- actorToTransition(Transition_ID,Actor_ID) , 2 { transitionActorAssignment(Transition_ID, Part_ID, Actor_ID)}.

accumulationResource(Resource_ID) :- 
    accumulation(Resource_type),	
    usedResource(Resource_type, Resource_ID).

usedAsInput(Resource_ID) :-  
    input(Transition_type,  Role_type,  Part_ID,  Resource_ID),	
    transition(Transition_type,  Transition_ID),	
    transitionResourceAssignment(Transition_ID,  Role_ID,  Resource_ID),	
    role(Transition_type,  Role_type,  Part_ID,  Resource_ID).
    
usedAsOutput(Resource_ID) :-  
    output(Transition_type,  Role_type,  Part_ID,  Resource_ID),	
    transition(Transition_type,  Transition_ID),	
    transitionResourceAssignment(Transition_ID,  Role_ID,  Resource_ID),	
	role(Transition_type,  Role_type,  Part_ID,  Resource_ID).
    
:- accumulationResource(Resource_ID),	
    usedAsInput(Resource_ID),	
    not usedAsOutput(Resource_ID).
