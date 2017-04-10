




player_model(tick,must_happen).

player_model(Outcome ,player_will_attempt) :- player_controls_outcome(Outcome), reading(good,Outcome), not reading(tradeoff,Outcome).


player_model(Outcome ,player_might_attempt) :- player_controls_outcome(Outcome),  reading(tradeoff,Outcome).

player_model(Outcome ,player_will_avoid) :- player_controls_outcome(Outcome),  reading(bad,Outcome).


player_model(Outcome, undetermined) :- outcome(Outcome), not player_model(Outcome ,player_will_attempt),
				       not player_model(Outcome ,must_happen),
				       not player_model(Outcome,player_will_avoid).

:- outcome(Outcome), not player_model(Outcome,_).
