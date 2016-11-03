

%modes of avatar control
avatarControls(cardinal;horizontal_axis;vertical_axis;tank;platformer;asteroids).

%modes of indirect control
indirectControls(click_and_drag;
		 %click_and_click;click_and_aim;
		 drawn_to_cursor;repeled_from_cursor).


%%%%%% INITIALIZATIONS %%%%%%%

min_entities {entity(ENTITY) : potentialEntities(ENTITY)} max_entities.
min_resources {resource(RESOURCE) : potentialResources(RESOURCE)} max_resources.
min_outcomes {outcome(OUTCOME) : potentialOutcomes(OUTCOME)} max_outcomes.
min_end_outcomes {end_outcome(OUTCOME) : potentialEndOutcomes(OUTCOME)} max_end_outcomes.

%pick at most 1 entity to be an avatar
{avatar(ENTITY): entity(ENTITY)} 1 .

%an entity should either be singular or many
1 {singular(ENTITY); many(ENTITY)} 1 :- entity(ENTITY).

1 {initialize(add(ENTITY,location(ROW,COL))) : counts(AMOUNT), rows(ROW), columns(COL)} :- entity(ENTITY). 



%avatar requires controls
1 {controlScheme(ENTITY,SCHEME) : avatarControls(SCHEME) } 1 :- avatar(ENTITY).

% maybe pick some controls
{controlScheme(ENTITY,SCHEME) : indirectControls(SCHEME)} 1 :- entity(ENTITY).

%vertical axis
outcome(avatar_move_up) :- 
    1 {controlScheme(ENTITY,cardinal); 
    controlScheme(ENTITY,vertical_axis)}.
outcome(avatar_move_down) :- 
    1 {controlScheme(ENTITY,cardinal); 
    controlScheme(ENTITY,vertical_axis)}.
%need to move  west  if horizontal axis
outcome(avatar_move_left) :- 
    1 {controlScheme(ENTITY,cardinal); 
    controlScheme(ENTITY,horizontal_axis); 
    controlScheme(ENTITY,platformer)}.
%platformers need jumping   
outcome(avatar_jump) :-
    controlScheme(ENTITY,platformer).
%need to move  east  if horizontal  
outcome(avatar_move_right) :- 
    1 {controlScheme(ENTITY,cardinal); 
    controlScheme(ENTITY,horizontal_axis); 
    controlScheme(ENTITY,platformer)}.

%moving  north 
precondition(control_event(button(up_arrow, held)),avatar_move_up) :- 
    avatar(ENTITY), 
    outcome(avatar_move_up).
% precondition(empty(ENTITY,north,low),avatar_move_up) :- 
    % avatar(ENTITY), 
    % outcome(avatar_move_up).
result(avatar_move_up,moves(ENTITY,  north))  :- 
    avatar(ENTITY), 
    outcome(avatar_move_up).
%moving  south 
precondition(control_event(button(down_arrow, held)),avatar_move_down) :- 
    avatar(ENTITY), 
    outcome(avatar_move_down).
% precondition(empty(ENTITY, south ,low),avatar_move_down) :- 
    % avatar(ENTITY), 
    % outcome(avatar_move_down).
result(avatar_move_down,moves(ENTITY,  south))  :- 
    avatar(ENTITY), 
    outcome(avatar_move_down).
%moving  east 
precondition(control_event(button(right_arrow, held)),avatar_move_right) :- 
    avatar(ENTITY), 
    outcome(avatar_move_right).
% precondition(empty(ENTITY, east ,low),avatar_move_right) :- 
    % avatar(ENTITY), 
    % outcome(avatar_move_right).
result(avatar_move_right,moves(ENTITY,  east ))  :- 
    avatar(ENTITY), 
    outcome(avatar_move_right).
%moving  west 
precondition(control_event(button(left_arrow, held)),avatar_move_left) :- 
    avatar(ENTITY), 
    outcome(avatar_move_left).
% precondition(empty(ENTITY, west ,low),avatar_move_left) :- 
    % avatar(ENTITY), 
    % outcome(avatar_move_left).
