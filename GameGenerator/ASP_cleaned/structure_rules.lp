

symmetric(middle,middle).
symmetric(top,bottom).
symmetric(bottom,top).
symmetric(center,center).
symmetric(left,right).
symmetric(right,left).

symmetric(location(R1,C1),location(R2,C2)) :- symmetric(R1,R2),symmetric(C1,C2),
					      row(R1),row(R2),
					      col(C1),col(C2).

in_between_horizontal(center,left,right).
in_between_horizontal(center,right,left).
in_between_vertical(middle,top,bottom).
in_between_vertical(middle,bottom,top).

location(Y,X) :- initialize(add(ENTITY,C,location(Y,X))).
location(Y,X) :- action(add(ENTITY,C,location(Y,X))).

in_between(location(YM,XM),location(Y1,X1),location(Y2,X2)) :- 1 {in_between_horizontal(XM,X1,X2); in_between_vertical(YM,Y1,Y2)},
							       location(YM,XM),location(Y1,X1),location(Y2,X2).


hasSymmetry(initialize(add(ENTITY,C,L))) :- initialize(add(ENTITY,C,L)),
			 symmetric(L,L_prime),
			 initialize(add(ENTITY,_,L_prime)).

hasSymmetry(initialize(add(ENTITY,C,L))) :-
    initialize(add(ENTITY,C,L)),
    initialize(add(ENTITY,C,L1)),
    initialize(add(ENTITY,C,L2)),
    in_between(L,L1,L2).

%:- initialize(add(ENTITY,C,L)),
%   not hasSymmetry(initialize(add(ENTITY,C,L))),
%   many(ENTITY).


hasSymmetry(result(O,add(ENTITY,C,L))) :-
    result(O,add(ENTITY,C,L)),
    symmetric(L,L_prime),
    initialize(add(ENTITY,C,L_prime)).

hasSymmetry(result(O,add(ENTITY,C,Other))) :-
    result(O,add(ENTITY,C,Other)),
    entity(Other).

%:- result(O,add(ENTITY,C,L)),
%   not hasSymmetry(result(O,C,ENTITY,L)),
%   2 {result(O,add(ENTITY,_,location(Y,X)))}.

%:- total_count(Entity,Count),
%   Count > 12.


spawnsAtInitial(E) :-
    precondition(_,O),
    result(O,add(E,C,L)),
    initialize(add(E,C,L)).

:-  precondition(_,O),
    result(O,add(E,_,location(Y,X))),
    not spawnsAtInitial(E).



%%%%%%%%%%% TO NARROW IT DOWN EVEN MORE

structure(dot,E) :-
    initialize(add(E,_,location(middle,center))),
    1 {initialize(add(E,_,_))} 1.

structure(square,E) :-
    initialize(add(E,_,location(top,left))),
    initialize(add(E,_,location(bottom,left))),
    initialize(add(E,_,location(top,right))),
    initialize(add(E,_,location(bottom,right))),
    4 {initialize(add(E,_,_))} 4.

structure(diamond,E) :-
    initialize(add(E,_,location(top,center))),
    initialize(add(E,_,location(bottom,center))),
    initialize(add(E,_,location(middle,left))),
    initialize(add(E,_,location(middle,right))),
    4 {initialize(add(E,_,_))} 4.

structure(up_tri,E) :-
    initialize(add(E,_,location(top,center))),
    initialize(add(E,_,location(bottom,left))),
    initialize(add(E,_,location(bottom,right))),
    3 {initialize(add(E,_,_))} 3.

structure(down_tri,E) :-
    initialize(add(E,_,location(bottom,center))),
    initialize(add(E,_,location(top,left))),
    initialize(add(E,_,location(top,right))),
    3 {initialize(add(E,_,_))} 3.

structure(red_rover,E) :-
    initialize(add(E,_,location(bottom,center))),
    1 {initialize(add(E,_,_))} 1,
    initialize(add(E2,_,location(top,center))),
    1 {initialize(add(E2,_,_))} 1.
    
structure(red_rover,E2) :-
    initialize(add(E,_,location(bottom,center))),
    1 {initialize(add(E,_,_))} 1,
    initialize(add(E2,_,location(top,center))),
    1 {initialize(add(E2,_,_))} 1.

structure(red_rover,E) :-
    initialize(add(E,_,location(middle,left))),
    1 {initialize(add(E,_,_))} 1,
    initialize(add(E2,_,location(middle,right))),
    1 {initialize(add(E2,_,_))} 1.
    
structure(red_rover,E2) :-
    initialize(add(E,_,location(middle,left))),
    1 {initialize(add(E,_,_))} 1,
    initialize(add(E2,_,location(middle,right))),
    1 {initialize(add(E2,_,_))} 1.



structure(red_rover,E) :-
    initialize(add(E,_,location(bottom,center))),
    initialize(add(E,_,location(bottom,left))),
    initialize(add(E,_,location(bottom,right))),
    3 {initialize(add(E,_,_))} 3,
    initialize(add(E2,_,location(top,center))),
    initialize(add(E2,_,location(top,left))),
    initialize(add(E2,_,location(top,right))),
    3 {initialize(add(E2,_,_))} 3.
    
structure(red_rover,E2) :-
    initialize(add(E,_,location(bottom,center))),
    initialize(add(E,_,location(bottom,left))),
    initialize(add(E,_,location(bottom,right))),
    3 {initialize(add(E,_,_))} 3,
    initialize(add(E2,_,location(top,center))),
    initialize(add(E2,_,location(top,left))),
    initialize(add(E2,_,location(top,right))),
    3 {initialize(add(E2,_,_))} 3.

structure(red_rover,E) :-
    initialize(add(E,_,location(middle,left))),
    initialize(add(E,_,location(top,left))),
    initialize(add(E,_,location(bottom,left))),
    3 {initialize(add(E,_,_))} 3,
    initialize(add(E2,_,location(middle,right))),
    initialize(add(E2,_,location(top,right))),
    initialize(add(E2,_,location(bottom,right))),
    3 {initialize(add(E2,_,_))} 3.
    
structure(red_rover,E2) :-
    initialize(add(E,_,location(middle,left))),
    initialize(add(E,_,location(top,left))),
    initialize(add(E,_,location(bottom,left))),
    3 {initialize(add(E,_,_))} 3,
    initialize(add(E2,_,location(middle,right))),
    initialize(add(E2,_,location(top,right))),
    initialize(add(E2,_,location(bottom,right))),
    3 {initialize(add(E2,_,_))} 3.


:- entity(E), not structure(_,E).

:- structure(S,_), 2 {structure(S,_)}.
