
%% OLs:
% - Resource logic
% - Production at a rate over time
% - Spending to unlock producers
% - Spending to upgrade production rates
% - Button interface

resource(cookies).
resource(click_rate).
resource(cps).

entity(producer).
multiple(producer).

resource(producer, production_rate).
resource(producer, cost).

entity(giant_cookie).
singular(giant_cookie).

entity(buy_button(P))
  :- producer(P).

%% Mechanics:
% - Clicking cookie increases cookies.
precondition(control_event(click(giant_cookie)), click_cookie).
result(click_cookie, increase(cookies, click_rate)).

% - Time causes cookies to increase by cps.
precondition(tick, produce).
result(produce, increase(cookies, cps)).

% - Buying a producer increases cps by that producer's production rate
%   and subtracts cost from number of cookies.
precondition(ge(cookies, C), buy_producer(P))
  :- cost(P, C).

precondition(control_event(click(buy_button(P))), buy_producer(P))
  :- producer(P).

result(buy_producer(P), increase(cps, R))
  :- production_rate(P, R).

result(buy_producer(P), decrease(cookies, C))
  :- cost(P, C).

good(cookies).

% ?? initialize(click_rate, 1).
% initialize(producer, grandma).
% initialize(cost(grandma), low).
% initialize(production_rate(grandma), low).
% 
% initialize(producer, farm).
% initialize(cost(farm), high).
% initialize(production_rate(farm), high).

producer(farm).
producer(grandma).
cost(farm, high).
production_rate(farm, high).
cost(grandma, low).
production_rate(grandma, low).