result(avatar_move_left,moves(ENTITY,  west ))  :- 
    avatar(ENTITY), outcome(avatar_move_left).

%asteroids/combat tank moving forward
outcome(avatar_move_forward) :- 
    1 {controlScheme(ENTITY,tank); 
    controlScheme(ENTITY,asteroids)}.

% tanks can go backwards, spaceships can't
outcome(avatar_move_backward) :- controlScheme(ENTITY,tank).
    
%tanks and spaceships can rotate
outcome(avatar_rotate_right) :- 
    1{controlScheme(ENTITY,tank); 
    controlScheme(ENTITY,asteroids)}.
outcome(avatar_rotate_left) :- 
    1{controlScheme(ENTITY,tank); 
    controlScheme(ENTITY,asteroids)}.
    
%moving forward
precondition(control_event(button(up_arrow, held)),avatar_move_forward) :- 
    avatar(ENTITY), 
    outcome(avatar_move_forward).
% precondition(empty(ENTITY,forward,low),avatar_move_forward) :- 
    % avatar(ENTITY), 
    % outcome(avatar_move_forward).
result(avatar_move_forward,moves(ENTITY, forward))  :- 
    avatar(ENTITY), 
    outcome(avatar_move_forward).
%moving backwards
precondition(control_event(button(down_arrow, held)),avatar_move_backward) :- 
    avatar(ENTITY), 
    outcome(avatar_move_backward).
% precondition(empty(ENTITY,behind,low),avatar_move_backward) :- 
    % avatar(ENTITY), 
    % outcome(avatar_move_backward).
result(avatar_move_backward,moves(ENTITY, behind))  :- 
    avatar(ENTITY), 
    outcome(avatar_move_backward).
%rotate counter clockwise
precondition(control_event(button(left_arrow, held)),avatar_rotate_left) :- 
    avatar(ENTITY), 
    outcome(avatar_rotate_left).
result(avatar_rotate_left,rotates(ENTITY, ccw))  :- 
    avatar(ENTITY), 
    outcome(avatar_rotate_left).
%rotate clockwise
precondition(control_event(button(right_arrow, held)),avatar_rotate_right) :- 
    avatar(ENTITY), 
    outcome(avatar_rotate_right).
result(avatar_rotate_right,rotates(ENTITY, cw))  :- 
    avatar(ENTITY), 
    outcome(avatar_rotate_right).

%everybody jump, jump
precondition(control_event(button(up_arrow, pressed)),avatar_jump) :- 
    avatar(ENTITY), 
    outcome(avatar_jump).
result(avatar_jump,moves(ENTITY,  north , high))  :- 
    avatar(ENTITY), 
    outcome(avatar_jump).

%INDIRECT CONTROLS
% outcome(click_and_drag(ENTITY)) :- controlScheme(ENTITY,click_and_drag).
% outcome(drag(ENTITY)) :- controlScheme(ENTITY,click_and_drag).
% outcome(end_drag(ENTITY)) :- controlScheme(ENTITY,click_and_drag).

controlLogic(draggable(ENTITY)) :- controlScheme(ENTITY,click_and_drag).


% outcome(click_and_click(ENTITY)) :- controlScheme(ENTITY,click_and_click).
% outcome(click_and_aim(ENTITY)) :- controlScheme(ENTITY,click_and_aim).
outcome(drawn_to_cursor(ENTITY)) :- controlScheme(ENTITY,drawn_to_cursor).
outcome(repeled_from_cursor(ENTITY)) :- controlScheme(ENTITY,repeled_from_cursor).      
   
%clicking and dragging
% graphicalLogic(draggable(ENTITY)) :- 
     % outcome(click_and_drag(ENTITY)). 
  
%cursor is electromagnet
precondition(control_event(button(mouse_button, held)),drawn_to_cursor(ENTITY)) :- 
    outcome(drawn_to_cursor(ENTITY)). 
result(drawn_to_cursor(ENTITY), move_towards(ENTITY,cursor)):-
    outcome(drawn_to_cursor(ENTITY)).

