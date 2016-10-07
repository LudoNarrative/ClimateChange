

:- 8 {precondition(_,_)}.


:- 8 {result(_,_)}.


simple(R) :- resource(R),
	     {result(_,increase(R));
	      result(_,decrease(R));
	      precondition(le(R),_);
	      precondition(ge(R),_)} 3.
complex(R) :- not simple(R), resource(R).

simple(E) :- entity(E),
	     {result(_,add(E,_));
	      result(_,delete(E));
	      precondition(overlaps(_,E,_),_);
	      precondition(overlaps(E,_,_),_);
	      precondition(control_event(click(E)),_)} 3.
complex(E) :- not simple(E), entity(E).


complex(entities) :- 
	     5 {result(_,add(E,_));
	      result(_,delete(E));
	      precondition(overlaps(_,E,_),_);
	      precondition(overlaps(E,_,_),_);
	      precondition(control_event(click(E)),_)} .
