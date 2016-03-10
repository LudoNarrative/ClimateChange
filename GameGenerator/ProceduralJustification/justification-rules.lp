
%%%%%%%%%%%%%%%

coupled_game_mechanic(Game,Mechanic,X,Y) :- 
    has_mechanic(Game,Mechanic), 
    increases(Game,Mechanic,X,Value_X),  
    increases(Game,Mechanic,Y,Value_Y).

not_coupled(X,Y) :- 
  not coupled_game_mechanic(Game,Mechanic,X,Y), 
  has_mechanic(Game,Mechanic), 
  has_value(Game,X), 
  has_value(Game,Y).

coupled(X,Y) :- not not_coupled(X,Y), has_value(Game,X), has_value(Game,Y), X != Y.


%%%%%%%%%%%%%%%

tradeoff_game_mechanic(Game,Mechanic,X,Y) :- 
    has_mechanic(Game,Mechanic), increases(Game,Mechanic,X,Value_X),  decreases(Game,Mechanic,Y,Value_Y).

tradeoff_game_mechanic(Game,Mechanic,X,Y) :- 
    has_mechanic(Game,Mechanic), decreases(Game,Mechanic,X,Value_X),  increases(Game,Mechanic,Y,Value_Y).
    
not_tradeoff(X,Y) :- not tradeoff_game_mechanic(Game,Mechanic,X,Y), has_mechanic(Game,Mechanic), has_value(Game,X), has_value(Game,Y).


tradeoff(X,Y) :- not not_tradeoff(X,Y), has_value(Game,X), has_value(Game,Y), X != Y.



%%%%%%%%%%%%%%%


allocationOfLimitedResource(Resource) :- 
    decreases(Game,Mechanic,Resource,Value), chooses(Game,Mechanic,Thing,multiple), precondition(thresh(gt,0,Resource),Mechanic).

allocationOfLimitedResource(Resource) :- 
    decreases(Game,Mechanic1,Resource,Value), 
    decreases(Game,Mechanic2,Resource,Value), precondition(thresh(gt,0,Resource),Mechanic1), precondition(thresh(gt,0,Resource),Mechanic2), Mechanic1 != Mechanic2.

%%%%%%%%%%%%%%%

monotonicIncrease(Meter) :- 
    increases(Game,Mechanic1,Meter,_), has_mechanic(Game,Mechanic2),
    not decreases(Game,Mechanic2,Meter,_).
    

monotonicDecrease(Meter) :- 
    decreases(Game,Mechanic1,Meter,_), has_mechanic(Game,Mechanic2),
    not increases(Game,Mechanic2,Meter,_).
    
monotonic(Meter) :- 
    monotonicDecrease(Meter).
monotonic(Meter) :- 
    monotonicIncrease(Meter).

progress(Meter) :-
    goal(Game,Mechanic,Meter).
    
high_stakes(Mechanic) :- 
    affects(Mechanic,Variable), narrative(Game,Variable), has_mechanic(Game,Mechanic).
low_stakes(Mechanic) :- 
    has_mechanic(Game,Mechanic), not high_stakes(Mechanic).
    
    
    
affects(Mechanic,Variable) :- 
    increases(Game,Mechanic,Variable,Val).

affects(Mechanic,Variable) :- 
    decreases(Game,Mechanic,Variable,Val).
    
affects(Mechanic,Variable) :- 
    affects(Mechanic,VariablePrime), gates(VariablePrime,MechanicPrime), affects(MechanicPrime,Variable).

gates(Variable,Mechanic) :- 
    precondition(thresh(_,_,Variable),Mechanic).    

time_constrained(Game) :- 
    affects(time,V), has_value(Game,V).
    
    
outlast_goal(Game) :-
    gates(Var,end_game), has_value(Game,Var).

maintenance(Variable) :- 
    decreases(Game,Mechanic1,Variable,_), system_controlled(Game,Mechanic1),
    increases(Game,Mechanic2,Variable,_), player_controlled(Game,Mechanic2).
    
    
maintenance(Variable) :- 
    increases(Game,Mechanic1,Variable,_), system_controlled(Game,Mechanic1),
    decreases(Game,Mechanic2,Variable,_), player_controlled(Game,Mechanic2).
