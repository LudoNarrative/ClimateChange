%%% INTERPRETATIONS - 

interpretation(Entity1,spawns(Entity2)) :-
    result(O,add(Entity2,Entity1)),
    entity(Entity1).

interpretation(Entity1,shoots(Entity2)) :-
    result(O,add(Entity2,Entity1)),
    result(tick,moves(forward(Entity2))).

interpretation(Entity1, harms(Entity2)) :-
    precondition(overlaps(Entity1,Entity2,true),O),
    result(O,decrease(health(Entity2))).

interpretation(Entity1, harms(Entity2)) :-
    precondition(overlaps(Entity2,Entity1,true),O),
    result(O,decrease(health(Entity2))).

interpretation(Entity1, harms(Entity2)) :-
    interpretation(Entity1,shoots(Entity3)),
    interpretation(Entity2,harms(Entity3)).

interpretation(Entity1, harms(Entity2)) :-
    good(Resource),
    precondition(overlaps(Entity1,Entity2,true),O),
    result(O,decrease(Resource)),
    playerAgency(Entity2).

interpretation(Entity1, harms(Entity2)) :-
    good(Resource),
    precondition(overlaps(Entity2,Entity1,true),O),
    result(O,decrease(Resource)),
    playerAgency(Entity2).


interpretation(Entity1, helps(Entity2)) :-
    precondition(overlaps(Entity1,Entity2,true),O),
    result(O,decrease(health(Entity1))).
interpretation(Entity1, helps(Entity2)) :-
    precondition(overlaps(Entity2,Entity1,true),O),
    result(O,decrease(health(Entity1))).

interpretation(Entity1, helps(Entity2)) :-
    interpretation(Entity1,shoots(Entity3)),
    interpretation(Entity2,helps(Entity3)).

interpretation(Entity1, helps(Entity2)) :-
    good(Resource),
    precondition(overlaps(Entity1,Entity2,true),O),
    result(O,increase(Resource)),
    playerAgency(Entity2).

interpretation(Entity1, helps(Entity2)) :-
    good(Resource),
    precondition(overlaps(Entity2,Entity1,true),O),
    result(O,increase(Resource)),
    playerAgency(Entity2).

interpretation(Entity,consumes(Entity1)) :-
    precondition(overlaps(Entity,Entity1,true),O),
    result(O,delete(Entity1)).
interpretation(Entity,consumes(Entity1)) :-
    precondition(overlaps(Entity1,Entity,true),O),
    result(O,delete(Entity1)).

interpretation(Entity,consumes(Resource)) :-
    precondition(overlaps(Entity,Entity1,true),O),
    result(O,decrease(Resource)).

interpretation(Entity,consumes(Resource)) :-
    precondition(overlaps(Entity1,Entity,true),O),
    result(O,decrease(Resource)).


interpretation(Entity,creates(Resource)) :-
    precondition(overlaps(Entity,Entity1,true),O),
    result(O,increase(Resource)).

interpretation(Entity,creates(Resource)) :-
    precondition(overlaps(Entity1,Entity,true),O),
    result(O,increase(Resource)).


interpretation(Entity,autonomous) :-
    not playerAgency(Entity),
    entity(Entity).

interpretation(Entity,player_controlled) :-
    playerAgency(Entity).

interpretation(Entity1,enemy) :-
    interpretation(Entity1, harms(Entity2)),
    playerAgency(Entity2),
    not playerAgency(Entity1).

interpretation(Entity,enemy) :-
    interpretation(Entity,consumes(Resource)),
    not playerAgency(Entity),
    good(Resource).
    
interpretation(Entity1,helper) :-
    interpretation(Entity1, helps(Entity2)),
    playerAgency(Entity2).

interpretation(Entity,static) :-
    static(Entity).

interpetation(Entity,rhythmic) :-
    precondition(timerElapsed(Timer),Outcome),
    1 {result(Outcome,moves(Entity,Direction));
       result(Outcome,move_towards(Entity,Other));
       result(Outcome,move_away(Entity,Other));
       result(Outcome,rotates(Entity,Direction));
       result(Outcome,rotate_to(Entity,Direction));
       result(Outcome,set(target(ENTITY),Something))},
    entity(Entity).

