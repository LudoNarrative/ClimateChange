reading(survive,Entity) :-
    entity(Entity),
    1 {reading(defend_against,Entity);
       reading(dodge,Entity) }.
	   
	   
{reading(defend_against,Entity)} :-
    reading(hurt,relation(Entity,player)),
    result(Outcome,delete(Entity)),
    player_controls_outcome(Outcome).

required(hurt) :- required(defend).
{reading(dodge,Entity)} :-
    reading(hurt,relation(Entity,player)),
    precondition(overlaps(Entity),Outcome),
    precondition(overlaps(Entity2),Outcome),
    reading(bad,Outcome),
    player_controls(Entity2).

required(hurt) :- required(dodge).

%%%%%%%%%%%%
{reading(hurt,relation(Entity1,player)) } :-
    precondition(overlaps(Entity1),Outcome),
    reading(bad,Outcome),
    not reading(good ,Outcome),
    computer_controls(Entity1).

reading(help,relation(Entity,player))  :-
    precondition(overlaps(Entity),Outcome),
    reading(good,Outcome),
    not reading(bad,Outcome),
    computer_controls(Entity).
required(good) :- required(help).
required(bad) :- required(hurt).


{reading(help,relation(Entity1,player)) } :-
    reading(help,relation(Entity1,Entity2)),
    player_controls(Entity2).

{reading(help,relation(Entity2,player)) } :-
    reading(help,relation(Entity1,Entity2)),
    player_controls(Entity1).


{reading(hurt,relation(Entity1,player)) } :-
    reading(hurt,relation(Entity1,Entity2)),
    player_controls(Entity2).

{reading(hurt,relation(Entity2,player)) } :-
    reading(hurt,relation(Entity1,Entity2)),
    player_controls(Entity1).


%% HELPING ANOTHER ENTITY
{reading(help,relation(Entity1,Entity2)) } :-
    precondition(overlaps(Entity1,Entity2,true),Outcome),
    result(Outcome,modify(increase,property(Entity2,health))).

{reading(help,relation(Entity1,Entity2)) } :-
    precondition(overlaps(Entity2,Entity1,true),Outcome),
    result(Outcome,modify(increase,property(Entity2,health))).


{reading(hurt,relation(Entity1,Entity2)) } :-
    precondition(overlaps(Entity1,Entity2,true),Outcome),
    result(Outcome,modify(decrease,property(Entity2,health))).



{reading(hurt,relation(Entity1,Entity2)) } :-
    precondition(overlaps(Entity1,Entity2,true),Outcome),
    result(Outcome,delete(Entity2)).

{reading(hurt,relation(Entity1,Entity2)) } :-
    precondition(overlaps(Entity2,Entity1,true),Outcome),
    result(Outcome,modify(decrease,property(Entity2,health))).


{reading(hurt,relation(Entity1,Entity2)) } :-
    precondition(overlaps(Entity2,Entity1,true),Outcome),
    result(Outcome,delete(Entity2)).

{reading(produces,relation(Entity1,Entity2)) } :-
    action(add(Entity2,_,Entity1)).

    
{reading(consumes,relation(Entity1,Entity2)) } :-
    precondition(overlaps(Entity2,Entity1,true),Outcome),
    result(Outcome,delete(Entity2)).

{reading(consumes,relation(Entity1,Entity2)) } :-
    precondition(overlaps(Entity2,Entity1,true),Outcome),
    result(Outcome,modify(decrease,property(Entity2,health))).
{reading(consumes,relation(Entity1,Entity2)) } :-
    precondition(overlaps(Entity1,Entity2,true),Outcome),
    result(Outcome,modify(decrease,property(Entity2,health))).
    
reading(chases,relation(Entity1,Entity2)) :-
    action(move(Entity1,direction(towards,Entity2))).
reading(chases,relation(Entity1,Entity2)) :-
    action(move(Entity1,direction(forward))),
    action(look_at(Entity1,Entity2)).
    
    
reading(flees,relation(Entity1,Entity2)) :-
    action(move(Entity1,direction(away,Entity2))).

reading(flees,relation(Entity1,Entity2)) :-
    action(move(Entity1,direction(backward))),
    action(look_at(Entity1,Entity2)).
    
{reading(consumes,relation(Entity1,Resource1)) } :-
    precondition(overlaps(Entity1,Entity2,true),Outcome),
    result(Outcome,modify(decrease,Resource1)).

