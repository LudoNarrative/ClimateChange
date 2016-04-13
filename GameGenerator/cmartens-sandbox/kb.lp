%% Some quick predicate-based sketching of a game knowledge database to be
%% for design intent queries.
%% Started 3/1/2016 by Chris Martens.

%% available games
game(scrubbing).
game(sokoban).


%%%% game descriptions %%%%
% Have mechanics, entities, and values.
% Predicates used include...
% stuff a game can have -
%   has_mechanic(GAME, MECHANIC).
%   has_meter(GAME, METER).
%   has_entity(GAME, ENTITY).
%   has_value(GAME, ENTITY, VALUE).
% stuff a mechanic can do -
%   increases(GAME, MECHANIC, METER). 
%   decreases(GAME, MECHANIC, METER).
%   changes(GAME, MECHANIC, VALUE).
% ways mechanics can be constrained -
%   impedes(GAME, ENTITY, MECHANIC).
%   enables(???)
% (TODO: more/tweak this to be as expressive as our diagrams,
%   or possibly even structural mechanic levels of detail.)
%

% scrubbing
has_mechanic(scrubbing, clearing_sand).
has_meter(scrubbing, progress).
increases(scrubbing, clearing_sand, progress).

%% sokoban
has_mechanic(sokoban, movement).
has_mechanic(sokoban, push).
has_meter(sokoban, targets_matched).

has_entity(sokoban, target, many).
has_value(sokoban, target, position).

has_entity(sokoban, mover, one).
has_value(sokoban, mover, position).

has_entity(sokoban, block, many).
has_value(sokoban, block, position).

changes(movement, mover, position).
changes(push, block, position).
increases(push, block, targets_matched).
decreases(push, block, targets_matched).
impedes(block, movement).
impedes(block, push).

mechanic(M) :- has_mechanic(G,M).
%% rules for interpreting whether a game description matches a design
%% intent

% a mechanic is meditative if nothing impedes it.
non_meditative(M) :- impedes(M_prime, M).
meditative(M) :- mechanic(M), not non_meditative(M).
% other things to capture:
% - monotonocity of progress
% - allocation of resources; feedback loops that constrain future choices
% - uncertainty/external factors
% - time pressure


