logic(L) :- gamemode_logic(L).

:- gamemode(L, G), not gamemode_logic(L).
:- gamemode_logic(L), not gamemode(L, _).
:- gamemode_logic(L), not init(L, gamemode(_)).

q_op(L, gamemode(G)) :-
  gamemode_logic(L),
  gamemode(G).

a_op(L, set_gamemode(G)) :-
  gamemode_logic(L),
  gamemode(G).
