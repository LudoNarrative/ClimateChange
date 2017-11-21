

thing(0..10).

1 {chosen(X) : thing(X)} 1.


chosen(X) :- thing(X),
	     X = 5.

#show chosen/1.
