% Themes:
% friends arguing
% friends trying to win you over
% trying to balance between two sides; ameliorate tension; sit on the fence?
% vs taking a side?
% vs avoiding participating in their argument; deflecting
% academia (research, spreading awareness/knowledge) vs activism (direct action for change)
% local vs global -- Max has been developing the dinner scene to better represent this

% 2 entities are opposed (trying to achieve mutually exclusive goals), you don't control either of them

% any kind of conflict between 2 npcs that the player can mitigate

% could want different colors painted
% two entities are trying to bump into each other 

% something that helps one, something that helps the other, they can't be the same

% each NPC in the narrative should be represented as entities the game?
% PC could optionally have 1 entity
% should be at least 1 resource

% tie tension into gameplay?

% could have the game cause an argument
% once resolved, could have tension set to 0

% speed of one entity = academic enthusiasm 
% speed of other entity = inverse of academic enthusiasm

% if you do not pay attention to the game, it eventually interrupts the narrative (not in a failure way); can keep failing over and over again; have to play the game to reduce the tension (before choice is activated)


#const min_entities = 3.
#const max_entities = 5.
#const min_resources = 1.
#const max_resources = 2.
#const min_outcomes = 2.
#const max_outcomes = 6.
#const min_timers = 0.
#const max_timers = 1.

#const min_end_outcomes = 1.
#const max_end_outcomes = 1.
#const max_resource_change_per = 2.
#const max_conditions_per = 3.

label(resource(r(1)),tension,write).
:- not reading(bad,resource(r(1))).
initialize(set_value(resource(r(1)),scalar(0))).

read_only(resource(r(2))) :- resource(resource(r(2))).
label(resource(r(2)),activism,read_only) :- resource(resource(r(2))).

:- resource(resource(r(2))), reading(good, resource(r(2))).
:- resource(resource(r(2))), reading(bad, resource(r(2))).
:- resource(resource(r(2))), reading(stakes(high), resource(r(2))).
% TODO: force r2 good for E1, bad for E2?

% allow for painting different colors, preventing collisions, ...
% the goal in the game is to keep tension low (add a reading about that) but that gets harder as you commit more on one side or the other

label(entity(e(2)),friend1).
label(entity(e(3)),friend2).

% Have to add these so e2 and e3 could chase each other
chasing_safe(entity(e(2)),entity(e(3))).
chasing_safe(entity(e(3)),entity(e(2))).

% TODO: generalize to other readings of competition, like "tug of war" dynamics or something
:- not reading(hurt,relation(entity(e(2)),entity(e(3)))).
:- not reading(hurt,relation(entity(e(3)),entity(e(2)))).
:- precondition(overlaps(E, E, _), _).
:- player_controls(entity(e(2))), not player_controls(entity(e(3))).
:- player_controls(entity(e(3))), not player_controls(entity(e(2))).

label(entity(e(1)),emma) :- entity(entity(e(1))).
:- entity(entity(e(1))), not player_controls(entity(e(1))).
:- entity(entity(e(1))), reading(hurt,relation(entity(e(1)),E)), entity(E).

:- not action(mode_change(narrative_gating)).
:- 2 {action(mode_change(N))}.

singular(entity(e(1))) :- entity(entity(e(1))).

% :- not condition(overlaps(entity(e(2)),entity(e(3)),true)),
  % not condition(overlaps(entity(e(3)),entity(e(2)),true)).
%singular(entity(e(2))).
%singular(entity(e(3))).

%:- many(entity(e(1))).
%:- many(entity(e(2))).