{reading(consumes,relation(Entity1,Resource1)) } :-
    precondition(overlaps(Entity2,Entity1,true),Outcome),
    result(Outcome,modify(decrease,Resource1)).

{reading(produces,relation(Entity1,Resource1)) } :-
    precondition(overlaps(Entity1,Entity2,true),Outcome),
    result(Outcome,modify(increase,Resource1)).

{reading(produces,relation(Entity1,Resource1)) } :-
    precondition(overlaps(Entity2,Entity1,true),Outcome),
    result(Outcome,modify(increase,Resource1)).

{reading(consts,relation(Entity1,Resource1)) } :-
    result(Outcome,add(Entity1,_,_)),
    result(Outcome,modify(decrease,Resource1)).

{reading(costs,relation(Entity1,Resource1)) } :-
    result(Outcome,add(Entity1,_,_)),
    result(Outcome,modify(decrease,Resource1)).

{reading(hand_eye_coordination,game )} :-
    reading(good,Outcome),
    hand_eye_coordination(Outcome).
    

{reading(goal(Action),Thing) } :-
    goal(Action,Thing).

{reading(goal(produce),Resource) } :-
    precondition(compare(le,Resource),Outcome),
    result(Outcome,mode_change(game_loss;narrative_gating)).

{reading(goal(produce),Resource) } :-
    precondition(compare(ge,Resource),Outcome),
    result(Outcome,mode_change(game_win;narrative_progress)).


    
{reading(goal(reduce),Resource) } :-
    precondition(compare(ge,Resource),Outcome),
    result(Outcome,mode_change(game_loss;narrative_gating)).
    
{reading(goal(reduce),Resource) } :-
    precondition(compare(le,Resource),Outcome),
    result(Outcome,mode_change(game_win;narrative_progress)).

{reading(sharing,relation(Entity,Entity1)) }  :-    
    reading(consumes,relation(Entity1,Entity)),
    many(Entity1),
    reading(good,Resource).


required(good) :- required(sharing).
required(consumes) :- required(sharing).


{reading(sharing,relation(Entity,Entity1)) } :-     
    reading(consumes,relation(Entity1,Entity)),
    many(Entity1),
    precondition(overlaps(Entity1,Entity,true),Outcome),
    result(Outcome,delete(Entity)),
    result(Outcome,modify(increase,Resource)),
    reading(good,Resource).
    
{reading(good,Resource) } :-
    reading(goal(produce),Resource).

required(goal(produce)) :- required(good).

{reading(bad,Resource) } :-
    reading(goal(reduce),Resource).
{reading(good,property(Player,health)) } :-
    player_controls(Player),
    action(modify(_,property(Player,health))).

required(goal(reduce)) :- required(bad).

{reading(good,Entity)} :-
    reading(good,Resource),
    reading(produces,relation(Entity,Resource)).

{reading(good,Entity)} :-
    reading(bad,Resource),
    reading(consumes,relation(Entity,Resource)).

{reading(bad,Entity)} :-
    reading(good,Resource),
    reading(consumes,relation(Entity,Resource)).

{reading(bad,Entity)} :-
    reading(bad,Resource),
    reading(produces,relation(Entity,Resource)).


%%Good / Bad Outcome

reading(good,Outcome) :-
    result(Outcome,modify(increase,Resource)),
    reading(good,Resource).

reading(bad,Outcome) :-
    result(Outcome,modify(decrease,Resource)),
    reading(good,Resource).


reading(bad,Outcome) :-
    result(Outcome,modify(increase,Resource)),
    reading(bad,Resource).

reading(good,Outcome) :-
    result(Outcome,modify(decrease,Resource)),
    reading(bad,Resource).




reading(good,Outcome) :-
    result(Outcome,delete(Entity)),
    reading(bad,Entity).

reading(good,Outcome) :-
    result(Outcome,add(Entity,_,_)),
    reading(good,Entity).

reading(bad,Outcome) :-
    result(Outcome,delete(Entity)),
    reading(good,Entity).

reading(bad,Outcome) :-
    result(Outcome,add(Entity,_,_)),
    reading(bad,Entity).




reading(tradeoff,Outcome) :-
    reading(good,Outcome),
    reading(bad,Outcome).



{reading(maintenance,Resource) } :-
    reading(good,Resource),
    player_controls_outcome(Outcome),
    result(Outcome,modify(increase,Resource)),
    result(OverTime,modify(decrease,Resource)),
    over_time(OverTime).


