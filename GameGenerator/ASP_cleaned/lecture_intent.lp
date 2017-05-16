#const min_entities = 2.
#const max_entities = 2.
#const min_resources = 1.
#const max_resources = 2.
#const min_outcomes = 2.
#const max_outcomes = 6.
#const min_timers = 0.
#const max_timers = 2.

#const min_end_outcomes = 1.
#const max_end_outcomes = 1.
#const max_resource_change_per = 2.
#const max_conditions_per = 2.

required(maintenance).
required(hand_eye_coordination).

label(resource(r(1)),concentration).
label(entity(e(1)),e1).
label(entity(e(2)),e2).
label(entity(e(3)),e3).
:- not reading(hand_eye_coordination,game).
:- not reading(maintenance,resource(r(1))).
:- not action(mode_change(game_loss)).
:- 2 {action(mode_change(N))}.

:- not computer_controls(_).
:- 0 {behavior(_,_)} 0.


%% :- player_model(Outcome ,player_will_attempt),
%%    precondition(overlaps(E1,E1,_),Outcome),
%%    2 {precondition(_,Outcome)} 2.

%% :- player_model(Outcome ,player_will_attempt),
%%    precondition(overlaps(E1,E2,_),Outcome),
%%    3 {precondition(_,Outcome)} 3.
