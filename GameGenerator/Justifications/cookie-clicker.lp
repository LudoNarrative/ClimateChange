
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

entity(producer_sprite(P))
  :- producer(P).
multiple(producer_sprite(P))
  :- producer(P).
  
spawnLogic(producer_sprite(P),field(uniform),spawn,one_shot)
  :- producer(P).

resource(producer, production_rate).
resource(producer, cost).

entity(giant_cookie).
singular(giant_cookie).

entity(buy_button(P))
  :- producer(P).

singular(buy_button(P))
  :- producer(P).

initialize(set_sprite(buy_button(P),button)) 
    :- producer(P).
initialize(set_text(buy_button(P),concat(buy_,concat(P,concat(for_,concat(cost)))))) 
    :- producer(P).

initialize(set_sprite(producer_sprite(P),C)) 
    :- producer(P),sprite_mapping(P,C).    
 
initialize(set_sprite(giant_cookie,cookie)).
initialize(set_scale(giant_cookie,very_large)).



%% Mechanics:
% - Clicking cookie increases cookies.
precondition(control_event(click(giant_cookie)), click_cookie).
result(click_cookie, increase(cookies, click_rate)).

% - Time causes cookies to increase by cps.
precondition(tick, produce).
result(produce, increase(cookies, cps)).

% - Buying a producer increases cps by that producer's production rate
%   and subtracts cost from number of cookies.
precondition(ge(cookies, cost), buy_producer(P))
  :- cost(P, C).

precondition(control_event(click(buy_button(P))), buy_producer(P))
  :- producer(P).

result(buy_producer(P), add(S))
  :- sprite_mapping(P, S).
result(buy_producer(P), increase(cps, R))
  :- production_rate(P, R).
result(buy_producer(P), increase(cost, cost))
  :- production_rate(P, R).


result(buy_producer(P), decrease(cookies, cost))
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
sprite_mapping(grandma,grandma).
sprite_mapping(farm,farm).


