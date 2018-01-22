%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Proceduralist Reading Rules                     
% Primary Author: Adam Summerville                
% 
% Can either be combined with a Cygnus game spec to produce readings of it,
% or used during game generation (combined with a design intent), to 
% produce game(s) with a desired meaning.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% RELATIONS %%% 

%%% help, hurt, chases, flees, sharing, produces, consumes

%%%%%%

%% Entity-player relations

% TODO: Make all relation names the same tense 
% (Currently: help, hurt, chases, flees, sharing, produces, consumes)

% An entity can help the player
% (The player cannot help an entity the way help is currently defined)

% TODO: Less hacky predicate names for 'help' (help2 and help3 are never used)
% Maybe rename 'help' to 'help_player' to be more clear?

reading(help,relation(Entity,player))  :-
    precondition(overlaps(Entity),Outcome),
    reading(good,Outcome),
    not reading(bad,Outcome),
    computer_controls(Entity).

{ reading(help,relation(Entity1,player)) } :-
    reading(help,relation(Entity1,Entity2)),
    player_controls(Entity2).

% I dont think this rule makes sense. Delete?
%{ reading(help,relation(Entity2,player)) } :-
%    reading(help,relation(Entity1,Entity2)),
%    player_controls(Entity1).


% Enables more concise design intent writing: required(help)

help :- 
    precondition(overlaps(Entity),Outcome),
    reading(good,Outcome),
    not reading(bad,Outcome),
    computer_controls(Entity).

% Can the above rule be replaced with:
% help :- reading(help,relation(Entity,player)).

% help2 and help3 never used
% TODO: replace rule heads with 'help', so any of the three rules imply the 'help' fact? 

help2 :- 
    reading(help,relation(Entity1,Entity2)),
    player_controls(Entity2).

help3 :-
    reading(help,relation(Entity1,Entity2)),
    player_controls(Entity1).


% Helping the player is good, hurting the player is bad
% (But there isnt a 'hurt' in the head of a rule like 'help' is)
% Should have: hurt :- reading(hurt,relation(Entity,player)). ?

required(good) :- required(help).
required(bad) :- required(hurt).


% An entity can hurt the player
% (The player cannot hurt an entity the way hurt is currently defined)

{ reading(hurt,relation(Entity1,player)) } :-
    precondition(overlaps(Entity1),Outcome),
    reading(bad,Outcome),
    not reading(good,Outcome),
    computer_controls(Entity1).

{ reading(hurt,relation(Entity2,player)) } :-
    reading(hurt,relation(Entity2,Entity1)),
    player_controls(Entity1).

% I dont think this rule makes sense. Delete?
%{ reading(hurt,relation(Entity1,player)) } :-
%    reading(hurt,relation(Entity2,Entity1)),
%    player_controls(Entity2).

%%%%%%

%% Higher-level player-entity relations

% A player can be read as 'surviving' an entity if they have to 
% dodge and/or defend against it

reading(survive,Entity) :-
    entity(Entity),
    1 {reading(defend_against,Entity);
       reading(dodge,Entity) }.
       

% A player can be read as 'defending against' an entity
% if the entity hurts the player, and the player 
% controls an outcome which deletes the entity
       
{ reading(defend_against,Entity) } :-
    reading(hurt,relation(Entity,player)),
    result(Outcome,delete(Entity)),
    player_controls_outcome(Outcome).


% A player can be read as 'dodging' an entity
% if the entity hurts the player, and a player-controlled entity 
% overlapping with it produces a bad outcome. 

% TODO: Shouldnt dodging be read if the entity hurts the player OR
%       the overlapping thing? The hurt reading is already implied by the overlap condition
% TODO: Should rename dodge to player_dodge to be more explicit? Or 
%       decouple the player from the rule, 
%       so it just checks 1 entity (possibly the player) dodging another (an entity-entity/player relation?)
% (And similarly for defend_against)

{ reading(dodge,Entity) } :-
    reading(hurt,relation(Entity,player)),
    precondition(overlaps(Entity),Outcome),
    precondition(overlaps(Entity2),Outcome),
    reading(bad,Outcome),
    player_controls(Entity2).


