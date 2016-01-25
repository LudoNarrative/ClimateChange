
%I think something like input(relationship,ENTITYect type, owner id, ENTITYect id) is probably fine - 
%There can be a couple special purpose owner ids - System, NoOne, Player if we want to capture something

actor(player,1).
actor(friend,2).
actor(friend,3).

entity(food,1).

#const entityCount = 5.
#const relationshipCount = 5.
#const maxPerConcept = 3.
#const maxPerEntity = 3.
#const maxPerActor = 3.
%%%%%%%%%

hyponym(something,food).

input(eat,food,1,1).

input(enjoys_eating,food,1,1).
output(enjoys_eating,satiation,1,2).

input(relieve_hunger,food,1,1).
input(relieve_hunger,hunger,1,2).

input(get_hungry,time,none,1).
output(get_hungry,hunger,1,1).

input(offers, something,1,1).
output(offers,something,2,1).


%%%%%%%%%%%

actorID(ID) :- actor(_,ID).
relationshipID(1..relationshipCount).
entityID(1..entityCount).

entityType(NAME) :- input(_,NAME,_,_).
entityType(NAME) :- output(_,NAME,_,_).


role(REL,ROLE,ACTOR_ID,ROLE_ID) :- input(REL,ROLE,ACTOR_ID,ROLE_ID).
role(REL,ROLE,ACTOR_ID,ROLE_ID) :- output(REL,ROLE,ACTOR_ID,ROLE_ID).


{usedEntity(NAME,ID) : entityType(NAME)} 1 :- entityID(ID).
1 {usedEntity(NAME,ID) : entityType(NAME), entityID(ID)}.
C {usedEntity(NAME,ID) : entityID(ID)} C :- entity(NAME,C).


concept(NAME) :- input(NAME,_,_,_).
concept(NAME) :- output(NAME,_,_,_).
1 {relationship(N,ID) : concept(N), relationshipID(ID)} relationshipCount.


maxPerConcept(N,C) :- useOnly(N,C).
maxPerConcept(N,C) :- concept(N), not useOnly(N,_) , C = maxUses.

maxPerEntity(N,C) :- useOnly(N,C).
maxPerEntity(N,C) :- usedEntity(N,_), not useOnly(N,_) , C = maxPerEntity.

maxPerActor(N,C) :- useOnly(N,C).
maxPerActor(N,C) :- actor(N,_), not useOnly(N,_) , C = maxPerActor.

{relationship(N,ID) : relationshipID(ID)} C :- concept(N), maxPerConcept(N,C). 
{relationship(N,ID) : concept(N)} 1 :- relationshipID(ID). 

usedRelationshipID(ID) :- relationship(_,ID).
relationshipRoleID(REL_ID,ROLE_ID) :- relationship(N,REL_ID), role(N,_,_,ROLE_ID).
relationshipActorID(REL_ID,ROLE_ID) :- relationship(N,REL_ID),role(N,_,ROLE_ID,_).


1 {relationEntityAssignment(REL_ID,ROLE_ID,ENTITY_ID) : entityID(ENTITY_ID)} 1 :- relationshipRoleID(REL_ID,ROLE_ID).
{relationEntityAssignment(REL_ID,ROLE_ID,ENTITY_ID) : relationshipRoleID(REL_ID,ROLE_ID)} C :-  entityID(ENTITY_ID), maxPerEntity(ENTITY_ID,C).


goodEntityAssignment(REL_ID,ROLE_ID,ENTITY_ID) :- 	relationEntityAssignment(REL_ID,ROLE_ID,ENTITY_ID),  
											role(REL,ENTITY,_,ROLE_ID), relationship(REL,REL_ID), 
								  			hyponym(ENTITY,ACTUAL_ENTITY), usedEntity(ACTUAL_ENTITY,ENTITY_ID).

:- relationEntityAssignment(REL_ID,ROLE_ID,ENTITY_ID), not goodEntityAssignment(REL_ID,ROLE_ID,ENTITY_ID).


1 {relationActorAssignment(REL_ID,ROLE_ID,ACTOR_ID) : actorID(ACTOR_ID)} 1 :- relationshipActorID(REL_ID,ROLE_ID).
{relationActorAssignment(REL_ID,ROLE_ID,ACTOR_ID) : relationshipRoleID(REL_ID,ROLE_ID)} C :-  actorID(ACTOR_ID), maxPerActor(ACTOR_ID,C).


goodActorAssignment(REL_ID,ROLE_ID,ACTOR_ID) :- 	relationActorAssignment(REL_ID,ROLE_ID,ACTOR_ID),  
											role(REL,_,ACTOR_ID,_), relationship(REL,REL_ID), actor(_,ACTOR_ID).

:- relationActorAssignment(REL_ID,ROLE_ID,ACTOR_ID), not goodActorAssignment(REL_ID,ROLE_ID,ACTOR_ID).

:- relationActorAssignment(REL_ID,ROLE_ID1,ACTOR_ID),relationActorAssignment(REL_ID,ROLE_ID2,ACTOR_ID), ROLE_ID1 != ROLE_ID2.



prettyAssignment(REL,REL_ID,ROLE,ENTITY,ENTITY_ID,ACTOR,ACTOR_ID, input) :- input(REL,ROLE,PART_ID,ROLE_ID), 
			relationEntityAssignment(REL_ID,ROLE_ID,ENTITY_ID), relationship(REL,REL_ID), usedEntity(ENTITY,ENTITY_ID), 
			relationActorAssignment(REL_ID,PART_ID,ACTOR_ID), actor(ACTOR,ACTOR_ID).

prettyAssignment(REL,REL_ID,ROLE,ENTITY,ENTITY_ID,ACTOR,ACTOR_ID, output) :- output(REL,ROLE,PART_ID,ROLE_ID), 
			relationEntityAssignment(REL_ID,ROLE_ID,ENTITY_ID), relationship(REL,REL_ID), usedEntity(ENTITY,ENTITY_ID), 
			relationActorAssignment(REL_ID,PART_ID,ACTOR_ID), actor(ACTOR,ACTOR_ID).
