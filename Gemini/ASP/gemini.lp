#include "logics/logics.lp".

% * TODO initialization as a_op applications
% ** TODO ensure set_blocking is given at init time as are resource pools, gamemode, etc
% ** TODO ensure we can have multiple add_collider for the same C and Loc?  nah, use rowcol locs for that?
% ** TODO ensure newly created characters get their charmstates set
% ** TODO remove initializers from OL files 

% * Constants
#const min_entities_g3 = 1.
#const max_entities_g3 = 2.
#const min_resources_g3 = 1.
#const max_resources_g3 = 2.
#const min_outcomes_g3 = 2.
#const max_outcomes_g3 = 6.
#const min_timers_g3 = 0.
#const max_timers_g3 = 2.

#const min_entity_states_g3 = 1.
#const max_entity_states_g3 = 2.
#const min_end_outcomes_g3 = 1.
#const max_end_outcomes_g3 = 1.
#const max_resource_change_per_g3 = 2.
#const max_conditions_per_g3 = 2.


% * Collision
% Use collision logics
#include "logics/collision.lp".
collision_logic_g3(collision).
% In the collision logic col, these are reasonable distances to check between objects
distance_g3(collision, d(50)) :-
  collision_logic_g3(collision).
distance_g3(collision, d(500)) :-
  collision_logic_g3(collision).

% use default "maybe X blocks Y" initialization

% color drawing
%   these will be colliders spaced at uniform positions of one type per color.  they might even be blocking which will give us terrain!
{paint_g3(C)} :- palette(C).
collider_g3(collision, C) :-
  collision_logic_g3(collision),
  paint_g3(C).

% structural synthesis with collision
%  one entity:one collider
collider_g3(collision, E) :-
  collision_logic_g3(collision),
  entity_g3(E).

collider_g3(collision, cursor) :-
  collision_logic_g3(collision).

:- result_g3(_,set_blocking(cursor,_)).

% * Physics
#include "logics/physics.lp".
physics_logic_g3(physics).
physics_body_g3(physics, E) :-
  entity_g3(E).

% Tie physics and character states together

physics_mode_g3(physics, E, M) :-
  entity_g3(E),
  charstate_logic_g3(charstate),
  charmstate_g3(charstate, E, M).

% physics_mode_g3(physics, E, dead) :-
  % entity_g3(E).

prerequisite_g3(charstate, set_charmstate(E, M),
                physics, set_physics_mode(E, M)) :-
  charstate_logic_g3(charstate),
  physics_logic_g3(physics),
  a_op_g3(charstate, set_charmstate(E, M)),
  a_op_g3(physics, set_physics_mode(E, M)).

prerequisite_g3(physics, set_physics_mode(E, M),
                charstate, set_charmstate(E, M)) :-
  charstate_logic_g3(charstate),
  physics_logic_g3(physics),
  a_op_g3(charstate, set_charmstate(E, M)),
  a_op_g3(physics, set_physics_mode(E, M)).

% ** Steering
steering_g3(stay;seek;flee).
% steering(pursue;avoid). % could also be implemented as adding locs for ahead_of(E) when entity(E).

{steering_mode_g3(E, M, Steer):steering_g3(Steer)} :-
  physics_mode_g3(physics, E, M).

% Even the idea of "character X chases character Y" is more than what a physics logic provides.  Right?  Physics logics govern smooth movement, but can we say that it's smooth movement towards targets?  In HyPED we assume the target is nondeterministically given but the style of movement is sort of provided.  so does it make sense to put steering_mode into physics?  or is it more like "approach loc" where loc can be something or other in the physics world?  I really don't feel like destinations belong there...

% * Character-state
% Use character-state logics (alive/dead)
#include "logics/character_state.lp".
charstate_logic_g3(charstate).
% structural synthesis with character-state logics
%  one entity:one char machine
charm_g3(charstate, E) :-
  charstate_logic_g3(charstate),
  entity_g3(E).
%  one char machine:one state for sure
charmstate_g3(charstate, E, normal) :-
  charstate_logic_g3(charstate),
  entity_g3(E).
% charmstate_g3(charstate, E, dead) :-
  % charstate_logic_g3(charstate),
  % entity_g3(E).
   % and one edge
% charmedge_g3(charstate, E, normal, dead) :-
  % charstate_logic_g3(charstate),
  % entity_g3(E).
