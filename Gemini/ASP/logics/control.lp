logic_g3(L) :- control_logic_g3(L).

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
:- agent_g3(L, _), not control_logic_g3(L).
:- control_logic_g3(L), not agent_g3(L, _).
:- action_g3(L, _, _), not control_logic_g3(L).
:- control_logic_g3(L), not action_g3(L, _, _).
:- control_logic_g3(L), {input_map_g3(L, _, _, _)}0.
:- control_logic_g3(L), input_map_g3(L, I, _, _), not input_g3(L, I). 
% TODO runtime changes to input map?  agent assignments? etc

q_op_g3(L, control_action(Ag, Ac)) :-
  control_logic_g3(L),
  action_g3(L, Ag, Ac),
  agent_g3(L, Ag),
  input_map_g3(L, I, Ag, Ac).

a_op_g3(L, do_action(Ag, Ac)) :-
  control_logic_g3(L),
  q_op_g3(L, control_action(Ag, Ac)).

prerequisite_g3(L, do_action(Ag, Ac), L, control_action(Ag, Ac)) :-
  control_logic_g3(L),
  q_op_g3(L, control_action(Ag, Ac)),
  a_op_g3(L, do_action(Ag, Ac)).

prerequisite_g3(L, control_action(Ag, Ac), L, do_action(Ag, Ac)) :-
  control_logic_g3(L),
  q_op_g3(L, control_action(Ag, Ac)),
  a_op_g3(L, do_action(Ag, Ac)).