%cursor is opposite polarity (well, same polarity) electromagnet
precondition(control_event(button(mouse_button, held)),repeled_from_cursor(ENTITY)) :- 
    outcome(repeled_from_cursor(ENTITY)). 
result(repeled_from_cursor(ENTITY), move_away(ENTITY,cursor)):-
    outcome(repeled_from_cursor(ENTITY)).

%click on something, then move it
%simplest version, click on something
precondition(control_event(click(ENTITY)),select(ENTITY)) :- 
    outcome(select(ENTITY)).
% resource(ENTITY,selected) :- 
    % outcome(select(ENTITY)). 
% resource(ENTITY,target) :- 
    % outcome(select(ENTITY)). 
result(select(ENTITY), set(selected(ENTITY), true)) :- 
    outcome(select(ENTITY)).

%if selected, choose where to go to
precondition(control_event(button(mouse_button, pressed)),move_selected(ENTITY)) :- 
    outcome(move_selected(ENTITY)).   
precondition(check(selected(ENTITY), eq(true)), move_selected(ENTITY)) :- 
    outcome(move_selected(ENTITY)).
% resource(ENTITY,selected) :- 
    % outcome(move_selected(ENTITY)). 
result(move_selected(ENTITY), set(selected(ENTITY),false)) :- 
    outcome(move_selected(ENTITY)).     
result(move_selected(ENTITY), set(target(ENTITY),cursor)) :- 
    outcome(move_selected(ENTITY)). 
result(tick, move_towards(ENTITY,target)) :- 
    outcome(move_selected(ENTITY)). 
precondition(tick,tick) :- 
    outcome(move_selected(ENTITY)). 
%%%%%%%%%% NPC   %%%%%%%%%%%%%%%%%%

%npcs can move in a couple of ways
npcMovements(%projectile;
	     random_walk;random_pathfind;attract;repel;bounce;periodic_attract;periodic_repel;periodic_attract_repel).%;patrol;bounce;path(ping_pong);path(loop)).

%pick ways something can move
% CRM 6/21/2016 - changed max from 0 to 2.
{movementScheme(ENTITY,SCHEME) : entity(ENTITY), npcMovements(SCHEME)} 2.


%path shapes
path_shapes(horizontal;vertical;circle;racetrack;star;spoke;polygon(3);polygon(4);polygon(5);arc(upper);arc(lower)).

%if a path exists, it needs a shape
{path(PATH): potential_paths(PATH)} .

1 {path(PATH,TYPE) : path_shapes(TYPE)} 1 :- path(PATH). 

%if an entity follows a path, it picks a way to be initialized on the path
1 {initialize(set(path(ENTITY)),path(PATH)) : path(PATH,PATH_TYPE)} 1 :- movementScheme(ENTITY,path(TYPE)).

%pick a speed for a projectile
1 {speed(ENTITY,AMOUNT) : constants(AMOUNT)} 1 :- 
    movementScheme(ENTITY,projectile).
%projectiles go straight
result(tick,moves(ENTITY, forward)) :- 
    movementScheme(ENTITY,projectile). 

%Random walkers walk in a given direction for a given amount of time    
outcome(change_direction(ENTITY)) :- 
    movementScheme(ENTITY,random_walk).
1 { timerLogic(change_direction(ENTITY),Duration,loop): duration(Duration) } 1:- 
    movementScheme(ENTITY,random_walk).
%time's  north  - change direction
precondition(timerElapsed(change_direction(ENTITY)), change_direction(ENTITY)) :-
    movementScheme(ENTITY,random_walk).
result(change_direction(ENTITY), rotate_to(ENTITY,random_int(0,360))) :- 
    movementScheme(ENTITY,random_walk).
%normally, just walk forwards ?slowly?
result(tick,moves(ENTITY, forward)) :- 
    movementScheme(ENTITY,random_walk). 

%random pathfinder - changes target every once in a while
outcome(change_target(ENTITY)) :- 
    movementScheme(ENTITY,random_pathfind).
