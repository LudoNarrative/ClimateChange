#const min_entities = 1.
#const max_entities = 2.
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

#project reading/2.
#show reading/2.


required(tradeoff).


required(good).
required(bad).

required(maintenance).


required(produces).
required(good).
required(stakes(high)).
required(stakes(low)).
    
required(grinding).

required(risk).
required(organization).
required(outcome_hurts).

required(survive).
	   
	   
required(defend_against).
required(dodge).

required(hurt).


required(difficulty) .



required(help).
required(hurt).

    
    
required(chases).
    
    
required(flees).
    

required(consumes).


required(produces).

required(costs).

required(hand_eye_coordination).
    


required(good).
required(consumes).


required(sharing).
    
required(goal(produce)).


required(goal(reduce)).
