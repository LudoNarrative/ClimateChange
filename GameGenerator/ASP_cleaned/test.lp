entity(1;2).
precond(1).
a(1,1).
a(1,2).

diff(A,B) :-
    {a(Thing,A);a(Thing,B)} 1,
    precond(Thing),
    entity(A),
    entity(B).
    
