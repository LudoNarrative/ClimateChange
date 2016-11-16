

{reading(help,relation(Entity1,Entity2))} :-
    precondition(overlaps(Entity1,Entity2,true),Outcome),
    result(Outcome,modify(increase,property(Entity2,health))).

{reading(help,relation(Entity1,Entity2))} :-
    precondition(overlaps(Entity2,Entity1,true),Outcome),
    result(Outcome,modify(increase,property(Entity2,health))).


{reading(hurt,relation(Entity1,Entity2))} :-
    precondition(overlaps(Entity1,Entity2,true),Outcome),
    result(Outcome,modify(decrease,property(Entity2,health))).


{reading(hurt,relation(Entity1,Entity2))} :-
    precondition(overlaps(Entity1,Entity2,true),Outcome),
    result(Outcome,delete(Entity2)).

{reading(hurt,relation(Entity1,Entity2))} :-
    precondition(overlaps(Entity2,Entity1,true),Outcome),
    result(Outcome,modify(decrease,property(Entity2,health))).


{reading(hurt,relation(Entity1,Entity2))} :-
    precondition(overlaps(Entity2,Entity1,true),Outcome),
    result(Outcome,delete(Entity2)).

{reading(produces,relation(Entity1,Entity2))} :-
    action(add(Entity2,Entity1)).

    
{reading(consumes,relation(Entity1,Entity2))} :-
    precondition(overlaps(Entity2,Entity1,true),Outcome),
    result(Outcome,delete(Entity2)).
    
{reading(chases,relation(Entity1,Entity2))} :-
    action(move(Entity1,direction(towards,Entity2))).

{reading(flees,relation(Entity1,Entity2))} :-
    action(move(Entity1,direction(away,Entity2))).

{reading(consumes,relation(Entity1,Resource1))} :-
    precondition(overlaps(Entity1,Entity2,true),Outcome),
    result(Outcome,modify(decrease,Resource1)).

{reading(consumes,relation(Entity1,Resource1))} :-
    precondition(overlaps(Entity2,Entity1,true),Outcome),
    result(Outcome,modify(decrease,Resource1)).

{reading(produces,relation(Entity1,Resource1))} :-
    precondition(overlaps(Entity1,Entity2,true),Outcome),
    result(Outcome,modify(increase,Resource1)).

{reading(produces,relation(Entity1,Resource1))} :-
    precondition(overlaps(Entity2,Entity1,true),Outcome),
    result(Outcome,modify(increase,Resource1)).

{reading(consts,relation(Entity1,Resource1))} :-
    result(Outcome,add(Entity1)),
    result(Outcome,modify(decrease,Resource1)).

{reading(costs,relation(Entity1,Resource1))} :-
    result(Outcome,add(Entity1)),
    result(Outcome,modify(decrease,Resource1)).

{reading(goal(Action),Thing)} :-
    goal(Action,Thing).

{reading(goal(produce),Resource)} :-
    precondition(compare(le,Resource),Outcome),
    result(Outcome,mode_change(game_loss;narrative_gating)).

{reading(goal(produce),Resource)} :-
    precondition(compare(ge,Resource),Outcome),
    result(Outcome,mode_change(game_win;narrative_progress)).

    
{reading(goal(reduce),Resource)} :-
    precondition(compare(ge,Resource),Outcome),
    result(Outcome,mode_change(game_loss;narrative_gating)).
    
{reading(goal(reduce),Resource)} :-
    precondition(compare(le,Resource),Outcome),
    result(Outcome,mode_change(game_win;narrative_progress)).

{reading(sharing,relation(Entity,Entity1))} :-     
    reading(consumes,relation(Entity1,Entity)),
    many(Entity1),
    precondition(overlaps(Entity,Entity1,true),Outcome),
    result(Outcome,delete(Entity)),
    result(Outcome,modify(increase,Resource)),
    reading(good,Resource).
    
{reading(sharing,relation(Entity,Entity1))} :-     
    reading(consumes,relation(Entity1,Entity)),
    many(Entity1),
    precondition(overlaps(Entity1,Entity,true),Outcome),
    result(Outcome,delete(Entity)),
    result(Outcome,modify(increase,Resource)),
    reading(good,Resource).
    
{reading(good,Resource)} :-
    reading(goal(produce),Resource).
{reading(bad,Resource)} :-
    reading(goal(reduce),Resource).
    
%%%% HELPERS 

change(game_win,positive).
change(narrative_progress,positive).
change(game_loss,negative).
change(narrative_gating,positive).

over_time(Outcome) :-
    precondition(tick,Outcome).
over_time(Outcome) :-
    precondition(timerElapsed(T),Outcome).

over_time(Change,Resource) :-
    over_time(Outcome),
    result(Outcome,modify(Change,Resource)).

monotonic(Change,Resource) :-
    action(modify(Change,Resource)),
    1 {action(modify(Change,Resource))}.
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

:- resource(R),
   not reading_about(R).
:- entity(E),
   not reading_about(E).