1{timerLogic(change_target(ENTITY),Duration,loop): duration(Duration) } 1 :- 
    movementScheme(ENTITY,random_pathfind).
initialize(target(ENTITY),random_point) :- 
    movementScheme(ENTITY,random_pathfind).
precondition(timerElapsed(change_target(ENTITY)), change_target(ENTITY)) :-
    movementScheme(ENTITY,random_pathfind).
    
% resource(ENTITY,target) :- movementScheme(ENTITY,random_pathfind).
result(change_target(ENTITY), set(target(ENTITY),random_point)) :- 
    movementScheme(ENTITY,random_pathfind).
result(tick,move_towards(ENTITY,target(ENTITY))) :- 
    movementScheme(ENTITY,random_pathfind). 


outcome(get_next_point(ENTITY)) :- 
    movementScheme(ENTITY,path(TYPE)).
precondition(overlaps(ENTITY,next_point,true), get_next_point(ENTITY)) :-
    movementScheme(ENTITY,path(TYPE)).
    
result(get_next_point(ENTITY), set(next_point,pop(waypoints))) :- 
    movementScheme(ENTITY,path(TYPE)).
% resource(ENTITY,waypoints) :- movementScheme(ENTITY,path(TYPE)). 
% resource(ENTITY,next_point) :- movementScheme(ENTITY,path(TYPE)). 
result(tick,move_towards(ENTITY,next_point)) :- 
    movementScheme(ENTITY,path(TYPE)). 
    
% Just have a single generic tick precondition/result pair       
outcome(tick) :- result(tick,ELSE).
precondition(tick,tick) :- outcome(tick).

%Entities can be attracted to things
attractions(ENTITY) :- entity(ENTITY).
attractions(cursor).
1 {attracted_to(ENTITY,OTHER) : attractions(OTHER) } :- 
    movementScheme(ENTITY,attract).
    
result(tick,move_towards(ENTITY,OTHER)) :- 
    movementScheme(ENTITY,attract), 
    attracted_to(ENTITY,OTHER). 
    
% Or repulsed
1 {repeled_by(ENTITY,OTHER) : attractions(OTHER) } :- movementScheme(ENTITY,repel).

result(tick,move_away(ENTITY,OTHER)) :- 
    movementScheme(ENTITY,repel),
    repeled_by(ENTITY,OTHER). 
       

% resource(ENTITY,target) :- movementScheme(ENTITY,patrol).
precondition(overlaps(ENTITY,target,true), next_target(ENTITY)) :-
    movementScheme(ENTITY,patrol).
result(next_target(ENTITY), set_next_patrol_point(ENTITY)) :-
    movementScheme(ENTITY,patrol).

%if you are patroling, you move to your target
result(tick,move_towards(ENTITY,target)) :-
    movementScheme(ENTITY,patrol).
    
%if you have gravity, you fall
%{physicsLogic(ENTITY,gravity) : entity(ENTITY)}.
physicsLogic(AVATAR,gravity) :- controlScheme(AVATAR,platformer).

result(tick,apply_force(ENTITY, south ,mid)) :-
    physicsLogic(ENTITY,gravity).
    
% bouncing
1 {bounceLogic(ENTITY1,ENTITY2) :entity(ENTITY2)} :-
    movementScheme(ENTITY1,bounce).

% can't bounce off yourself
:- bounceLogic(ENTITY1,ENTITY1).

%bounce when you hit the other thing - and reflect your velocity
precondition(overlaps(ENTITY1,ENTITY2,true),bounce(ENTITY1,ENTITY2)) :-
    bounceLogic(ENTITY1,ENTITY2).
result(bounce(ENTITY1,ENTITY2),
    reflect_velocity(ENTITY1,collision_normal(ENTITY1,ENTITY2))) :-
    bounceLogic(ENTITY1,ENTITY2).
    
outcome(OUTCOME) :- precondition(CONDITION,OUTCOME).
outcome(OUTCOME) :- result(OUTCOME,EFFECT).


