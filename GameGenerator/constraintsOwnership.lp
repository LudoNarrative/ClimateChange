
actorID(ID) :- actor(_,ID).
relationshipID(1..maxRelationshipCount).
entityID(1..entityCount).

entityType(NAME) :- input(_,NAME,_,_), not abstract(NAME).
entityType(NAME) :- output(_,NAME,_,_), not abstract(NAME).
entityType(NAME) :- hyponym(NAME,_), not abstract(NAME).
entityType(NAME) :- hyponym(_,NAME), not abstract(NAME).
hyponym(NAME,NAME) :- entityType(NAME).

{usedEntity(NAME,ID) : entityType(NAME)} 1 :- entityID(ID).
1 {usedEntity(NAME,ID) : entityType(NAME), entityID(ID)}.
C {usedEntity(NAME,ID) : entityID(ID)} C :- entity(NAME,C).


input(REL,ROLE,ACTOR_ID,ROLE_ID) :- input(PARENT_REL,ROLE,ACTOR_ID,ROLE_ID), hyponym(PARENT_REL,REL).
output(REL,ROLE,ACTOR_ID,ROLE_ID) :- output(PARENT_REL,ROLE,ACTOR_ID,ROLE_ID), hyponym(PARENT_REL,REL).
role(REL,ROLE,ACTOR_ID,ROLE_ID) :- input(REL,ROLE,ACTOR_ID,ROLE_ID).
role(REL,ROLE,ACTOR_ID,ROLE_ID) :- output(REL,ROLE,ACTOR_ID,ROLE_ID).

maxPerConcept(N,C) :- useOnly(N,C).
maxPerConcept(N,C) :- concept(N), not useOnly(N,_) , C = maxPerConcept.

maxPerEntity(N,C) :- useOnly(N,C).
maxPerEntity(N,C) :- usedEntity(N,_), not useOnly(N,_) , C = maxPerEntity.

maxPerActor(N,C) :- useOnly(N,C).
maxPerActor(N,C) :- actor(N,_), not useOnly(N,_) , C = maxPerActor.

{relationship(N,ID) : relationshipID(ID)} C :- concept(N), maxPerConcept(N,C). 
{relationship(N,ID) : concept(N)} 1 :- relationshipID(ID). 


concept(NAME) :- input(NAME,_,_,_), not abstract(NAME).
concept(NAME) :- output(NAME,_,_,_), not abstract(NAME).
minRelationshipCount {relationship(N,ID) : concept(N), relationshipID(ID)} maxRelationshipCount.

relationshipRoleID(REL_ID,ROLE_ID) :- relationship(N,REL_ID), role(N,_,_,ROLE_ID).
relationshipPartID(REL_ID,ROLE_ID) :- relationship(N,REL_ID),role(N,_,ROLE_ID,_).

1 {relationEntityAssignment(REL_ID,ROLE_ID,ENTITY_ID) : entityID(ENTITY_ID)} 1 :- relationshipRoleID(REL_ID,ROLE_ID).
C {relationEntityAssignment(REL_ID,ROLE_ID,ENTITY_ID) : relationshipRoleID(REL_ID,ROLE_ID)} C :-  entityID(ENTITY_ID), maxPerEntity(ENTITY_ID,C).

goodEntityAssignment(REL_ID,ROLE_ID,ENTITY_ID) :- 	relationEntityAssignment(REL_ID,ROLE_ID,ENTITY_ID),  
											role(REL,ENTITY,_,ROLE_ID), relationship(REL,REL_ID), 
								  			hyponym(ENTITY,ACTUAL_ENTITY), usedEntity(ACTUAL_ENTITY,ENTITY_ID).

:- relationEntityAssignment(REL_ID,ROLE_ID,ENTITY_ID), not goodEntityAssignment(REL_ID,ROLE_ID,ENTITY_ID).


1 {relationActorAssignment(REL_ID,PART_ID,ACTOR_ID) : actorID(ACTOR_ID)} 1 :- relationshipPartID(REL_ID,PART_ID).
{relationActorAssignment(REL_ID,PART_ID,ACTOR_ID) : relationshipPartID(REL_ID,PART_ID)} C :-  actorID(ACTOR_ID), maxPerActor(ACTOR_ID,C).


goodActorAssignment(REL_ID,PART_ID,ACTOR_ID) :- 	relationActorAssignment(REL_ID,PART_ID,ACTOR_ID),  
											role(REL,_,PART_ID,_), relationship(REL,REL_ID), actor(_,ACTOR_ID).

:- relationActorAssignment(REL_ID,PART_ID,ACTOR_ID), not goodActorAssignment(REL_ID,PART_ID,ACTOR_ID).

