
%%%%%%%%%%%%%%%%%


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

prettyAssignment(REL,REL_ID,ROLE,OBJ,OBJ_ID,input) :- relationAssignment(REL_ID,ROLE_ID,OBJ_ID), relationship(REL,REL_ID), input(REL,ROLE,ROLE_ID), object(OBJ,OBJ_ID).
prettyAssignment(REL,REL_ID,ROLE,OBJ,OBJ_ID,output) :- relationAssignment(REL_ID,ROLE_ID,OBJ_ID), relationship(REL,REL_ID), output(REL,ROLE,ROLE_ID), object(OBJ,OBJ_ID).

:- relationAssignment(REL_ID,ROLE_ID,OBJ_ID), not goodAssignment(REL_ID,ROLE_ID,OBJ_ID).

:- relationAssignment(REL_ID,ROLE_ID1,OBJ), relationAssignment(REL_ID,ROLE_ID2,OBJ), ROLE_ID1 != ROLE_ID2.

:- relationAssignment(REL_ID,ROLE_ID,OBJ_ID), infinite(OBJ), object(OBJ,OBJ_ID), input(REL,_,ROLE_ID), not output(REL,_,ROLE_ID), relationship(REL,REL_ID).

needToAccumulate(OBJ_ID) :- relationAssignment(REL_ID1,ROLE_ID1,OBJ_ID), relationship(REL1,REL_ID1), input(REL1,ROLE1,ROLE_ID1), object(OBJ,OBJ_ID), accumulation(OBJ).

goodAccumulator(OBJ_ID) :- needToAccumulate(OBJ_ID), relationAssignment(REL_ID,ROLE_ID,OBJ_ID), output(REL,_,ROLE_ID), relationship(REL,REL_ID).
goodAccumulator(OBJ_ID) :- not needToAccumulate(OBJ_ID), relationAssignment(REL_ID,ROLE_ID,OBJ_ID).
:- not goodAccumulator(OBJ_ID), relationAssignment(_,_,OBJ_ID).

goodBoolean(OBJ_ID,OBJ) :- relationAssignment(REL_ID1,ROLE_ID1,OBJ_ID), relationship(REL1,REL_ID1), input(REL1,ROLE1,ROLE_ID1), object(OBJ,OBJ_ID), relationAssignment(REL_ID2,ROLE_ID2,OBJ_ID), relationship(REL2,REL_ID2), output(REL2,ROLE2,ROLE_ID2),boolean(OBJ_PARENT),hyponym(OBJ_PARENT,OBJ), REL_ID1 != REL_ID2.

:- boolean(OBJ_PARENT),hyponym(OBJ_PARENT,OBJ), object(OBJ,OBJ_ID), not goodBoolean(OBJ_ID,OBJ), relationAssignment(_,_,OBJ_ID).


mismatch(REL_ID1,REL_ID2) :- relationAssignment(REL_ID1,ROLE_ID,OBJ_ID1), relationship(REL,REL_ID1), relationAssignment(REL_ID2,ROLE_ID,OBJ_ID2),  relationship(REL,REL_ID2), OBJ_ID1 != OBJ_ID2, REL_ID1 != REL_ID2.

:-  relationAssignment(REL_ID1,ROLE_ID,OBJ_ID1), relationship(REL,REL_ID1), relationAssignment(REL_ID2,ROLE_ID,OBJ_ID2),  relationship(REL,REL_ID2), not mismatch(REL_ID1,REL_ID2), REL_ID1 != REL_ID2.