%broad cultural things
interactions(help;collide;harm;help).

{interaction(ENTITY1,ENTITY2,INTERACTION) : interactions(INTERACTION)} 
    :-  entity(ENTITY1), 
        entity(ENTITY2).

%pushing
precondition(overlaps(ENTITY1,ENTITY2,true), push(ENTITY1,ENTITY2)) :-
    interaction(ENTITY1,ENTITY2,push).
result(push(ENTITY1,ENTITY2),apply_force(ENTITY2,direction_from(ENTITY1,ENTITY2))) :-
    interaction(ENTITY1,ENTITY2,push).


%colliding
1{
	precondition(collide(ENTITY1,ENTITY2), collide(ENTITY1,ENTITY2));
	precondition(collide(ENTITY2,ENTITY1), collide(ENTITY1,ENTITY2))} 1 :-
    interaction(ENTITY1,ENTITY2,collide).

precondition(overlaps(E1,E2,true),O) :- precondition(collide(E1,E2),O).
result(O,apply_restitution(E1,E2)) :- precondition(collide(E1,E2),O).

%entities can be static
{static(ENTITY) : entity(ENTITY)}.

%helping means adding a good resource, removing a bad one, or adding a good entity
1{
	precondition(overlaps(ENTITY1,ENTITY2,true), help(ENTITY1,ENTITY2));
	precondition(overlaps(ENTITY2,ENTITY1,true), help(ENTITY1,ENTITY2))} 1 :- 
    interaction(ENTITY1,ENTITY2,help).

%{ result(help(ENTITY1,ENTITY2),increase(G_RESOURCE)) } :-
%    interaction(ENTITY1,ENTITY2,help), good(G_RESOURCE).   

%{ result(help(ENTITY1,ENTITY2), decrease(B_RESOURCE)) } :-
%    interaction(ENTITY1,ENTITY2,help), bad(B_RESOURCE).

%{ result(help(ENTITY1,ENTITY2), increase(health(ENTITY2))) } :-
%    interaction(ENTITY1,ENTITY2,help).

% { result(help(ENTITY1,ENTITY2),spawn(ENTITY)) } :- interaction(ENTITY1,ENTITY2,help), helpful(ENTITY).


        

%helping means removing a good resource, adding a bad one, or adding a bad entity
%% 1{
%% 	precondition(overlaps(ENTITY1,ENTITY2,true), hurt(ENTITY1,ENTITY2));
%% 	precondition(overlaps(ENTITY2,ENTITY1,true), hurt(ENTITY1,ENTITY2))} 1 :- 
%%     interaction(ENTITY1,ENTITY2,hurt).


%% { result(hurt(ENTITY1,ENTITY2),increase(G_RESOURCE)) } :- interaction(ENTITY1,ENTITY2,hurt), bad(G_RESOURCE).   
%% { result(hurt(ENTITY1,ENTITY2),decrease(B_RESOURCE)) } :- interaction(ENTITY1,ENTITY2,hurt), good(B_RESOURCE).


%% { result(hurt(ENTITY1,ENTITY2), decrease(health(ENTITY2))) } :-
%%     interaction(ENTITY1,ENTITY2,hurt).
% { result(hurt(ENTITY1,ENTITY2),spawn(ENTITY)) } :- interaction(ENTITY1,ENTITY2,hurt), harmful(ENTITY).

%things need to be placed on the screen
placements(field(random);field(uniform);field(corner);path(center);path(random);path(endpoints);path(uniform);path(start)).

place(E) :- entity(E).
place(location(top,center)).
place(location(top,left)).
place(location(middle,right)).
place(location(middle,center)).
place(location(middle,left)).
place(location(bottom,right)).
place(location(bottom,center)).
place(location(bottom,left)).

placementModality(one_shot;spawn).

spawnTimings(one_shot;constant;exponential_increase;exponential_decay).
1 {placement(ENTITY,TYPE,MODE) : placements(TYPE), placementModality(MODE)} 1 :- entity(ENTITY), not screen(ENTITY).

