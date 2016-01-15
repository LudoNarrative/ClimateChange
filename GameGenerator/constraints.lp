#const maxUses = 2.
#const maxRelationships = 5.
#const maxObjectUses = 2.

infinite(somebody).
accumulation(plate).
boolean(food).

useOnly(somebody,1,1).
useOnly(eats,2).

object(somebody,1).
object(somebody,2).
object(banana,3).


%%%%%%%%%%%%%%%%%


hyponym(food,banana).

input(eats,somebody,1).
input(eats,food,2).
output(eats,somebody,1).


%input(enjoys_eating,1).
%input(enjoys_eating,food,2).
%output(enjoys_eating,somebody,1).
%output(enjoys_eating,satiation,3).


%input(offers, somebody,1).
%output(offers, somebody,1).
%output(offers, something,2).


%%%%

role(REL,ROLE,ROLE_ID) :- input(REL,ROLE,ROLE_ID).
role(REL,ROLE,ROLE_ID) :- output(REL,ROLE,ROLE_ID).

hyponym(OBJ,OBJ) :- object(OBJ,_).
hyponym(GRANDPARENT,CHILD) :- hyponym(GRANDPARENT,PARENT), hyponym(PARENT,CHILD).

relationshipIds(1..maxRelationships).
objectId(ID) :- object(_,ID).
concept(N) :- input(N,_,_).
concept(N) :- output(N,_,_).

maxPerConcept(N,C) :- useOnly(N,C).
maxPerConcept(N,C) :- concept(N), not useOnly(N,_) , C = maxUses.

maxPerObj(N,C) :- useOnly(N,_,C).
maxPerObj(N,C) :- object(N,_), not useOnly(N,_,_) , C = maxObjectUses.

1 {relationship(N,ID) : concept(N), relationshipIds(ID)} maxRelationships.
{relationship(N,ID) : relationshipIds(ID)} C :- concept(N), maxPerConcept(N,C). 
{relationship(N,ID) : concept(N)} 1 :- relationshipIds(ID). 

relationshipID(ID) :- relationship(_,ID).
relationshipRoleID(R_ID,M_ID) :- relationship(N,R_ID), role(N,_,M_ID).

1 {relationAssignment(REL_ID,ROLE_ID,OBJ_ID) : objectId(OBJ_ID)} 1 :- relationshipRoleID(REL_ID,ROLE_ID).
{relationAssignment(REL_ID,ROLE_ID,OBJ_ID) : relationshipRoleID(REL_ID,ROLE_ID)} C :-  objectId(OBJ_ID), maxPerObj(OBJ_ID,C).

goodAssignment(REL_ID,ROLE_ID,OBJ_ID) :- relationAssignment(REL_ID,ROLE_ID,OBJ_ID),  role(REL,OBJ,ROLE_ID), relationship(REL,REL_ID), 
								  hyponym(OBJ,ACTUAL_OBJ), object(ACTUAL_OBJ,OBJ_ID).

prettyAssignment(REL,REL_ID,ROLE,OBJ,OBJ_ID) :- relationAssignment(REL_ID,ROLE_ID,OBJ_ID), relationship(REL,REL_ID), role(REL,ROLE,ROLE_ID), object(OBJ,OBJ_ID).

:- relationAssignment(REL_ID,ROLE_ID,OBJ_ID), not goodAssignment(REL_ID,ROLE_ID,OBJ_ID).

:- relationAssignment(REL_ID,ROLE_ID1,OBJ), relationAssignment(REL_ID,ROLE_ID2,OBJ), ROLE_ID1 != ROLE_ID2.
