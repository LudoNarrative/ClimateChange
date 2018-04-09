

required(good).
required(bad).
required(tradeoff).

player_model(tick,must_happen).
player_model(Outcome,must_happen) :- not precondition(overlaps(_,_,_),Outcome),
				     not precondition(control_event(_),Outcome),
				     outcome(Outcome).

priority(must_happen,player_must_do).
priority(player_must_do,player_will_attempt).
priority(player_will_attempt,player_will_avoid).
priority(player_might_attempt,player_will_avoid).
priority(player_will_avoid,undetermined).
priority(A,C) :- priority(A,B), priority(B,C).




player_model(Outcome ,player_will_attempt) :- player_controls_outcome(Outcome),
					      reading(good,Outcome),
					      not reading(tradeoff,Outcome),
					      not invalidated(Outcome,player_will_attempt).

invalidated(Outcome,P) :-  player_model(Outcome,Other),
			   priority(Other,P).

player_model(Outcome,player_must_do) :- result(Outcome, move(Entity,_,_)),
					     player_controls(Entity),
					      not invalidated(Outcome,player_must_do).

player_model(Outcome,player_must_do) :- result(Outcome, rotates(Entity,_)),
					     player_controls(Entity),
					     not invalidated(Outcome,player_must_do).

player_model(Outcome,player_must_do) :- result(Outcome, look_at(Entity,_,_)),
					     player_controls(Entity),
					     not invalidated(Outcome,player_must_do).

player_model(Outcome ,player_might_attempt) :- player_controls_outcome(Outcome),
					       reading(tradeoff,Outcome),
					       not invalidated(Outcome,player_might_attempt).

player_model(Outcome ,player_will_avoid) :- player_controls_outcome(Outcome),
					    reading(bad,Outcome),
					    not invalidated(Outcome,player_will_avoid).


player_model(Outcome, undetermined) :- outcome(Outcome),
				       not invalidated(Outcome,undetermined).
