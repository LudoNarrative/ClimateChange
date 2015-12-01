#const objectCount=5.

%GENERAL
objects(1..objectCount).
%:- not good.

{relationship(NAME,SUBJ,OBJ,TARGET) : relationships(NAME)}  :- SUBJ != OBJ, SUBJ != TARGET, OBJ != TARGET, objects(SUBJ), objects(OBJ), objects(TARGET).
{relationship(NAME,SUBJ,OBJ) :relationships(NAME)} :- SUBJ != OBJ, objects(SUBJ), objects(OBJ).

relationship(X) :- relationship(X,_,_,_).
relationship(X) :- relationship(X,_,_).

used(ID) :- relationship(_,ID,_,_).
used(ID) :- relationship(_,_,ID,_).
used(ID) :- relationship(_,_,_,ID).
used(ID) :- relationship(_,ID,_).
used(ID) :- relationship(_,_,ID).


1 {aMechanic(NAME) : abstract_mechanics(NAME)} 1. %?
1 {role(ID,ABS_MECH,ROLE) : roles(ROLE)  } 1:-  used(ID),aMechanic(ABS_MECH).
:- not used(PLAYERID), affordance(PLAYERID,player).

%The dinner scenario

affordance(1,passable).
affordance(1,consumable).
affordance(2,passable).
affordance(2,consumable).
affordance(3,catches).
affordance(3,consumes).
affordance(3,hungry).
affordance(3,animate).
affordance(3,passes).
affordance(4,animate).
affordance(4,passes).
affordance(4,catches).
affordance(4,consumes).
affordance(4,hungry).
affordance(5,player).
affordance(5,catches).
affordance(5,passes).
affordance(5,consumes).



%END The dinner scenario


%The scrubbing scenario

%*
affordance(1,interesting).
affordance(1,findable).
affordance(2,covers).
affordance(2,wipeable).
affordance(3,animate).
affordance(3,player).
*%
%END The scrubbing scenario


%LESS GENERAL - BUT STILL GENERAL

relationships(pass_to;;eats).
relationships(uncovers).

%abstract_mechanics(request_satisfaction).
roles(requestor;;satisfier;;source;;deliverer).

abstract_mechanics(unobscure;;request_satisfaction).
roles(obscurer;;obscured;;unobscurer).

%% Properties -> Relationships
:- relationship(pass_to,SUBJ,_,_),  not affordance(SUBJ,passes).
:- relationship(pass_to,_,OBJ,_),  not affordance(OBJ,passable).
:- relationship(pass_to,_,_,TARGET),  not affordance(TARGET,catches).
:- relationship(pass_to,_,_).

:- relationship(eats,_,_,_).
:- relationship(eats,SUBJ,_), not affordance(SUBJ,consumes).
:- relationship(eats,_,OBJ), not affordance(OBJ,consumable).

:- relationship(uncovers,SUBJ,_,_),  not affordance(SUBJ,animate).
:- relationship(uncovers,_,OBJ,_),  not affordance(OBJ,covers), not affordance(OBJ,wipeable).
:- relationship(uncovers,_,_,TARGET),  not affordance(TARGET,findable).
:- relationship(uncovers,_,_).


%% Relationships -> Abstract Mechanics
good :- role(SUBJ_1,request_satisfaction,source), role(OBJ,request_satisfaction,satisfier), 
     	role(SUBJ,request_satisfaction,deliverer), role(TARGET,request_satisfaction,requestor) , 
     	relationship(eats,TARGET,OBJ), relationship(pass_to,SUBJ,OBJ,TARGET), relationship(pass_to,SUBJ_1,OBJ,SUBJ).

good :- role(SUBJ,unobscure,unobscurer),  role(OBJ,unobscure,obscurer), role(TARGET,unobscure,obscured) , 
     	relationship(uncovers,SUBJ,OBJ,TARGET).

:- not good.

