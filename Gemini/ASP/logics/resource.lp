logic(L) :- resource_logic(L).

resource_amount(L, s(0)).
resource_amount(L, inf).
resource_amount(L, P) :- resource_pool(L, P).

% For now pool capacities are fixed
{resource_pool_capacity(L, P, Amt) :
  resource_logic(L),
  resource_amount(L, Amt),
  (Amt = s(_) ; Amt = inf)} :-
  resource_pool(L, P).

:- resource_pool(L, _), not resource_logic(L).
:- resource_pool(L, P), not resource_pool_capacity(L, P, _).

% pools need initial contents
% "guess a default but admit overriding with explicit facts"
{init(L, has_resource(P, s(0)))} :-
  resource_logic(L),
  resource_pool(L, P).
:- resource_logic(L),
  resource_pool(L, P),
  not 1{init(L, has_resource(P, _))}1.

{state_feedback(L, resource_pool(P), LocOrGlob) :
  feedback_site(LocOrGlob),
  resource_logic(L),
  resource_pool(L, P)}.


% * Check if a transaction involving some units of certain resources is possible for some given locations.
% * Perform a resource transaction.
% * Perform an action of another logic when a transaction occurs.
% * Perform an action of another logic when the quantity of resources within a location crosses a threshold.

% ^--- we use a simplified resource logic where the only transactions increase or decrease the amount of a uniform resource in a single pool, or move resource from one pool to another

q_op(L, has_resource(P, Cmp, Amt)) :-
  resource_logic(L),
  resource_pool(L, P),
  resource_amount(L, Amt),
  comparator(Cmp).

{feedback(L, has_resource(P, Cmp, Amt), LocOrGlob) :
  resource_logic(L),
  feedback_site(LocOrGlob),
  q_op(L, has_resource(P, Cmp, Amt))}.

% Implicitly assume decreases past 0 and increases past max saturate.
% Could reify those as preconditions but don't need to right now.

a_op(L, alter_resource(P, IncDec, Amt)) :-
  resource_logic(L),
  resource_pool(L, P),
  resource_amount(L, Amt),
  resource_change_direction(IncDec),
  Amt /= s(0).

% but this one requires that P1 has at least Amt
a_op(L, move_resource(P1, P2, Amt)) :-
  resource_logic(L),
  resource_pool(L, P1),
  resource_pool(L, P2),
  resource_amount(L, Amt),
  Amt /= s(0).

prerequisite(L, move_resource(P1, P2, Amt), has_resource(P1, ge, Amt)) :-
  resource_logic(L),
  resource_pool(L, P1),
  resource_pool(L, P2),
  Amt /= inf.