required(produces) :- required(maintenance).
required(good) :- required(maintenance).

{reading(maintenance,Resource) } :-
    reading(bad,Resource),
    player_controls_outcome(Outcome),
    result(Outcome,modify(decrease,Resource)),
    result(OverTime,modify(increase,Resource)),
    over_time(OverTime).

required(bad) :- required(maintenance).


{reading(stakes(high),Resource) } :-
    precondition(compare(ge,Resource),Outcome),
    result(Outcome,mode_change(game_loss)).
    
{reading(stakes(high),Resource) } :-
    precondition(compare(le,Resource),Outcome),
    result(Outcome,mode_change(game_win)).

{reading(stakes(high),property(Entity,health)) } :-
    entity(Entity),
    action(modify(decrease,property(Entity,health))).

{reading(stakes(low),Resource) } :-
    resource(Resource),
    not reading(stakes(high),Resource).


required(stakes(high)) :- required(stakes(low)).

%Grinding is a valid reading iff monotonic, player controls the modification
{reading(grinding,Resource) } :-
    monotonic(Resource),
    player_controls_outcome(Outcome),
    result(Outcome,modify(_,Resource)),
    not reading(risk,Outcome).

required(risk) :- required(grinding).

%Organization

{reading(organization) } :-
    precondition(overlaps(Entity,Entity2,true),Outcome),
    outcome_enables(Outcome,EndOutcome),
    result(EndOutcome,mode_change(game_win;narrative_progress)).

%an outcome has risk, if a similar outcome is bad
{reading(risk, Outcome) } :-
    precondition(Cond,Outcome),
    precondition(Cond,BadOutcome),
    reading(outcome_hurts,relation(BadOutcome,_)).

required(outcome_hurts) :- required(risk).

{reading(outcome_helps,relation(Outcome,Resource)) } :-
    result(Outcome,modify(increase,Resource)),
    player_controls_outcome(Outcome),
    reading(good,Resource).
{reading(outcome_helps,relation(Outcome,Resource)) } :-
    result(Outcome,modify(decrease,Resource)),
    player_controls_outcome(Outcome),
    reading(bad,Resource).


required(good) :- required(outcome_helps).
required(bad) :- required(outcome_helps).

{reading(outcome_hurts,relation(Outcome,Resource)) } :-
    result(Outcome,modify(decrease,Resource)),
    player_controls_outcome(Outcome),
    reading(good,Resource).
{reading(outcome_hurts,relation(Outcome,Resource)) } :-
    result(Outcome,modify(increase,Resource)),
    player_controls_outcome(Outcome),
    reading(bad,Resource).

required(good) :- required(outcome_hurts).
required(bad) :- required(outcome_hurts).

%HELPERS 

change(game_win,positive).
change(narrative_progress,positive).
change(game_loss,negative).
change(narrative_gating,positive).

over_time(Outcome) :-
    precondition(tick,Outcome).
over_time(Outcome) :-
    precondition(timer_elapsed(T),Outcome).

over_time(Change,Resource) :-
    over_time(Outcome),
    result(Outcome,modify(Change,Resource)).

monotonic(Change,Resource) :-
    action(modify(Change,Resource)),
    1 {action(modify(C,Resource))} 1.
monotonic(Resource) :-
    monotonic(_,Resource).

nonmonotonic(Resource) :-
    resource(Resource),
    not monotonic(Resource).


reading_about(Thing) :-
    reading(Action,Thing).
reading_about(Thing) :-
    reading(Action,relation(Thing,_)).
reading_about(Thing) :-
    reading(Action,relation(_,Thing)).



outcome_creates_condition(Outcome,compare(le,Resource)) :-
    result(Outcome,modify(decrease,Resource)),
    condition(compare(le,Resource)).

outcome_creates_condition(Outcome,compare(ge,Resource)) :-
    result(Outcome,modify(increase,Resource)),
    condition(compare(ge,Resource)).

outcome_creates_condition(Outcome,overlaps(Entity)) :-
    result(Outcome,move(Entity,direction(_,_))),
    condition(overlaps(Entity)).

outcome_enables(Outcome,Other) :-
    outcome_creates_condition(Outcome,Cond),
    precondition(Cond,Other).


outcome_enables(O1,O3) :-
    outcome_enables(O1,O2),
    outcome_enables(O2,O3).


