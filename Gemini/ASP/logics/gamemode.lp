logic(L) :- gamemode_logic(L).

:- gamemode(L, G), not gamemode_logic(L).
:- gamemode_logic(L), not gamemode(L, _).
:- gamemode_logic(L), not init(L, gamemode(_)).

q_op(L, gamemode(G, Bool)) :-
  gamemode_logic(L),
  bool(Bool),
  gamemode(L, G).

a_op(L, set_gamemode(G)) :-
  gamemode_logic(L),
  gamemode(L, G).

precondition(L, set_gamemode(G), L, gamemode(G, false)) :-
  gamemode_logic(L),
  gamemode(L, G).