% Asking for a game with player dodging or defending implies 
% asking for a game in which the player can be hurt by an entity(?)

required(hurt) :- required(dodge).
required(hurt) :- required(defend).

required(dodge) :- reading(dodge,_).
required(defend) :- reading(defend_against,_).


%%%%%%

%% Entity-Entity Relations

% An entity can help or hurt another entity

% TODO: entities helping other entities is just a stub right now

%{ reading(help,relation(Entity1,Entity2)) } :-
%    precondition(overlaps(Entity1,Entity2,true),Outcome),
%    result(Outcome,modify(increase,property(Entity2,health))).

%{ reading(help,relation(Entity1,Entity2)) } :-
%    precondition(overlaps(Entity2,Entity1,true),Outcome),
%    result(Outcome,modify(increase,property(Entity2,health))).


{ reading(hurt,relation(Entity1,Entity2)) } :-
    precondition(overlaps(Entity1,Entity2,true),Outcome),
    result(Outcome,delete(Entity2)).

{ reading(hurt,relation(Entity1,Entity2)) } :-
    precondition(overlaps(Entity2,Entity1,true),Outcome),
    result(Outcome,delete(Entity2)).

% TODO: An entity is also hurting another if it causes its health to decrease

%{ reading(hurt,relation(Entity1,Entity2)) } :-
%    precondition(overlaps(Entity1,Entity2,true),Outcome),
%    result(Outcome,modify(decrease,property(Entity2,health))).

%{ reading(hurt,relation(Entity1,Entity2)) } :-
%    precondition(overlaps(Entity2,Entity1,true),Outcome),
%    result(Outcome,modify(decrease,property(Entity2,health))).


% An entity can chase or flee from another

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


% One entity type can share a second entity with each other(?)

{ reading(sharing,relation(Entity,Entity1)) } :-    
    reading(consumes,relation(Entity1,Entity)),
    many(Entity1),
    reading(good,Resource).

{ reading(sharing,relation(Entity,Entity1)) } :-     
    reading(consumes,relation(Entity1,Entity)),
    many(Entity1),
    precondition(overlaps(Entity1,Entity,true),Outcome),
    result(Outcome,delete(Entity)),
    result(Outcome,modify(increase,Resource)),
    reading(good,Resource).

required(good) :- required(sharing).
required(consumes) :- required(sharing).


% Entities can produce or consume another entity

{ reading(produces,relation(Entity1,Entity2)) } :-
    action(add(Entity2,_,Entity1)).

{ reading(consumes,relation(Entity1,Entity2)) } :-
    precondition(overlaps(Entity2,Entity1,true),Outcome),
    result(Outcome,delete(Entity2)).


% TODO: An entity can also be interpreted as consuming another entity
% if overlapping with it decreases its health

%{ reading(consumes,relation(Entity1,Entity2)) } :-
%    precondition(overlaps(Entity2,Entity1,true),Outcome),
%    result(Outcome,modify(decrease,property(Entity2,health))).
%{ reading(consumes,relation(Entity1,Entity2)) } :-
%    precondition(overlaps(Entity1,Entity2,true),Outcome),
%    result(Outcome,modify(decrease,property(Entity2,health))).


%%%%%%

%% Entity-Resource Relations
% Relations that can exist from an Entity to a Resource
    
reading(consumes,relation(Entity1,Resource1)) :-
    precondition(overlaps(Entity1,Entity2,true),Outcome),
    result(Outcome,modify(decrease,Resource1)).

reading(consumes,relation(Entity1,Resource1)) :-
    precondition(overlaps(Entity2,Entity1,true),Outcome),
    result(Outcome,modify(decrease,Resource1)).


reading(produces,relation(Entity1,Resource1)) :-
    precondition(overlaps(Entity1,Entity2,true),Outcome),
    result(Outcome,modify(increase,Resource1)).

reading(produces,relation(Entity1,Resource1)) :-
    precondition(overlaps(Entity2,Entity1,true),Outcome),
    result(Outcome,modify(increase,Resource1)).


