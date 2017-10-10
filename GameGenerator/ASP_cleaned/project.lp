

%:- resource_checks(N), N > 3.
controlScheme(SCHEME) :- controlScheme(ENTITY,SCHEME).
behavior(BEHAVIOR)  :-  behavior(ENTITY,BEHAVIOR) .

project(player_controls(C)) :- player_controls(C).
project(behavior(C)) :- behavior(C).

project(controlScheme(C)) :- controlScheme(C).
project(R) :- resource(R).
project(E) :- entity(E).
project(T) :- timer(T).
%project(relative(greater,result(Outcome1,modify(Direction,Resource1)),result(Outcome2,modify(Direction,Resource2)))) :- relative(greater,result(Outcome1,modify(Direction,Resource1)),result(Outcome2,modify(Direction,Resource2))).
project(static(E)) :- static(E).
project( initialize(add(Entity,scalar(1),location(Row,Col))) ) :  initialize(add(Entity,scalar(1),location(Row,Col))) .

%grouped(A1,A2) :- result(O,A1), result(O,A2).
%grouped(A1,A2) :- precondition(A1,O), precondition(A2,O).
%project(grouped(A1,A2)) :- grouped(A1,A2).

%#show precondition/2.
#project project/1.
%#project boundary/1.
%#project pruned_action/1.

pruned_action(add(E,L)) :- action(add(E,_,L)).
pruned_action(delete(E)) :- action(delete(E)).
pruned_action(modify(Dir,R)) :- action(modify(Dir,R)).
pruned_action(rotates(E,D,V)) :- action(rotates(E,D,V)).
pruned_action(rotate_to(E)) :- action(rotate_to(E)).
pruned_action(look_at(E,E2,C)) :- action(look_at(E,E2,C)).
pruned_aciton(move(E,D)) :- action(move(E,D)).
