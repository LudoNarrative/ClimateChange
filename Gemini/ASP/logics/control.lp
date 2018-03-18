logic(L) :- control_logic(L).

% Map button inputs, AI intentions, network socket messages, etc onto high-level game actions, possibly grouped onto specific loci of control like characters according to the event source.

% * Change which character the player (or another event source) is controlling
% * Change the mapping between low-level inputs and high-level actions
% * Determine the available high-level actions at a given time for a given actor

% ^--- an alternative is just to have mouse click state and mouse position as inputs
% control_input()
% The other alternative is to say the two abstract inputs for every entity are to set its target position and rotation and maybe alter its character state or physics
% an entity's physics here include its angular/linear velocity, velocity maxima, and accelerations
% steering behaviors give us orbit, attract, flee, and draggable

% TODO see the email to melanie for more info

% Validity
:- agent(L, _), not control_logic(L).
:- action(L, _, _), not control_logic(L).
:- control_logic(L), not input_map(L, _, _, _).

% TODO runtime changes to input map?  agent assignments? etc

q_op(L, control_action(Ag, Ac)) :-
  control_logic(L),
  action(L, Ag, Ac),
  agent(L, Ag),
  input_map(L, I, Ag, Ac).

a_op(L, do_action(Ag, Ac)) :-
  control_logic(L),
  q_op(L, control_action(Ag, Ac)).

prerequisite(L, do_action(Ag, Ac), L, control_action(Ag, Ac)) :-
  control_logic(L),
  q_op(L, control_action(Ag, Ac)),
  a_op(L, do_action(Ag, Ac)).

prerequisite(L, control_action(Ag, Ac), L, do_action(Ag, Ac)) :-
  control_logic(L),
  q_op(L, control_action(Ag, Ac)),
  a_op(L, do_action(Ag, Ac)).
