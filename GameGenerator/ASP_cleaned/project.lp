


1 {a(N,M) :  N = 1..3, M = 1..3} 1.
1 {b(N,M) :  N = 1..3, M = 1..3}.



sum(K) :- a(N,M), K = N + M.

#project b/2.