:- relationActorAssignment(REL_ID1,PART_ID,ACTOR_ID),relationActorAssignment(REL_ID2,PART_ID,ACTOR_ID), relationship(REL,REL_ID1),relationship(REL,REL_ID2), REL_ID1 != REL_ID2.

:- relationActorAssignment(REL_ID,PART_ID1,ACTOR_ID),relationActorAssignment(REL_ID,PART_ID2,ACTOR_ID), PART_ID1 != PART_ID2.


connection(REL_ID1,ACTOR_ID1,REL_ID2,ACTOR_ID2) :- 	relationEntityAssignment(REL_ID1,_,ENTITY_ID),relationActorAssignment(REL_ID1,PART_ID1,ACTOR_ID1),
								relationship(REL1,REL_ID1) ,role(REL1,_,PART_ID1,ROLE_ID1),
								relationEntityAssignment(REL_ID2,_,ENTITY_ID),relationActorAssignment(REL_ID2,PART_ID2,ACTOR_ID2),relationship(REL2,REL_ID2) ,role(REL2,_,PART_ID2,ROLE_ID2), REL1 != REL2, input(REL1,_,PART_ID1,ROLE_ID1), output(REL2,_,PART_ID2,ROLE_ID2).
connection(REL_ID1,ACTOR_ID1,REL_ID2,ACTOR_ID2) :- connection(REL_ID2,ACTOR_ID2,REL_ID1,ACTOR_ID1).
connection(REL_ID1,ACTOR_ID1,REL_ID3,ACTOR_ID3) :- connection(REL_ID1,ACTOR_ID1,REL_ID2,ACTOR_ID2), connection(REL_ID2,ACTOR_ID2,REL_ID3,ACTOR_ID3).


:- not connection(REL_ID1,ACTOR_ID1,REL_ID2,ACTOR_ID2), relationActorAssignment(REL_ID1,_,ACTOR_ID1),relationActorAssignment(REL_ID2,_,ACTOR_ID2),REL_ID1 != REL_ID2.

%%%%

needToAccumulate(ENTITY_ID,ACTOR_ID) :- relationEntityAssignment(REL_ID,ROLE_ID,ENTITY_ID), relationship(REL,REL_ID), input(REL,ROLE,PART_ID,ROLE_ID), usedEntity(ENTITY,ENTITY_ID), accumulation(ENTITY), relationActorAssignment(REL_ID,PART_ID,ACTOR_ID).

goodAccumulator(ENTITY_ID,ACTOR_ID) :- needToAccumulate(ENTITY_ID,ACTOR_ID), relationEntityAssignment(REL_ID,ROLE_ID,ENTITY_ID), output(REL,_,PART_ID,ROLE_ID), relationship(REL,REL_ID), relationActorAssignment(REL_ID,PART_ID,ACTOR_ID), not input(REL,_,_,ROLE_ID).

goodAccumulator(ENTITY_ID,ACTOR_ID) :- not needToAccumulate(ENTITY_ID,ACTOR_ID), 
										relationEntityAssignment(REL_ID,ROLE_ID,ENTITY_ID), 
										relationActorAssignment(REL_ID,PART_ID,ACTOR_ID),role(REL,ROLE,PART_ID,ROLE_ID).

:- not goodAccumulator(ENTITY_ID,ACTOR_ID), relationEntityAssignment(REL_ID,ROLE_ID,ENTITY_ID),relationActorAssignment(REL_ID,PART_ID,ACTOR_ID).

%%%%




%%%%

prettyAssignment(REL,REL_ID,ROLE,ENTITY,ENTITY_ID,PART_ID,ACTOR,ACTOR_ID, input) :- input(REL,ROLE,PART_ID,ROLE_ID), 
			relationEntityAssignment(REL_ID,ROLE_ID,ENTITY_ID), relationship(REL,REL_ID), usedEntity(ENTITY,ENTITY_ID), 
			relationActorAssignment(REL_ID,PART_ID,ACTOR_ID), actor(ACTOR,ACTOR_ID).

prettyAssignment(REL,REL_ID,ROLE,ENTITY,ENTITY_ID,PART_ID,ACTOR,ACTOR_ID, output) :- output(REL,ROLE,PART_ID,ROLE_ID), 
			relationEntityAssignment(REL_ID,ROLE_ID,ENTITY_ID), relationship(REL,REL_ID), usedEntity(ENTITY,ENTITY_ID), 
			relationActorAssignment(REL_ID,PART_ID,ACTOR_ID), actor(ACTOR,ACTOR_ID).