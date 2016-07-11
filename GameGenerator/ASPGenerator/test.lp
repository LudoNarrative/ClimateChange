p(a).
p(b).
p(c).

% q(X) :- p(X).

% {q(a); q(b); q(c)}.

{q(X) : p(X)}.
