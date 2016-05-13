
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

entity(buy_button).
each_has(producer, buy_button).

%% Mechanics:
% - Clicking cookie increases cookies.
precondition(control_event(click(giant_cookie)), click_cookie).
result(click_cookie, increase(cookies, click_rate)).

% - Time causes cookies to increase by cps.
precondition(tick, produce).
result(produce, increase(cookies, cps)).

% - Buying a producer increases cps by that producer's production rate
%   and subtracts cost from number of cookies.
precondition(ge(cookies, producer_cost), buy_producer).
precondition(control_event(click(buy_button)), buy_producer).
result(buy_producer, increase(cps, production_rate)).
result(buy_producer, decrease(cookies, producer_cost)).

good(cookies).

% ?? initialize(click_rate, 1).
