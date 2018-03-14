logic(L) :- physics_logic(L).

:- physics_mode(P), not physics_logic(L).

% * Determine an object's physical quantities based on terms from some other logic (e.g., character-state, resource).

% option: alter physical properties in some way?

% let's say steering behaviors are the composition that handle low level physics: adjusting velocities, accelerations, etc
