#const min_entities = 3.
#const max_entities = 3.
#const min_resources = 3.
#const max_resources = 3.
#const min_outcomes = 2.
#const max_outcomes = 6.
#const min_timers = 0.
#const max_timers = 2.

#const min_end_outcomes = 1.
#const max_end_outcomes = 1.
#const max_resource_change_per = 2.
#const max_conditions_per = 2.



required(tradeoff).

:- reading(bad,resource(r(1))).
:- reading(bad,resource(r(2))).
:- reading(good,resource(r(3))).
%% :- player_model(Outcome ,player_will_attempt),
%%    precondition(overlaps(E1,E1,_),Outcome),
%%    2 {precondition(_,Outcome)} 2.

%% :- player_model(Outcome ,player_will_attempt),
%%    precondition(overlaps(E1,E2,_),Outcome),
%%    3 {precondition(_,Outcome)} 3.
