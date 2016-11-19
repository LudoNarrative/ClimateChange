#const max_timesteps = 3.
timestep(0..max_timesteps).

parameter_values(1;5;10).

comparison_values(0).
comparison_values(N) :- parameter_values(N).


requires_parameter_tuning(precondition(compare(C,R),O)) :-
    precondition(compare(C,R),O).
requires_parameter_tuning(result(O,modify(D,R))) :-
    result(O,modify(D,R)).

requires_structure_tuning(result(O,add(E))) :- 
    result(O,add(E)).

requires_tuning(T) :- requires_parameter_tuning(T).
requires_tuning(T) :- requires_structure_tuning(T).
    
    
    

    
actual(precondition(C,O)) :- precondition(C,O), not requires_tuning(precondition(C,O)).
actual(result(C,O)) :- result(C,O), not requires_tuning(result(C,O)).
    
1 {actual(precondition(compare(C,R,V),O)) : comparison_values(V)} 1 :- 
    precondition(compare(C,R),O).
1 {actual(result(O,modify(D,R,V))) : parameter_values(V)} 1 :- 
    result(O,modify(D,R)).
    
    
1 {initialize(set(R,V)) : parameter_values(V)} 1 :- 
    resource(R).

at(R,V,0) :- initialize(set(R,V)).

actual(condition(C)) :- actual(precondition(C,_)).


condition_occurs_at(compare(ge,R,V),T) :-  actual(condition(compare(ge,R,V))),
                             at(R,V2,T),
                             V2 >= V.
          
condition_occurs_at(compare(le,R,V),T) :-  actual(condition(compare(le,R,V))),
                             at(R,V2,T),
                             V2 <= V. 


condition_doesnt_occur_at(compare(ge,R,V),T) :-  actual(condition(compare(ge,R,V))),
                             at(R,V2,T),
                             V2 > V.
          
condition_doesnt_occur_at(compare(le,R,V),T) :-  actual(condition(compare(le,R,V))),
                             at(R,V2,T),
                             V2 > V.                               
condition_occurs_at(tick,T) :- timestep(T).


{ condition_occurs_at(C,T)  }:- condition(C),
                               actual(condition(C)),
                               timestep(T).

condition_doesnt_occur_at(C,T) :- actual(condition(C)),
                                  not condition_can_occur_at(C,T),
                                  not condition_occurs_at(C,T),
                                  timestep(T).
                               
                               
outcome_doesnt_occur_at(O,T) :- actual(precondition(C,O)), 
                                condition_doesnt_occur_at(C,T).
outcome_can_occur_at(O,T) :- not outcome_doesnt_occur_at(O,T), 
                                condition_can_occur_at(O,T).
outcome_occurs_at(O,T) :- not outcome_doesnt_occur_at(O,T), 
                            not outcome_can_occur_at(O,T), 
                            condition_occurs_at(C,T), 
                            actual(precondition(C,O)).
result_occurs_at(result(O,A),T) :- actual(result(O,A)), outcome_occurs_at(O,T).


at(R,V+Old,T+1) :- V = #sum{ Increase    : result_occurs_at(result(O,modify(increase,R,Increase)),T);
                             -Decrease   : result_occurs_at(result(O,modify(decrease,R,Decrease)),T)},
                         at(R,Old,T),
                         timestep(T).