validPathPlacement :- placement(ENTITY,TYPE,path(TYPE)), path(PATH,PTYPE).

% 1 {spawnLogic(ENTITY,TYPE,spawn,RATE) : spawnTimings(RATE)} 1 :- placement(ENTITY,TYPE,spawn).



movementProfiles(constant;linear;logarithmic;ease_in;ease_out;ease_in_out).

1 {movementLogic(ENTITY,PROFILE) : movementProfiles(PROFILE)} 1 :- entity(ENTITY), not static(ENTITY).

% {result(OUTCOME,spawn(ENTITY)) : potentialOutcomes(OUTCOME) }  1 :- spawnLogic(ENTITY,TYPE,MODE,condition).

%% Adding entities to the screen
%%%%%%%%% AJS REVISIT
%% 1 {initialize(add(Entity,Place)) : place(Place)} 1 :- entity(Entity).
%% 1 {initialize(set_sprite(Entity, Sprite)) : sprite(Sprite)} 1
%%     :- entity(Entity).

%% %%% RESOURCES %%%
%% initialResourceValues(R) :- constants(R).


%% 1 {initialize(set(RESOURCE,VALUE)) : initialResourceValues(VALUE)} 1 :- resource(RESOURCE).

resourceTransactions(convert;pay_cost;gain;lose).

{transaction(RESOURCE,TRANSACTION) : resourceTransactions(TRANSACTION)}  :-
    resource(RESOURCE).
% if something is converted it must decrease
1 {result(OUTCOME, decrease(RESOURCE)): potentialOutcomes(OUTCOME), potentialValues(AMOUNT) } 1 :- 
    transaction(RESOURCE,convert).
% and something else will increase
1 { result(OUTCOME,increase(RESOURCE2)) : resource(RESOURCE2), potentialValues(AMOUNT2) }:- 
    result(OUTCOME, decrease(RESOURCE)), 
    transaction(RESOURCE,convert).
 


% if something gets converted you must have that amount    
1 {precondition(ge(RESOURCE),OUTCOME) } 1 :- 
    result(OUTCOME, decrease(RESOURCE)), 
    transaction(RESOURCE,convert).
 

%PAY COST
1 {result(OUTCOME, decrease(RESOURCE)): potentialOutcomes(OUTCOME), potentialValues(AMOUNT) } :- 
    transaction(RESOURCE,pay_cost). 
1 {precondition(ge(RESOURCE),OUTCOME) } 1 :- 
    result(OUTCOME, decrease(RESOURCE)), 
    transaction(RESOURCE,pay_cost).



%LOSE
1 {result(OUTCOME, decrease(RESOURCE)): potentialOutcomes(OUTCOME), potentialValues(AMOUNT) } :- 
    transaction(RESOURCE,lose). 
1 {precondition(ge(RESOURCE),OUTCOME) } 1 :- 
    result(OUTCOME, decrease(RESOURCE)), 
    transaction(RESOURCE,lose).
    
    
%GAIN
1 {result(OUTCOME, increase(RESOURCE)): potentialOutcomes(OUTCOME), potentialValues(AMOUNT) } :- 
    transaction(RESOURCE,gain). 
    
{resourceLogic(RESOURCE,count(ENTITY)) : resource(RESOURCE), entity(ENTITY)}.

%things can increase and decrease with time
{result(tick,increase(RESOURCE)) : resource(RESOURCE), potentialValues(AMOUNT)}.
{result(tick,decrease(RESOURCE)) : resource(RESOURCE), potentialValues(AMOUNT)}.


%Need to think about these
% selectionType(single;double).
% {selection(ENTITY,TYPE) : entity(ENTITY), selectionType(TYPE)}.

% precondition(control_event(mouse_button,pressed),select(ENTITY,single)) :- 
    % selection(ENTITY,single).
% precondition(overlaps(cursor,ENTITY,true),select(ENTITY,single)) :- 
    % outcome(select(ENTITY,single)).