% maybe more states
1{max_entity_states_g3(E,S):S = min_entity_states_g3..max_entity_states_g3}1 :-
  entity_g3(E).
{charmstate_g3(charstate, E, state(S))} :-
  charstate_logic_g3(charstate),
  S = min_entity_states_g3..max_entity_states_g3,
  max_entity_states_g3(E, S2),
  S < S2,
  entity_g3(E).
{charmedge_g3(charstate, E, S1, S2)} :-
  charstate_logic_g3(charstate),
  charmstate_g3(charstate, E, S1),
  charmstate_g3(charstate, E, S2).

% FIXME: for now constrain state machines so that every generated state at least has a cycle with normal (other edges are allowed too but we don't want to worry about full blown reachability and everything right now) 
:- charstate_logic_g3(charstate),
  charmstate_g3(charstate, E, S),
  S != normal,
  not charmedge_g3(charstate, E, normal, S).
:- charstate_logic_g3(charstate),
  charmstate_g3(charstate, E, S),
  S != normal,
  not charmedge_g3(charstate, E, S, normal).
% TODO: maybe generate new states but give them all transitions to dead
%  and give some transitions between the new states too

% always require starting with at least one alive thing
% :- charstate_logic(charstate),
%   {init(charstate, charmstate(E, dead)):entity(E)} = K,
%   not max_entity(K).

% * Resource
% Resource logics
#include "logics/resource.lp".
resource_logic_g3(resource).
%  Valid resource quantities for rules
resource_amount_g3(resource, r(0)) :-
  resource_logic_g3(resource).
resource_amount_g3(resource, r(1)) :-
  resource_logic_g3(resource).
resource_amount_g3(resource, r(3)) :-
  resource_logic_g3(resource).
resource_amount_g3(resource, r(5)) :-
  resource_logic_g3(resource).
resource_amount_g3(resource, r(10)) :-
  resource_logic_g3(resource).
resource_pool_g3(resource, health(E)) :-
  resource_logic_g3(resource),
  entity_g3(E).
resource_pool_g3(resource, R) :-
  resource_logic_g3(resource),
  resource_g3(R).
{resource_pool_capacity_g3(resource, P, r(10))} :-
  resource_logic_g3(resource),
  resource_pool_g3(resource, P).

% ** color pools, prevent altering those pools by resource transactions
paint_pool_g3(paint(P)) :- paint_g3(P).
resource_pool_g3(resource, paint(P)) :-
  resource_logic_g3(resource),
  paint_g3(P).
resource_pool_capacity_g3(resource, P, inf) :-
  resource_logic_g3(resource),
  resource_pool_g3(resource, P),
  paint_pool_g3(P).

% % TODO LATER: handle moving resources like paint and collider counts and remove these constraints
:- paint_pool_g3(P),
  result_g3(_, move_resource(P, _, _)).
:- paint_pool_g3(P),
  result_g3(_, move_resource(_, P, _)).

birequisite_g3(collision, remove_collider(P, Loc),
               resource, alter_resource(paint(P), dec, r(1))) :-
  logic_g3(collision),
  logic_g3(resource),
  loc_g3(collision, Loc),
  paint_g3(P).

birequisite_g3(collision, add_collider(P, Loc),
               resource, alter_resource(paint(P), inc, r(1))) :-
  logic_g3(collision),
  logic_g3(resource),
  loc_g3(collision, Loc),
  paint_g3(P).
% TODO: really want to say "if there is another paint remove it" but we'll go with this for now.
prerequisite_g3(collision, add_collider(P, Loc),
                collision, at_loc(P2, Loc, false)) :-
  logic_g3(collision),
  paint_g3(P),
  paint_g3(P2),
  loc_g3(collision, Loc).

% ** Entity count pools

entity_pool_g3(entity(E)) :-
  entity_g3(E).
resource_pool_g3(resource, entity(E)) :-
  logic_g3(resource),
  entity_g3(E).
resource_pool_capacity_g3(resource, P, inf) :-
  logic_g3(resource),
  entity_pool_g3(P).

% TODO LATER: handle moving resources like paint and collider counts and remove these constraints
:- entity_pool_g3(P), result_g3(_, move_resource(P, _, _)).
:- entity_pool_g3(P), result_g3(_, move_resource(_, P, _)).

birequisite_g3(collision, remove_collider(entity(E), Loc),
               resource, alter_resource(entity(E), dec, r(1))) :-
  logic_g3(collision),
  logic_g3(resource),
  loc_g3(collision, Loc),
  entity_g3(E).
birequisite_g3(collision, add_collider(entity(E), Loc),
               resource, alter_resource(entity(E), inc, r(1))) :-
  logic_g3(collision),
  logic_g3(resource),
  loc_g3(collision, Loc),
  entity_g3(E).


% * Control logics
#include "logics/control.lp".
control_logic_g3(control).

input_g3(L, (button(mouse,(up;press;down)))) :-
  control_logic_g3(L).

{input_map_g3(L, I, Agent, Action)} :-
  control_logic_g3(L),
  input_g3(L, I),
  agent_g3(L, Agent),
  action_g3(L, Agent, Action).

% TODO add keyboard buttons
agent_g3(control, E) :-
  control_logic_g3(control),
  entity_g3(E).
% action_g3(control, E, set_target(Loc)) :-
  % control_logic_g3(control),
  % entity_g3(E),
  % agent_g3(control, E),
  % loc_g3(collision, Loc).
action_g3(control, E, A) :-
  control_logic_g3(control),
  agent_g3(control, E),
  logic_g3(L),
  L != control,
  a_op_g3(L, A).

% * Structural synthesis between collision and physics
loc_g3(collision, C) :-
  logic_g3(collision),
  collider_g3(collision, C).
loc_g3(collision, target(E)) :-
  logic_g3(collision),
  entity_g3(E).
loc_g3(collision, arb) :-
  logic_g3(collision).
dir_g3(physics, L) :-
  collider_g3(collision, L).
dir_g3(physics, aheadof(E)) :-
  logic_g3(physics),
  entity_g3(E). 
dir_g3(physics, behind(E)) :-
  logic_g3(physics),
  entity_g3(E).
dir_g3(physics, (nw;n;ne;w;e;sw;s;se)) :-
  logic_g3(physics).
dir_g3(physics, arb) :-
  logic_g3(physics).
dir_g3(physics, (forward;right)) :-
  logic_g3(physics).
physics_avel_g3(physics,(arb;narb)).
physics_lvel_g3(physics,(arb;narb)).
physics_lvel_g3(physics,lvel(R;-R)) :-
  resource_pool_g3(resource, R).
physics_lvel_g3(physics,(inf;ninf)).
% Prevent collision logic driven low level moves, do all movement by physics logic
:- result_g3(_, move_to(_, _)).

% * Game-mode
#include "logics/gamemode.lp".
gamemode_logic_g3(gamemode).
gamemode_g3(gamemode, (playing;game_loss;game_win;narrative_gating;narrative_progress)) :-
  gamemode_logic_g3(gamemode).
% Only ever do anything when in non-stuck modes, rely on outer game to kick us out of stuck when we get stuck?
% TODO: future: generate new game modes too
prerequisite_g3(L, Op, gamemode, gamemode(playing, true)) :-
  logic_g3(L),
  q_op_g3(L,Op),
  logic_g3(gamemode),
  L != gamemode.
prerequisite_g3(L, Op, gamemode, gamemode(playing, true)) :-
  logic_g3(L),
  a_op_g3(L,Op),
  logic_g3(gamemode),
  L != gamemode.

:- outcome_g3(O),
  gamemode_logic_g3(gamemode),
  precondition_g3(gamemode(G1, true), O),
  precondition_g3(gamemode(G2, true), O),
  gamemode_g3(gamemode,G1),
  gamemode_g3(gamemode,G2),
  G1 != G2.

:- outcome_g3(O),
  gamemode_logic_g3(gamemode),
  precondition_g3(O, gamemode(M, true)),
  M != playing.
:- outcome_g3(O),
  2{result_g3(O, set_gamemode(M)):gamemode_g3(gamemode, M)}.

% * Extra gemini concepts
1{max_entity_g3(min_entities_g3..max_entities_g3)}1.
entity_g3(e(M)) :-
  M = 1..N,
  max_entity_g3(N).

1{max_generated_outcome_g3(min_outcomes_g3..max_outcomes_g3)}1.
generated_outcome_g3(o(M)) :-
  M = 1..N,
  max_generated_outcome_g3(N).

1{max_resource_g3(min_resources_g3..max_resources_g3)}1 :-
  resource_logic_g3(resource).
resource_g3(rsrc(M)) :-
  resource_logic_g3(resource),
  M = 1..min_resources_g3..N,
  max_resource_g3(N).

% steering defined at this level?  Or in the physics logic itself?
% steering(seek, ...)?  or physics_mode(L, Ent, Behavior)?
%   there needs to be a way to figure out the physics mode _at a given time_ without re-solving.  like with input_map.  maybe based on preconditions or character states explicitly.
% TODO: steering here to combine info about target position, accels, max vels into controllers?
% TODO: something like "mouse down to drive towards" will probably require a new state for the controlled character, right?

1{max_timer_g3(M) : M = min_timers_g3..max_timers_g3}1.

timer_g3(T) :-
  max_timer_g3(T),
  T > 0.

:- timer_g3(T),
  1 != {precondition_g3(timer(T,_,_),_)}.

% TODO: not really sure about this being in gemini or being a q_op?
q_op_g3(gemini,timer(T,Interval,Oneshot)) :-
  timer_g3(T),
  timer_interval_g3(Interval),
  bool_g3(Oneshot).

timer_interval_g3(short;medium;long).

% ** Gemini's operational integrations

{precondition_g3(Q, O)} :-
  logic_g3(L),
  q_op_g3(L,Q),
  generated_outcome_g3(O).

outcome_g3(O) :-
  generated_outcome_g3(O).

unchecked_outcome_g3(O) :-
  outcome_g3(O),
  not precondition_g3(_, O).
:- unchecked_outcome_g3(_).

{result_g3(O, A)} :-
  generated_outcome_g3(O),
  logic_g3(L),
  a_op_g3(L, A).

trivial_outcome_g3(O) :-
  outcome_g3(O),
  not result_g3(O, _).
:- trivial_outcome_g3(_).

% Example: prevent any outcome that moves resource into or out of agent health?
% :- resource_logic(resource), outcome(O), result(O, move_resource(health(_), _, _)).
% :- resource_logic(resource), outcome(O), result(O, move_resource(_, health(_), _)).

% Some queries might have other implicit queries
query_needs_query_g3(Q, Q2, O) :-
  precondition_g3(Q, O),
  q_op_g3(L1, Q),
  prerequisite_g3(L1, Q, L2, Q2),
  q_op_g3(L2, Q2),
  not precondition_g3(Q2, O).
:- query_needs_query_g3(_, _, _).
% Some conditions might be forced to go with certain outcomes
query_needs_change_g3(Q, A, O) :-
  precondition_g3(Q, O),
  q_op_g3(L1, A),
  prerequisite_g3(L1, Q, L2, A),
  a_op_g3(L2, A),
  not result_g3(O, A).
:- query_needs_change_g3(_, _, _).
% Some actions might have implicit preconditions
unchecked_action_pre_g3(A, Q, O) :-
  result_g3(O, A),
  % But special-cased actions don't have this property
  O != tick,
  O != init,
  % OK, continue
  a_op_g3(L1, A),
  prerequisite_g3(L1, A, L2, Q),
  q_op_g3(L2, Q),
  not precondition_g3(Q, O).
:- unchecked_action_pre_g3(_, _, _).

% Some actions might have implicit dependent actions; this is true for tick and init too
unmet_action_action_req_g3(A, A2, O) :-
  result_g3(O, A),
  a_op_g3(L1, A),
  prerequisite_g3(L1, A, L2, A2),
  a_op_g3(L2, A2),
  not result_g3(O, A2).
:- unmet_action_action_req_g3(_, _, _).


prerequisite_g3(L1, Op1, L2, Op2) :-
  birequisite_g3(L1, Op1, L2, Op2).
prerequisite_g3(L1, Op1, L2, Op2) :-
  birequisite_g3(L2, Op2, L1, Op1).

:- conflict_g3(L1, Op1, L2, Op2),
  logic_g3(L1),
  logic_g3(L2),
  q_op_g3(L1, Op1),
  q_op_g3(L2, Op2),
  precondition_g3(Op1, O),
  precondition_g3(Op2, O).
:- conflict_g3(L1, Op1, L2, Op2),
  logic_g3(L1),
  logic_g3(L2),
  q_op_g3(L1, Op1),
  a_op_g3(L2, Op2),
  precondition_g3(Op1, O),
  result_g3(O, Op2).
:- conflict_g3(L1, Op1, L2, Op2),
  logic_g3(L1),
  logic_g3(L2),
  a_op_g3(L1, Op1),
  q_op_g3(L2, Op2),
  result_g3(O, Op1),
  precondition_g3(Op2, O).
:- conflict_g3(L1, Op1, L2, Op2),
  logic_g3(L1),
  logic_g3(L2),
  a_op_g3(L1, Op1),
  a_op_g3(L2, Op2),
  result_g3(O, Op1),
  result_g3(O, Op2).

% *** Unused so far; Entities dying when they're out of health
% precondition_g3(charmstate(E, dead, false), die(E)) :-
%   charstate_logic_g3(charstate),
%   q_op_g3(charstate, charmstate(E, dead, false)),
%   entity_g3(E).
% precondition_g3(has_resource(health(E), le, s(0)), die(E)) :-
  % resource_logic_g3(resource),
  % q_op_g3(resource, has_resource(health(E), le, s(0))),
  % entity_g3(E).

% Must be at least a few reasons to die (in alive state, has edge, and X)
% arb_death_g3 :-
  % entity_g3(E),
  % not 3{precondition_g3(Q, die(E)):logic_g3(L), q_op_g3(L, Q)}.
% :- arb_death_g3.

% outcome_g3(die(E)) :-
  % entity_g3(E).

% result_g3(die(E), set_charmstate(E, dead)) :-
  % charstate_logic_g3(charstate),
  % entity_g3(E).

%% dying acts like a generated outcome in other ways

% {precondition_g3(Q, die(E))} :-
  % entity_g3(E),
  % logic_g3(L),
  % q_op_g3(L, Q).

% {result_g3(die(E), A)} :-
  % entity_g3(E),
  % logic_g3(L),
  % a_op_g3(L, A).

% *** ticking is also a special case thing with its own special results
precondition_g3(tick, tick).
% Generate results for ticks
{result_g3(tick, A)} :-
  logic_g3(L),
  a_op_g3(L, A).

% * Initialization, in general
outcome_g3(init).
precondition_g3(init, init).
{result_g3(init, A)} :-
  logic_g3(L),
  a_op_g3(L, A),
  init_ok_g3(L, A).

init_ok_g3(L, alter_resource(P, inc, inf)) :-
  resource_logic_g3(L),
  resource_pool_g3(L, P).
  
:- resource_logic_g3(L),
  resource_pool_g3(L, P),
  not 1{result_g3(init, alter_resource(P, inc, _))}1.

init_ok_g3(L, set_charmstate(M, S)) :-
  charstate_logic_g3(L),
  charm_g3(L, M),
  charmstate_g3(L, M, S).

% Every machine must be initialized
% "guess a default but admit overriding with explicit facts"
% :- charstate_logic_g3(L),
  % charm_g3(L, M),
  % not 1{result_g3(init, set_charmstate(M, S)):charmstate_g3(L,M,S)}1.

row_g3(top;middle;bottom).
col_g3(left;center;right).

loc_g3(collision,grid(Row, Col)) :-
  row_g3(Row),
  col_g3(Col).
init_loc_g3(collision, grid(Row, Col)) :-
  row_g3(Row),
  col_g3(Col).


init_ok_g3(L, set_blocking(C1, C2, B)) :-
  a_op_g3(L, set_blocking(C1, C2, B)).
init_ok_g3(L, add_collider(C, Loc)) :-
  collision_logic_g3(L),
  a_op_g3(L, add_collider(C, Loc)),
  init_loc_g3(L, Loc).
init_ok_g3(L, set_gamemode(playing)) :-
  gamemode_logic_g3(L).

:- gamemode_logic_g3(L), not 1{result_g3(init, set_gamemode(_))}1.

% * Decorations and gemini-specific stuff
% ** TODO: move these into collision logic or something
1{result_g3(init, set_sprite(Entity, Sprite)) : sprite(Sprite)}1 :-
  entity_g3(Entity).
1{result_g3(init, set_color(Entity, Color)) : colors(Color)}1 :-
  entity_g3(Entity).

sprite(triangle).
colors(red;blue).
palette(blue).

% * Other world model stuff

boundary_types(torus;closed).
1{boundary(Type):boundary_types(Type)}1.

% * Readings

% #include "generation.lp". % Handled by 3to2 
#include "gemini_3to2.lp".
#include "generation_constraints.lp".
#include "generation_rules.lp".
#include "generation_atoms.lp".
#include "structure_rules.lp".
#include "banned_list.lp".
#include "readings.lp".
#include "simplicity_tuning.lp".
#include "player_model.lp".
% % #include "replacements.lp".
