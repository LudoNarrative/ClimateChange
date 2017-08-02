#const min_entities = 1.
#const max_entities = 3.
#const min_resources = 3.
#const max_resources = 3.
#const min_outcomes = 2.
#const max_outcomes = 6.
#const min_timers = 0.
#const max_timers = 2.

#const min_end_outcomes = 0.
#const max_end_outcomes = 0.
#const max_resource_change_per = 2.
#const max_conditions_per = 2.


label(resource(r(1)),money,write) .
label(resource(r(2)),co2,write) .
label(resource(r(3)),fame,write) .

required(tradeoff).

reading(good,resource(r(1))).  %We set it here since the game doesn't actually respond to them
reading(bad,resource(r(2))).
reading(good,resource(r(3))).

:- not reading(tradeoff,relation(resource(r(1)), resource(r(2)))).
:- not reading(tradeoff,relation(resource(r(2)), resource(r(3)))).
:- not reading(tradeoff,relation(resource(r(1)), resource(r(3)))).


allowed(monotonic(resource(r(1)))).

allowed(monotonic(resource(r(2)))).

allowed(monotonic(resource(r(3)))).

:- action(modify(increase,resource(r(1)))).


:- action(mode_change(_)).