reading(costs,relation(Entity1,Resource1)) :-
    result(Outcome,add(Entity1,_,_)),
    result(Outcome,modify(decrease,Resource1)).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
%%% GOALS %%%

%% A goal can be to produce or reduce a resource or color to a threshold

% If game win or narrative progress happens when it reaches a threshold
% Or game loss or narrative gating happens when it is below a threshold

reading(goal(Action),Thing) :-
    goal(Action,Thing).


reading(goal(produce),Resource) :-
    precondition(compare(le,Resource,Amount),Outcome),
    result(Outcome,mode_change(game_loss;narrative_gating)).

reading(goal(produce),Resource) :-
    precondition(compare(ge,Resource,Amount),Outcome),
    result(Outcome,mode_change(game_win;narrative_progress)).


reading(goal(produce),Resource) :-
    precondition(compare(le,Resource),Outcome),
    result(Outcome,mode_change(game_loss;narrative_gating)).

reading(goal(produce),Resource) :-
    precondition(compare(ge,Resource),Outcome),
    result(Outcome,mode_change(game_win;narrative_progress)).


reading(goal(produce),Color) :-
    precondition(compare(le,amount(Color),Amount),Outcome),
    result(Outcome,mode_change(game_loss;narrative_gating)).

reading(goal(produce),Color) :-
    precondition(compare(ge,amount(Color),Amount),Outcome),
    result(Outcome,mode_change(game_win;narrative_progress)).

    
reading(goal(reduce),Resource) :-
    precondition(compare(ge,Resource),Outcome),
    result(Outcome,mode_change(game_loss;narrative_gating)).
    
