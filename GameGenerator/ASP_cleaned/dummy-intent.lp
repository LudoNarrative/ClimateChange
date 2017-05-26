#const min_entities = 1.
#const max_entities = 3.
#const min_resources = 1.
#const max_resources = 2.
#const min_outcomes = 2.
#const max_outcomes = 10.
#const min_timers = 1.
#const max_timers = 2.

#const min_end_outcomes = 1.
#const max_end_outcomes = 1.
#const max_resource_change_per = 2.
#const max_conditions_per = 2.


required(hand_eye_coordination).
:- not reading(hand_eye_coordination,game).

:- not result(_,move(E1,direction(towards,E2))),
   computer_controls(E1),
   entity(E1),
   entity(E2).
