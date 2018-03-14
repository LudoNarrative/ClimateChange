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