reading(goal(reduce),Resource :-
    precondition(compare(le,Resource),Outcome),
    result(Outcome,mode_change(game_win;narrative_progress)).

    
reading(goal(reduce),Color) :-
    precondition(compare(ge,amount(Color),Amount),Outcome),
    result(Outcome,mode_change(game_loss;narrative_gating)).
    
reading(goal(reduce),Color) :-
    precondition(compare(le,amount(Color),Amount),Outcome),
    result(Outcome,mode_change(game_win;narrative_progress)).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% GOODNESS / BADNESS %%%

required(good;bad).

%% Resources can be good or bad
% A resource production goal implies the resource is good
% A resource reduction goal implies the resource is bad
    
reading(good,Resource) :-
    reading(goal(produce),Resource).

% Why is this a choice rule and the above rule is not?
{ reading(bad,Resource) } :-
    reading(goal(reduce),Resource).

required(goal(produce)) :- required(good).
required(goal(reduce)) :- required(bad).


%{reading(good,property(Player,health)) } :-
%    player_controls(Player),
%    action(modify(_,property(Player,health))).


% Entities can be good or bad - given by their relationship to resources

reading(good,Entity) :-
    reading(good,Resource),
    reading(produces,relation(Entity,Resource)).

reading(good,Entity) :-
    reading(bad,Resource),
    reading(consumes,relation(Entity,Resource)).

reading(bad,Entity) :-
    reading(good,Resource),
    reading(consumes,relation(Entity,Resource)).

reading(bad,Entity) :-
    reading(bad,Resource),
    reading(produces,relation(Entity,Resource)).


%% Outcomes can be good or bad
% Good/bad outcomes derived from their relationship to Resources

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


% Good/bad outcomes derived from their relationship to Entities

reading(good,Outcome) :-
    result(Outcome,add(Entity,_,_)),
    reading(good,Entity).

reading(bad,Outcome) :-
    result(Outcome,add(Entity,_,_)),
    reading(bad,Entity).

reading(good,Outcome) :-
    result(Outcome,delete(Entity)),
    reading(bad,Entity).

reading(bad,Outcome) :-
    result(Outcome,delete(Entity)),
    reading(good,Entity).


% Good/bad outcomes derived from their relationship to Color

reading(good,Outcome) :-
    result(Outcome,draw(_,Color)),
    reading(good,Color).

reading(bad,Outcome) :-
    result(Outcome,clear(_)),
    reading(good,Color),
    palette(Color).

reading(bad,Outcome) :-
    result(Outcome,draw(_,Color)),
    reading(bad,Color).

reading(good,Outcome) :-
    result(Outcome,clear(_)),
    reading(bad,Color),
    palette(Color).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% MISC %%%

%%% Difficulty? %%%

% If an entity can hurt the player, 
% and the entity's speed is equal to the resource,
% the difficulty is the resource.
% Uses speed(Entity,Outcome,Speed_Value)

reading(difficulty,Resource) :-
    reading(hurt,relation(Entity,player)),
    speed(Entity,O,Resource).

% If the entity can hurt the player,
% and a number of those entities equal to the resource are added
% difficulty is the resource.

reading(difficulty,Resource) :-
    reading(hurt,relation(Entity,player)),
    action(add(Entity,Resource,_)).

% If a resource is good and theres an action which decreases it
% by an amount equal to another resource, 
% difficulty is the second resource. 

reading(difficulty,Resource) :-
    reading(good,Resource2),
    action(modify(decrease,Resource2,Resource)).

% If a resource is bad and theres an action which increases it 
% by an amount equal to another resource,
% difficulty is the second resource.

reading(difficulty,Resource) :-
    reading(bad,Resource2),
    action(modify(increase,Resource2,Resource)).


%%%%%%

% A condition can trigger both a good and bad outcome simultaneously

reading(risk_reward,Condition) :-
    precondition(Condition,Good),
    reading(good,Good),
    precondition(Condition,Bad),
    reading(bad,Bad).

%%%%%%

% A game requires hand-eye coordination if it has a 
% hand-eye coordination outcome which is also good for the player

% hand_eye_coordination(Outcome) defined in generation_rules.lp
% as an outcome triggered by an overlap or clicking precondition

{ reading(hand_eye_coordination,game) } :-
    reading(good,Outcome),
    hand_eye_coordination(Outcome).

%%%%%%

%%% Tradeoff between 2 resources or outcomes %%%

% Defines goodness opposites; used in tradeoff reading
% e.g., increasing badness is the opposite of decreasing badness,
%       decreasing good is the opposite of decreasing bad
	
opposed(bad,increase,bad,decrease).
opposed(good,increase,good,decrease).
opposed(good,increase,bad,increase).
opposed(good,decrease,bad,decrease).
opposed(V1,D1,V2,D2) :- opposed(V2,D2,V1,D1).

% Tradeoff if the same rule triggers opposite-polarity resource modifications
% e.g., rule results in both increase of a bad resource and increase in good resource

reading(tradeoff,relation(R1, R2)) :-
	result(O,modify(Direction1,R1)),
	result(O,modify(Direction2,R2)),
	reading(V1,R1),
	reading(V2,R2),
	opposed(V1,Direction1,V2,Direction2).

reading(tradeoff,Outcome) :-
    reading(good,Outcome),
    reading(bad,Outcome).

% Requiring a tradeoff implies requiring both good and bad
% TODO: required(tradeoff) isnt implied by reading(tradeoff,relation(R1,R2))?

required(good) :- required(tradeoff).
required(bad) :- required(tradeoff).

%%%%%%

%%% Maintaining a resource %%%

% The player is 'maintaining' a resource if 
% it is a good resource, that the player can increase,
% that depletes over time

{ reading(maintenance,Resource) } :-
    reading(good,Resource),
    player_controls_outcome(Outcome),
    result(Outcome,modify(increase,Resource)),
    result(OverTime,modify(decrease,Resource)),
    over_time(OverTime).

% TODO: required(maintenance) isnt implied by reading(maintenance,Resource)?

required(produces) :- required(maintenance).
required(good) :- required(maintenance).

{ reading(maintenance,Resource) } :-
    reading(bad,Resource),
    player_controls_outcome(Outcome),
    result(Outcome,modify(decrease,Resource)),
    result(OverTime,modify(increase,Resource)),
    over_time(OverTime).

required(bad) :- required(maintenance).

%%%%%%

%%% Stakes of a resource %%%

% Stakes (associated with a resource) are high 
% if a resource comparison results in a win or loss,
% And low otherwise

{ reading(stakes(high),Resource) } :-
    precondition(compare(ge,Resource),Outcome),
    result(Outcome,mode_change(game_loss)).
    
{ reading(stakes(high),Resource) } :-
    precondition(compare(le,Resource),Outcome),
    result(Outcome,mode_change(game_win)).

%{ reading(stakes(high),property(Entity,health)) } :-
%    entity(Entity),
%    action(modify(decrease,property(Entity,health))).

{ reading(stakes(low),Resource) } :-
    resource(Resource),
    not reading(stakes(high),Resource).

% TODO: required(stakes(low)) isnt implied by reading(stakes(low),_)?

required(stakes(high)) :- required(stakes(low)).

%%%%%%

%%% Grinding %%%

% Grinding is a valid reading iff monotonic, player controls the modification

{ reading(grinding,Resource) } :-
    monotonic(Resource),
    player_controls_outcome(Outcome),
    result(Outcome,modify(_,Resource)),
    not reading(risk,Outcome).

% TODO: required(grinding) isnt connected to reading(grinding,_)?

required(risk) :- required(grinding).

%%%%%%

% Organization

{ reading(organization) } :-
    precondition(overlaps(Entity,Entity2,true),Outcome),
    outcome_enables(Outcome,EndOutcome),
    result(EndOutcome,mode_change(game_win;narrative_progress)).

%%%%%%

% An outcome has risk if its precondition also triggers a bad outcome

{ reading(risk,Outcome) } :-
    precondition(Cond,Outcome),
    precondition(Cond,BadOutcome),
    reading(outcome_hurts,relation(BadOutcome,_)).

%%%%%%

% A player-controlled outcome can help or hurt

required(outcome_hurts) :- required(risk).

{ reading(outcome_helps,relation(Outcome,Resource)) } :-
    result(Outcome,modify(increase,Resource)),
    player_controls_outcome(Outcome),
    reading(good,Resource).

{ reading(outcome_helps,relation(Outcome,Resource)) } :-
    result(Outcome,modify(decrease,Resource)),
    player_controls_outcome(Outcome),
    reading(bad,Resource).


required(good) :- required(outcome_helps).
required(bad) :- required(outcome_helps).


{ reading(outcome_hurts,relation(Outcome,Resource)) } :-
    result(Outcome,modify(decrease,Resource)),
    player_controls_outcome(Outcome),
    reading(good,Resource).

{ reading(outcome_hurts,relation(Outcome,Resource)) } :-
    result(Outcome,modify(increase,Resource)),
    player_controls_outcome(Outcome),
    reading(bad,Resource).

required(good) :- required(outcome_hurts).
required(bad) :- required(outcome_hurts).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% HELPERS %%%

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


nonmonotonic(Resource) :-
    resource(Resource),
    not monotonic(Resource).


reading_about(Thing) :-
    reading(Action,Thing).
reading_about(Thing) :-
    reading(Action,relation(Thing,_)).
reading_about(Thing) :-
    reading(Action,relation(_,Thing)).


% outcome_creates_condition : (not used anywhere)

outcome_creates_condition(Outcome,compare(le,Resource)) :-
    result(Outcome,modify(decrease,Resource)),
    condition(compare(le,Resource)).

outcome_creates_condition(Outcome,compare(ge,Resource)) :-
    result(Outcome,modify(increase,Resource)),
    condition(compare(ge,Resource)).

outcome_creates_condition(Outcome,overlaps(Entity)) :-
    result(Outcome,move(Entity,direction(_,_))),
    condition(overlaps(Entity)).


% outcome_enables : Build up causal chains of outcomes leading to other outcomes

outcome_enables(Outcome,Other) :-
    outcome_creates_condition(Outcome,Cond),
    precondition(Cond,Other).

outcome_enables(O1,O3) :-
    outcome_enables(O1,O2),
    outcome_enables(O2,O3).