% 1 {result(outcome(select(ENTITY,TYPE)),move_to(ENTITY,POOL)) :pools(POOL)} 1 :- selection(ENTITY,TYPE).


% precondition(control_event(mouse_button,double_pressed),select(ENTITY,double)) :- 
    % selection(ENTITY,double).
% precondition(overlaps(cursor,ENTITY,true),select(ENTITY,double)) :- 
    % outcome(select(ENTITY,double)).
    

% precondition(control_event(mouse_button,pressed),preselect(ENTITY,single)) :- 
    % selection(ENTITY,single).
% result(preselect(ENTITY,single),create(ok_button)) :- 
    % selection(ENTITY,single).
% result(preselect(ENTITY,single),set(sub(ok_button,selection),ENTITY)) :- 
    % selection(ENTITY,single).


%%% Preconditions and Results for arbitrary outcomes %%%

% You can click on things to make things happen
{precondition(control_event(click(ENTITY)),OUTCOME)
  : entity(ENTITY), potentialOutcomes(OUTCOME)}.

% Or check resource values
{precondition(ge(RESOURCE),OUTCOME) 
  : resource(RESOURCE), potentialValues(VALUE)} :- not precondition(control_event(_),OUTCOME), potentialOutcomes(OUTCOME).

% {precondition(gt(RESOURCE),OUTCOME) 
%  : resource(RESOURCE), potentialValues(VALUE), potentialOutcomes(OUTCOME)}.

% {precondition(lt(RESOURCE),OUTCOME) 
%  : resource(RESOURCE), potentialValues(VALUE), potentialOutcomes(OUTCOME)}.

{precondition(le(RESOURCE),OUTCOME) 
  : resource(RESOURCE), potentialValues(VALUE)} :- not precondition(control_event(_),OUTCOME), potentialOutcomes(OUTCOME).

% XXX CRM 6/21: is this right?
% check property values
{precondition(check(Property, eq(Value)), Outcome)
  : result(Other, set(Property, Value)), 
    potentialOutcomes(Outcome),
    potentialOutcomes(Other)}.

% or look for button presses
{precondition(control_event(button(BUTTON,STATE)),OUTCOME) 
  : buttons(BUTTON),buttonStates(STATE), potentialOutcomes(OUTCOME)}.

% or see if things are overlapping
{precondition(overlaps(ENTITY1,ENTITY2,true),OUTCOME) : potentialOutcomes(OUTCOME)} 
  :- entity(ENTITY1), entity(ENTITY2), ENTITY1 != ENTITY2.

% or see if things aren't overlapping
{precondition(overlaps(ENTITY1,ENTITY2,false),OUTCOME) : potentialOutcomes(OUTCOME)} 
  :- entity(ENTITY1), entity(ENTITY2), ENTITY1 != ENTITY2.
% other spatial predicates
% AJS - 7/16 - Not a fan
%{precondition(near(E1, E2), Outcome) : potentialOutcomes(Outcome)}
%  :- entity(E1), entity(E2), E1 != E2.

%{precondition(far(E1, E2), Outcome) : potentialOutcomes(Outcome)}
%  :- entity(E1), entity(E2), E1 != E2.

% check presence/absece of entities
%%%NEED TO REEXAMINE THESE  - WEIRD STUFF XXX
% {precondition(present(E), Outcome) : potentialOutcomes(Outcome)}
  % :- singular(E).

% {precondition(absent(E), Outcome) : potentialOutcomes(Outcome)}
  % :- singular(E).

% check timer signals
% CRM 6/21/2016: not consistent with prior use of timers e.g. in
% Kaboom encoding and game-rules.lp
{precondition(timerElapsed(Timer), Outcome)
  : potentialOutcomes(Outcome)}
  :- potentialTimerLogic(Timer).

%%% Possible Results %%%

%entities can be deleted
{result(OUTCOME,delete(ENTITY)) : entity(ENTITY), potentialOutcomes(OUTCOME)}.
% or added to a location
0 {result(Outcome, add(Entity, Place)) : place(Place)} 1
:- entity(Entity), potentialOutcomes(Outcome).

