

spawnsAtInitial(E) :-
    precondition(_,O),
    result(O,add(E,C,L)),
    initialize(add(E,C,L)).

1 {pool(E,L,LocationType,WithinType) : spawn_types(LocationType), spawn_types(WithinType)} 1:-
    precondition(_,O),
    initialize(add(E,C,L)).
{pool(E,location(R,C),LocationType,WithinType) : row(R),col(C),spawn_types(LocationType), spawn_types(WithinType), entity(E)}.

%:- 2 {pool(E,location(R,C),LocationType,WithinType)},
%   entity(E),
%   location(R,C).
    
:- pool(E,L1,LT1,WT1),
   pool(E,L2,LT2,WT2),
   LT1 != LT2.
:- pool(E,L1,LT1,WT1),
   pool(E,L2,LT2,WT2),
   WT1 != WT2.

   
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

