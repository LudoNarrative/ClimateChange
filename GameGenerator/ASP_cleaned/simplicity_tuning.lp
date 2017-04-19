
:- 3 {precondition(overlaps(E1,E2,POLARITY),OUTCOME)},
    entity(E1),
    entity(E2),
    polarity(POLARITY).


:- 2 {result(O,add(E,_,_))}, outcome(O).

%preconditions_allowed_per(Outcome,N) :- N = 2 + A + B,
%					A = {precondition(overlaps(E),Outcome)},
%					B = {precondition(collide(E1,E2),Outcome)} ,
%					outcome(Outcome).

has_overlaps(Outcome) :- precondition(overlaps(E),Outcome).
:- 3 {precondition(_,Outcome)},
   outcome(Outcome),
   not has_overlaps(Outcome).
:- 6 {precondition(_,Outcome)},
   outcome(Outcome).

:- 4 {result(Outcome,_)},
   outcome(Outcome).

overlaps(N) :- N =  {condition(overlaps(E))}.
avatar_controls(4) :- controlScheme(_,tank;_,asteroids;_,cardinal).
avatar_controls(2) :- controlScheme(_,horizontal;_,vertical).
avatar_controls(0) :- not controlScheme(_,tank;_,asteroids;_,cardinal;_,horizontal;_,vertical).
preconditions_allowed(N) :- N = 6 + A  + C,
			    overlaps(A),
			    avatar_controls(C).
:- N + 1 {precondition(_,_)},
   preconditions_allowed(N).


 :- N + 1 {result(_,_)},
   preconditions_allowed(N).



simple(R) :- resource(R),
	     {result(_,modify(_,R));
	      precondition(compare(_,R),_)} 3.
complex(R) :- not simple(R), resource(R).

simple(E) :- entity(E),
	     {result(_,add(E,_,_));
	      result(_,delete(E));
	      precondition(overlaps(_,E,_),_);
	      precondition(overlaps(E,_,_),_);
	      precondition(control_event(click(E)),_)} 5.
complex(E) :- not simple(E), entity(E).


complex(entities) :- 
	     5 {result(_,add(E,_,_));
	      result(_,delete(E));
	      precondition(overlaps(_,E,_),_);
	      precondition(overlaps(E,_,_),_);
	      precondition(control_event(click(E)),_)} .


readings(N) :- N = {reading(_,_)}.
:- readings(N),
   N > 15.
%#minimize { N : readings(N)}.