% resources can increase
{result(OUTCOME,increase(RESOURCE)) 
  : potentialOutcomes(OUTCOME),resource(RESOURCE), potentialValues(VALUE)}.
% or decrease
{result(OUTCOME,decrease(RESOURCE)) 
  : potentialOutcomes(OUTCOME),resource(RESOURCE), potentialValues(VALUE)}.
  % XXX eventually make typed

% properties can be set
%% {result(Outcome, set(Property, Value))
%%  : potentialOutcomes(Outcome), potentialValues(Value)}.

% modes can change
% modes(M) :- potentialModes(M).
% XXX should reconcile this with "potentialModes" in generation_atoms.lp
modes(narrative_progress;narrative_gating;game_win;game_loss).

%% CRM 7/2/2016 trying to relax this constraint
% 1 {result(END_OUTCOME,mode_change(MODE)) : modes(MODE)} 
%  :- end_outcome(END_OUTCOME).
%   :- outcome(END_OUTCOME).

%% this works but is too lax
% {result(OUTCOME,mode_change(MODE))
%  : potentialOutcomes(OUTCOME), modes(MODE)}.

min_end_outcomes 
{result(OUTCOME,mode_change(MODE)) : modes(MODE), outcome(OUTCOME)}
max_end_outcomes.


% % say that the only reason why is a recource being above/below/collision
% {precondition(le(RESOURCE),OUTCOME) : resource(RESOURCE),potentialValues(VALUE)} :- result(OUTCOME,mode_change(MODE)).
% {precondition(ge(RESOURCE),OUTCOME) : resource(RESOURCE), potentialValues(VALUE)} :- result(OUTCOME,mode_change(MODE)).
% {precondition(overlaps(ENTITY1,ENTITY2,true),OUTCOME) : entity(ENTITY1),entity(ENTITY2)} :- result(OUTCOME,mode_change(MODE)).



perEntityCreationModes(spawns;shoots).

{creates(E1,E2,Mode) : perEntityCreationModes(Mode)} 1 :- entity(E1), entity(E2), E1 != E2.

1 {precondition(control_event(button(Button, State)),shoots(E1,E2)):buttons(Button),buttonStates(State) ;
   precondtion(timerElapsed(shoot(E1,E2)),shoots(E1,E2))} 1 :-
    1 {creates(E1,E2,_)}, entity(E1), entity(E2).

timerLogic(shoot(E1,E2)) :- precondtion(timerElapsed(shoot(E1,E2)),shoots(E1,E2)).

result(shoots(E1,E2),add(E1,E2)) :-  1 {creates(E1,E2,_)}, entity(E1), entity(E2).
result(shoots(E1,E2),set(angle(E1),angle(E2))) :-  creates(E1,E2,shoots).
result(tick,moves(E1,forward)) :- creates(E1,E2,shoots).


{ spawns(Entity) : entity(Entity)}.

1 { timerLogic(spawn(Entity,location(Row,Column)),Duration,loop) : duration(Duration),
    rows(Row),
    columns(Column)  } 1 :- spawns(Entity).
precondition(timerElapsed(spawn(Entity,location(Row,Column))),spawn(Entity,location(Row,Column))) :-  timerLogic(spawn(Entity,location(Row,Column)),Duration,loop).

 result(spawn(Entity,location(Row,Column)), add(Entity,location(Row,Column))) :-  timerLogic(spawn(Entity,location(Row,Column)),Duration,loop).

:- creates(shoots(E1,E2)),
   3 {result(O,moves(E1,_));
      result(O,move_towards(E1,_));
      result(O,move_away(E1,_));
      controlLogic(draggable(E1))}.

:- creates(shoots(E1,E2)),
   controlLogic(draggable(E1)).

:- result(O,add(E,_)), result(O,delete(E)).

:- precondition(overlaps(E1,E2,Polarity),_),
   result(_,add(E1,E2)).
:- precondition(overlaps(E2,E1,Polarity),_),
   result(_,add(E1,E2)).

%% :- not spawns(_).
