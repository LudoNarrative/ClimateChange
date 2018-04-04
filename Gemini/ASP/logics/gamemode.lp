logic_g3(L) :- gamemode_logic_g3(L).

:- gamemode_g3(L, G), not gamemode_logic_g3(L).
:- gamemode_logic_g3(L), not gamemode_g3(L, _).
:- gamemode_logic_g3(L), not init_g3(L, gamemode(_)).

q_op_g3(L, gamemode(G, Bool)) :-
  gamemode_logic_g3(L),
  bool_g3(Bool),
  gamemode_g3(L, G).

a_op_g3(L, set_gamemode(G)) :-
  gamemode_logic_g3(L),
  gamemode_g3(L, G).

precondition_g3(L, set_gamemode(G), L, gamemode(G, false)) :-
  gamemode_logic_g3(L),
  gamemode_g3(L, G).
