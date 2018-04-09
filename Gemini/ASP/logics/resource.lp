logic_g3(L) :- resource_logic_g3(L).

resource_change_direction_g3(inc;dec).

resource_amount_g3(L, r(0)) :- resource_logic_g3(L).
resource_amount_g3(L, inf) :- resource_logic_g3(L).
resource_amount_g3(L, ninf) :- resource_logic_g3(L).
resource_amount_g3(L, P) :- resource_logic_g3(L), resource_pool_g3(L, P).

% For now pool capacities are fixed
{resource_pool_capacity_g3(L, P, r(Amt))} :-
  resource_logic_g3(L),
  resource_amount_g3(L, r(Amt)),
  resource_pool_g3(L, P).

{resource_pool_capacity_g3(L, P, inf)} :-
  resource_logic_g3(L),
  resource_pool_g3(L, P).
  
:- resource_pool_g3(L, _), not resource_logic_g3(L).
:- resource_pool_g3(L, P), not 1{resource_pool_capacity_g3(L, P, _)}1.

% pools need initial contents
% "guess a default but admit overriding with explicit facts"
init_ok_g3(L, alter_resource(P, inc, r(K))) :-
  resource_logic_g3(L),
  resource_pool_g3(L, P),
  resource_amount_g3(L, r(K)).

% state_feedback_g3(L, resource_pool(P)) :-
%   resource_logic_g3(L),
%   resource_pool_g3(L, P).


% * Check if a transaction involving some units of certain resources is possible for some given locations.
% * Perform a resource transaction.
% * Perform an action of another logic when a transaction occurs.
% * Perform an action of another logic when the quantity of resources within a location crosses a threshold.

% ^--- we use a simplified resource logic where the only transactions increase or decrease the amount of a uniform resource in a single pool, or move resource from one pool to another

q_op_g3(L, has_resource(P, Cmp, Amt)) :-
  resource_logic_g3(L),
  resource_pool_g3(L, P),
  resource_amount_g3(L, Amt),
  comparator_g3(Cmp),
  Amt != inf,
  Amt != ninf,
  P != Amt.

% feedback_g3(L, has_resource(P, Cmp, Amt)) :-
%   resource_logic_g3(L),
%   q_op_g3(L, has_resource(P, Cmp, Amt)).

% Implicitly assume decreases past 0 and increases past max saturate.
% Could reify those as preconditions but don't need to right now.

a_op_g3(L, alter_resource(P, IncDec, Amt)) :-
  resource_logic_g3(L),
  resource_pool_g3(L, P),
  resource_amount_g3(L, Amt),
  resource_change_direction_g3(IncDec),
  Amt != r(0),
  P != Amt.

% but this one requires that P1 has at least Amt
% a_op_g3(L, move_resource(P1, P2, Amt)) :-
  % resource_logic_g3(L),
  % resource_pool_g3(L, P1),
  % resource_pool_g3(L, P2),
  % resource_amount_g3(L, Amt),
  % Amt != r(0).

% prerequisite_g3(L, move_resource(P1, P2, Amt), L, has_resource(P1, ge, Amt)) :-
  % resource_logic_g3(L),
  % resource_pool_g3(L, P1),
  % resource_pool_g3(L, P2),
  % resource_amount_g3(L, Amt),
  % Amt != inf.
