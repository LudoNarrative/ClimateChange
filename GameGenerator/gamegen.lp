#const objectCount=3.

%GENERAL
objects(1..objectCount).
%:- not good.

{rhetoric(NAME,SUBJ,OBJ,TARGET) : rhetorics(NAME)}  :- SUBJ != OBJ, SUBJ != TARGET, OBJ != TARGET, objects(SUBJ), objects(OBJ), objects(TARGET).
{rhetoric(NAME,SUBJ,OBJ) :rhetorics(NAME)} :- SUBJ != OBJ, objects(SUBJ), objects(OBJ).

rhetoric(X) :- rhetoric(X,_,_,_).
rhetoric(X) :- rhetoric(X,_,_).

used(ID) :- rhetoric(_,ID,_,_).
used(ID) :- rhetoric(_,_,ID,_).
used(ID) :- rhetoric(_,_,_,ID).
used(ID) :- rhetoric(_,ID,_).
used(ID) :- rhetoric(_,_,ID).


1 {aMechanic(NAME) : abstract_mechanics(NAME)} 1. %?
1 {role(ID,ABS_MECH,ROLE) : roles(ROLE)  } 1:-  used(ID),aMechanic(ABS_MECH).
:- not used(PLAYERID), hook(PLAYERID,player).

%The dinner scenario
%*
hook(1,passable).
hook(1,consumable).
hook(2,passable).
hook(2,consumable).
hook(3,catches).
hook(3,consumes).
hook(3,hungry).
hook(3,animate).
hook(3,passes).
hook(4,animate).
hook(4,passes).
hook(4,catches).
hook(4,consumes).
hook(4,hungry).
hook(5,player).
hook(5,catches).
hook(5,passes).
hook(5,consumes).
*%

%The dinner scenario
%*
hook(1,passable).
hook(1,consumable).
hook(2,passable).
hook(2,consumable).
hook(3,catches).
hook(3,consumes).
hook(3,hungry).
hook(3,animate).
hook(3,passes).
hook(4,animate).
hook(4,passes).
hook(4,catches).
hook(4,consumes).
hook(4,hungry).
hook(5,player).
hook(5,catches).
hook(5,passes).
hook(5,consumes).
*%
%END The dinner scenario


%The scrubbing scenario

hook(1,interesting).
hook(1,findable).
hook(2,covers).
hook(2,wipeable).
hook(3,animate).
hook(3,player).

%END The scrubbing scenario


%LESS GENERAL - BUT STILL GENERAL

rhetorics(pass_to;;eats).
rhetorics(uncovers).

%abstract_mechanics(request_satisfaction).
roles(requestor;;satisfier;;source;;deliverer).

abstract_mechanics(unobscure).
roles(obscurer;;obscured;;unobscurer).

%% Properties -> Rhetorics
:- rhetoric(pass_to,SUBJ,_,_),  not hook(SUBJ,passes).
:- rhetoric(pass_to,_,OBJ,_),  not hook(OBJ,passable).
:- rhetoric(pass_to,_,_,TARGET),  not hook(TARGET,catches).
:- rhetoric(pass_to,_,_).

:- rhetoric(eats,_,_,_).
:- rhetoric(eats,SUBJ,_), not hook(SUBJ,consumes).
:- rhetoric(eats,_,OBJ), not hook(OBJ,consumable).

:- rhetoric(uncovers,SUBJ,_,_),  not hook(SUBJ,animate).
:- rhetoric(uncovers,_,OBJ,_),  not hook(OBJ,covers), not hook(OBJ,wipeable).
:- rhetoric(uncovers,_,_,TARGET),  not hook(TARGET,findable).
:- rhetoric(uncovers,_,_).


%% Rhetorics -> Abstract Mechanics
good :- role(SUBJ_1,request_satisfaction,source), role(OBJ,request_satisfaction,satisfier), 
     	role(SUBJ,request_satisfaction,deliverer), role(TARGET,request_satisfaction,requestor) , 
     	rhetoric(eats,TARGET,OBJ), rhetoric(pass_to,SUBJ,OBJ,TARGET), rhetoric(pass_to,SUBJ_1,OBJ,SUBJ).

good :- role(SUBJ,unobscure,unobscurer),  role(OBJ,unobscure,obscurer), role(TARGET,unobscure,obscured) , 
     	rhetoric(uncovers,SUBJ,OBJ,TARGET).

:- not good.

