

%modes of avatar control
avatarControls(cardinal;horizontal_axis;vertical_axis;tank;platformer;asteroids).

%modes of indirect control
indirectControls(click_and_drag;click_and_click;click_and_aim;drawn_to_cursor;repeled_from_cursor).


%%%%%% INITIALIZATIONS %%%%%%%

min_entities {entity(ENTITY) : potentialEntities(ENTITY)} max_entities.
min_resources {resource(RESOURCE) : potentialResources(RESOURCE)} max_resources.
min_outcomes {outcome(OUTCOME) : potentialOutcomes(OUTCOME)} max_outcomes.
min_end_outcomes {end_outcome(OUTCOME) : potentialEndOutcomes(OUTCOME)} max_end_outcomes.

%pick at most 1 entity to be an avatar
{avatar(ENTITY): entity(ENTITY)} 1 .

%an entity should either be singular or many
1 {singular(ENTITY); many(ENTITY)} 1 :- entity(ENTITY).

%avatar requires controls
1 {controlScheme(ENTITY,SCHEME) : avatarControls(SCHEME) } 1 :- avatar(ENTITY).

% maybe pick some controls
{controlScheme(ENTITY,SCHEME) : indirectControls(SCHEME)} :- entity(ENTITY).

%vertical axis
outcome(avatar_move_up) :- 
    1 {controlScheme(ENTITY,cardinal); 
    controlScheme(ENTITY,vertical_axis)}.
outcome(avatar_move_down) :- 
    1 {controlScheme(ENTITY,cardinal); 
    controlScheme(ENTITY,vertical_axis)}.
%need to move left if horizontal axis
outcome(avatar_move_left) :- 
    1 {controlScheme(ENTITY,cardinal); 
    controlScheme(ENTITY,horizontal_axis); 
    controlScheme(ENTITY,platformer)}.
%platformers need jumping   
outcome(avatar_jump) :-
    controlScheme(ENTITY,platformer).
%need to move right if horizontal  
outcome(avatar_move_right) :- 
    1 {controlScheme(ENTITY,cardinal); 
    controlScheme(ENTITY,horizontal_axis); 
    controlScheme(ENTITY,platformer)}.

%moving up
precondition(control_event(up_arrow, held),avatar_move_up) :- 
    avatar(ENTITY), 
    outcome(avatar_move_up).
precondition(empty(ENTITY,up,low),avatar_move_up) :- 
    avatar(ENTITY), 
    outcome(avatar_move_up).
result(avatar_move_up,moves(ENTITY, up, low))  :- 
    avatar(ENTITY), 
    outcome(avatar_move_up).
%moving down
precondition(control_event(down_arrow, held),avatar_move_down) :- 
    avatar(ENTITY), 
    outcome(avatar_move_down).
precondition(empty(ENTITY,down,low),avatar_move_down) :- 
    avatar(ENTITY), 
    outcome(avatar_move_down).
result(avatar_move_down,moves(ENTITY, down, low))  :- 
    avatar(ENTITY), 
    outcome(avatar_move_down).
%moving right
precondition(control_event(right_arrow, held),avatar_move_right) :- 
    avatar(ENTITY), 
    outcome(avatar_move_right).
precondition(empty(ENTITY,right,low),avatar_move_right) :- 
    avatar(ENTITY), 
    outcome(avatar_move_right).
result(avatar_move_right,moves(ENTITY, right, low))  :- 
    avatar(ENTITY), 
    outcome(avatar_move_right).
%moving left
precondition(control_event(left_arrow, held),avatar_move_left) :- 
    avatar(ENTITY), 
    outcome(avatar_move_left).
precondition(empty(ENTITY,left,low),avatar_move_left) :- 
    avatar(ENTITY), 
    outcome(avatar_move_left).
result(avatar_move_left,moves(ENTITY, left, low))  :- 
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
precondition(control_event(up_arrow, held),avatar_move_forward) :- 
    avatar(ENTITY), 
    outcome(avatar_move_forward).
precondition(empty(ENTITY,forward,low),avatar_move_forward) :- 
    avatar(ENTITY), 
    outcome(avatar_move_forward).
result(avatar_move_forward,moves(ENTITY, forward, low))  :- 
    avatar(ENTITY), 
    outcome(avatar_move_forward).
%moving backwards
precondition(control_event(down_arrow, held),avatar_move_backward) :- 
    avatar(ENTITY), 
    outcome(avatar_move_backward).
precondition(empty(ENTITY,behind,low),avatar_move_backward) :- 
    avatar(ENTITY), 
    outcome(avatar_move_backward).
result(avatar_move_backward,moves(ENTITY, behind, low))  :- 
    avatar(ENTITY), 
    outcome(avatar_move_backward).
%rotate counter clockwise
precondition(control_event(left_arrow, held),avatar_rotate_left) :- 
    avatar(ENTITY), 
    outcome(avatar_rotate_left).
result(avatar_rotate_left,rotates(ENTITY, ccw, low))  :- 
    avatar(ENTITY), 
    outcome(avatar_rotate_left).
%rotate clockwise
precondition(control_event(right_arrow, held),avatar_rotate_right) :- 
    avatar(ENTITY), 
    outcome(avatar_rotate_right).
result(avatar_rotate_right,rotates(ENTITY, cw, low))  :- 
    avatar(ENTITY), 
    outcome(avatar_rotate_right).

%everybody jump, jump
precondition(control_event(up_arrow, pressed),avatar_jump) :- 
    avatar(ENTITY), 
    outcome(avatar_jump).
result(avatar_jump,moves(ENTITY, up, high))  :- 
    avatar(ENTITY), 
    outcome(avatar_jump).

%INDIRECT CONTROLS
outcome(click_and_drag(ENTITY)) :- controlScheme(ENTITY,click_and_drag).
outcome(drag(ENTITY)) :- controlScheme(ENTITY,click_and_drag).
outcome(end_drag(ENTITY)) :- controlScheme(ENTITY,click_and_drag).

outcome(click_and_click(ENTITY)) :- controlScheme(ENTITY,click_and_click).
outcome(click_and_aim(ENTITY)) :- controlScheme(ENTITY,click_and_aim). 
outcome(drawn_to_cursor(ENTITY)) :- controlScheme(ENTITY,drawn_to_cursor).
outcome(repeled_from_cursor(ENTITY)) :- controlScheme(ENTITY,repeled_from_cursor).      
   
%clicking and dragging
%mouse goes down + overlaps, it sets the thing to being dragged
precondition(control_event(mouse_button, pressed),click_and_drag(ENTITY)) :- 
    outcome(click_and_drag(ENTITY)).   
precondition(overlaps(cursor,ENTITY,true),click_and_drag(ENTITY)) :- 
    outcome(click_and_drag(ENTITY)).
resource(ENTITY,dragged) :- 
    outcome(click_and_drag(ENTITY)).
result(click_and_drag(ENTITY), set(dragged,true)) :- 
    outcome(click_and_drag(ENTITY)).
%when something is dragged - it follows the mouse
resource(ENTITY,dragged) :- 
    outcome(click_and_drag(ENTITY)).
precondition(eq(dragged,true),drag(ENTITY)) :-
     outcome(click_and_drag(ENTITY)).
result(drag(ENTITY), move_towards(ENTITY,cursor)):-
     outcome(click_and_drag(ENTITY)).    
%mouse being released causes dragging to end
precondition(control_event(mouse_button, released),end_drag(ENTITY)) :- 
    outcome(click_and_drag(ENTITY)).     
result(end_drag(ENTITY), set(dragged,false)) :- 
    outcome(click_and_drag(ENTITY)).      
  
%cursor is electromagnet
precondition(control_event(mouse_button, held),drawn_to_cursor(ENTITY)) :- 
    outcome(drawn_to_cursor(ENTITY)). 
result(drawn_to_cursor(ENTITY), move_towards(ENTITY,cursor)):-
    outcome(drawn_to_cursor(ENTITY)).

%cursor is opposite polarity (well, same polarity) electromagnet
precondition(control_event(mouse_button, held),repeled_from_cursor(ENTITY)) :- 
    outcome(repeled_from_cursor(ENTITY)). 
result(repeled_from_cursor(ENTITY), move_away(ENTITY,cursor)):-
    outcome(repeled_from_cursor(ENTITY)).

%click on something, then move it
%simplest version, click on something
precondition(control_event(mouse_button, pressed),select(ENTITY)) :- 
    outcome(select(ENTITY)).   
precondition(overlaps(cursor,ENTITY,true),select(ENTITY)) :- 
    outcome(select(ENTITY)).
resource(ENTITY,selected) :- 
    outcome(select(ENTITY)). 
resource(ENTITY,target) :- 
    outcome(select(ENTITY)). 
result(select(ENTITY), set(selected,true)) :- 
    outcome(select(ENTITY)). 

%if selected, choose where to go to
precondition(control_event(mouse_button, pressed),move_selected(ENTITY)) :- 
    outcome(move_selected(ENTITY)).   
precondition( eq(selected,true),move_selected(ENTITY)) :- 
    outcome(move_selected(ENTITY)).
resource(ENTITY,selected) :- 
    outcome(move_selected(ENTITY)). 
result(move_selected(ENTITY), set(selected,false)) :- 
    outcome(move_selected(ENTITY)).     
result(move_selected(ENTITY), set(target,cursor)) :- 
    outcome(move_selected(ENTITY)). 
result(tick,move_towards(ENTITY,target)) :- 
    outcome(move_selected(ENTITY)). 
precondition(tick,tick) :- 
    outcome(move_selected(ENTITY)). 
%%%%%%%%%% NPC   %%%%%%%%%%%%%%%%%%

%npcs can move in a couple of ways
npcMovements(projectile;random_walk;random_pathfind;attract;repel;patrol;bounce;path(ping_pong);path(loop)).

%pick ways something can move
{movementScheme(ENTITY,SCHEME) : entity(ENTITY), npcMovements(SCHEME)}.


%path shapes
path_shapes(horizontal;vertical;circle;racetrack;star;spoke;polygon(3);polygon(4);polygon(5);arc(upper);arc(lower)).

%if a path exists, it needs a shape
{path(PATH,TYPE): path_shapes(TYPE), potential_paths(PATH)}.

%if an entity follows a path, it picks a way to be initialized on the path
1 {initialize(set(path(ENTITY)),path(PATH)) : path(PATH,PATH_TYPE)} 1 :- movementScheme(ENTITY,path(TYPE)).

%pick a speed for a projectile
1 {speed(ENTITY,AMOUNT) : constants(AMOUNT)} 1 :- 
    movementScheme(ENTITY,projectile).
%projectiles go straight
result(tick,moves(ENTITY, forward, AMOUNT)) :- 
    movementScheme(ENTITY,projectile), speed(ENTITY,AMOUNT). 

%Random walkers walk in a given direction for a given amount of time    
outcome(change_direction(ENTITY)) :- 
    movementScheme(ENTITY,random_walk).
timerLogic(ENTITY,change_direction,duration) :- 
    movementScheme(ENTITY,random_walk).
%time's up - change direction
precondition(timerElapsed(ENTITY,change_direction), change_direction(ENTITY)) :-
    movementScheme(ENTITY,random_walk).
result(change_direction(ENTITY), rotate(ENTITY,random_int(0,360))) :- 
    movementScheme(ENTITY,random_walk).
%normally, just walk forwards ?slowly?
result(tick,moves(ENTITY, forward, low)) :- 
    movementScheme(ENTITY,random_walk). 

%random pathfinder - changes target every once in a while
outcome(change_target(ENTITY)) :- 
    movementScheme(ENTITY,random_pathfind).
timerLogic(ENTITY,change_target,duration) :- 
    movementScheme(ENTITY,random_pathfind).
precondition(timerElapsed(ENTITY,change_target), change_target(ENTITY)) :-
    movementScheme(ENTITY,random_pathfind).
    
resource(ENTITY,target) :- movementScheme(ENTITY,random_pathfind).
result(change_target(ENTITY), set(target,random_point)) :- 
    movementScheme(ENTITY,random_pathfind).
result(tick,move_towards(ENTITY,target)) :- 
    movementScheme(ENTITY,random_pathfind). 


outcome(get_next_point(ENTITY)) :- 
    movementScheme(ENTITY,path(TYPE)).
precondition(overlaps(ENTITY,next_point,true), get_next_point(ENTITY)) :-
    movementScheme(ENTITY,path(TYPE)).
    
result(get_next_point(ENTITY), set(next_point,pop(waypoints))) :- 
    movementScheme(ENTITY,path(TYPE)).
resource(ENTITY,waypoints) :- movementScheme(ENTITY,path(TYPE)). 
resource(ENTITY,next_point) :- movementScheme(ENTITY,path(TYPE)). 
result(tick,move_towards(ENTITY,next_point)) :- 
    movementScheme(ENTITY,path(TYPE)). 
    
    
    
outcome(tick) :- result(tick,ELSE).
precondition(tick,tick) :- outcome(tick).

attractions(ENTITY) :- entity(ENTITY).
attractions(cursor).
1 {attracted_to(ENTITY,OTHER) : attractions(OTHER) } :- 
    movementScheme(ENTITY,attract).
    

result(tick,move_towards(ENTITY,OTHER)) :- 
    movementScheme(ENTITY,attract), 
    attracted_to(ENTITY,OTHER). 
    
    
1 {repeled_by(ENTITY,OTHER) : attractions(OTHER) } :- movementScheme(ENTITY,repel).


result(tick,move_away(ENTITY,OTHER)) :- 
    movementScheme(ENTITY,repel),
    repeled_by(ENTITY,OTHER). 
       

resource(ENTITY,target) :- movementScheme(ENTITY,patrol).
precondition(overlaps(ENTITY,target,true), next_target(ENTITY)) :-
    movementScheme(ENTITY,patrol).
result(next_target(ENTITY), set_next_patrol_point(ENTITY)) :-
    movementScheme(ENTITY,patrol).
    
result(tick,move_to(ENTITY,target)) :-
    movementScheme(ENTITY,patrol).
    

{physicsLogic(ENTITY,gravity) : entity(ENTITY)}  :- controlScheme(AVATAR,platformer).
physicsLogic(AVATAR,gravity) :- controlScheme(AVATAR,platformer).

result(tick,apply_force(ENTITY,down,middle)) :-
    physicsLogic(ENTITY,gravity).
    

1 {bounceLogic(ENTITY1,ENTITY2) : entity(ENTITY2)} :- movementScheme(ENTITY1,bounce).
:- bounceLogic(ENTITY1,ENTITY2), ENTITY1 = ENTITY2.

precondition(overlaps(ENTITY1,ENTITY2,true),bounce(ENTITY1,ENTITY2)) :-
    bounceLogic(ENTITY1,ENTITY2).
result(bounce(ENTITY1,ENTITY2),
    reflect_velocity(ENTITY1,collision_normal(ENTITY1,ENTITY2))) :-
    bounceLogic(ENTITY1,ENTITY2).
    
outcome(OUTCOME) :- precondition(CONDITION,OUTCOME).
outcome(OUTCOME) :- result(OUTCOME,EFFECT).

interactions(help;collide;harm;help).

1 {interaction(ENTITY1,ENTITY2,INTERACTION) : interactions(INTERACTION)} 
    :-  entity(ENTITY1), 
        entity(ENTITY2), 
        ENTITY1 != ENTITY2 .
        
precondition(overlaps(ENTITY1,ENTITY2,true), push(ENTITY1,ENTITY2)) :- interaction(ENTITY1,ENTITY2,push).
result(push(ENTITY1,ENTITY2),apply_force(ENTITY2,direction_from(ENTITY1,ENTITY2))) :- interaction(ENTITY1,ENTITY2,push).




precondition(overlaps(ENTITY1,ENTITY2,true), collide(ENTITY1,ENTITY2)) :- 
    interaction(ENTITY1,ENTITY2,collide).
result(collide(ENTITY1,ENTITY2),apply_restitution(ENTITY1,ENTITY2)) :- 
    interaction(ENTITY1,ENTITY2,collide).

{static(ENTITY) : entity(ENTITY)}.


precondition(overlaps(ENTITY1,ENTITY2,true), help(ENTITY1,ENTITY2)) :- 
    interaction(ENTITY1,ENTITY2,help).
{ result(help(ENTITY1,ENTITY2),increases(G_RESOURCE)) } :- interaction(ENTITY1,ENTITY2,help), good(G_RESOURCE).   
{ result(help(ENTITY1,ENTITY2),decreases(B_RESOURCE)) } :- interaction(ENTITY1,ENTITY2,help), bad(B_RESOURCE).     
{ result(help(ENTITY1,ENTITY2),spawn(ENTITY)) } :- interaction(ENTITY1,ENTITY2,help), helpful(ENTITY).


        

precondition(overlaps(ENTITY1,ENTITY2,true), hurt(ENTITY1,ENTITY2)) :- 
    interaction(ENTITY1,ENTITY2,hurt).
{ result(hurt(ENTITY1,ENTITY2),increases(G_RESOURCE)) } :- interaction(ENTITY1,ENTITY2,hurt), bad(G_RESOURCE).   
{ result(hurt(ENTITY1,ENTITY2),decreases(B_RESOURCE)) } :- interaction(ENTITY1,ENTITY2,hurt), good(B_RESOURCE).     
{ result(hurt(ENTITY1,ENTITY2),spawn(ENTITY)) } :- interaction(ENTITY1,ENTITY2,hurt), harmful(ENTITY).


placements(field(random);field(uniform);field(corner);path(center);path(random);path(endpoints);path(uniform);path(start)).
placementModality(one_shot;spawn).

1 {placement(ENTITY,TYPE,MODE) : placements(TYPE), placementModality(MODE)} 1 :- entity(ENTITY).

validPathPlacement :- placement(ENTITY,TYPE,path(TYPE)), path(PATH,PTYPE).

1 {spawnLogic(ENTITY,TYPE,spawn,RATE) : spawnTimings(RATE)} 1 :- placement(ENTITY,TYPE,spawn).




movementProfiles(constant;logarithmic;ease_in;ease_out;ease_in_out;teleport).

1 {movementLogic(ENTITY,PROFILE) : movementProfiles(PROFILE)} 1 :- entity(ENTITY), not static(ENTITY).

1 {result(OUTCOME,spawn(ENTITY)) : potentialOutcomes(OUTCOME) } :- spawnLogic(ENTITY,TYPE,MODE,condition).


%%% RESOURCES %%%
initialResourceValues(0;low;medium;high).


1 {initialize(set(RESOURCE,VALUE)) : initialResourceValues(VALUE)} 1 :- resource(RESOURCE).

resourceTransactions(convert;pay_cost;gain;lose).

{transaction(RESOURCE,TRANSACTION) : resourceTransactions(TRANSACTION)} :-
    resource(RESOURCE).

1 {result(OUTCOME, decreases(RESOURCE,AMOUNT)): potentialOutcomes(OUTCOME), potentialValues(AMOUNT) } :- 
    transaction(RESOURCE,convert).


1 { result(OUTCOME,increases(RESOURCE2,AMOUNT2)) : resource(RESOURCE2), potentialValues(AMOUNT2) }:- 
    result(OUTCOME, decreases(RESOURCE,AMOUNT)), 
    transaction(RESOURCE,convert).
 


    
1 {precondition(gt(RESOURCE,AMOUNT),OUTCOME);precondition(ge(RESOURCE,AMOUNT),OUTCOME) } 1 :- 
    result(OUTCOME, decreases(RESOURCE,AMOUNT)), 
    transaction(RESOURCE,convert).
 

%PAY COST
1 {result(OUTCOME, decreases(RESOURCE,AMOUNT)): potentialOutcomes(OUTCOME), potentialValues(AMOUNT) } :- 
    transaction(RESOURCE,pay_cost). 
1 {precondition(gt(RESOURCE,AMOUNT),OUTCOME);precondition(ge(RESOURCE,AMOUNT),OUTCOME) } 1 :- 
    result(OUTCOME, decreases(RESOURCE,AMOUNT)), 
    transaction(RESOURCE,pay_cost).



%LOSE
1 {result(OUTCOME, decreases(RESOURCE,AMOUNT)): potentialOutcomes(OUTCOME), potentialValues(AMOUNT) } :- 
    transaction(RESOURCE,lose). 
1 {precondition(gt(RESOURCE,AMOUNT),OUTCOME);precondition(ge(RESOURCE,AMOUNT),OUTCOME) } 1 :- 
    result(OUTCOME, decreases(RESOURCE,AMOUNT)), 
    transaction(RESOURCE,lose).
    
    
%GAIN
1 {result(OUTCOME, increases(RESOURCE,AMOUNT)): potentialOutcomes(OUTCOME), potentialValues(AMOUNT) } :- 
    transaction(RESOURCE,gain). 
    
{resourceLogic(RESOURCE,count(ENTITY)) : resource(RESOURCE), entity(ENTITY)}.



    
{result(tick,increases(RESOURCE,AMOUNT)) : resource(RESOURCE), potentialValues(AMOUNT)}.
{result(tick,decreases(RESOURCE,AMOUNT)) : resource(RESOURCE), potentialValues(AMOUNT)}.

pools(inventory).
selectionType(single;double).
{selection(ENTITY,TYPE) : entity(ENTITY), selectionType(TYPE)}.

precondition(control_event(mouse_button,pressed),select(ENTITY,single)) :- 
    selection(ENTITY,single).
precondition(overlaps(cursor,ENTITY,true),select(ENTITY,single)) :- 
    outcome(select(ENTITY,single)).
1 {result(outcome(select(ENTITY,TYPE)),move_to(ENTITY,POOL)) :pools(POOL)} 1 :- selection(ENTITY,TYPE).


precondition(control_event(mouse_button,double_pressed),select(ENTITY,double)) :- 
    selection(ENTITY,double).
precondition(overlaps(cursor,ENTITY,true),select(ENTITY,double)) :- 
    outcome(select(ENTITY,double)).
    

% precondition(control_event(mouse_button,pressed),preselect(ENTITY,single)) :- 
    % selection(ENTITY,single).
% result(preselect(ENTITY,single),create(ok_button)) :- 
    % selection(ENTITY,single).
% result(preselect(ENTITY,single),set(sub(ok_button,selection),ENTITY)) :- 
    % selection(ENTITY,single).

{precondition(ge(RESOURCE,VALUE),OUTCOME) : resource(RESOURCE), potentialValues(VALUE), potentialOutcomes(OUTCOME)}.
{precondition(gt(RESOURCE,VALUE),OUTCOME) : resource(RESOURCE), potentialValues(VALUE), potentialOutcomes(OUTCOME)}.
{precondition(lt(RESOURCE,VALUE),OUTCOME) : resource(RESOURCE), potentialValues(VALUE), potentialOutcomes(OUTCOME)}.
{precondition(le(RESOURCE,VALUE),OUTCOME) : resource(RESOURCE), potentialValues(VALUE), potentialOutcomes(OUTCOME)}.

{precondition(control_event(BUTTON,STATE),OUTCOME) : buttons(BUTTON),buttonStates(STATE), potentialOutcomes(OUTCOME)}.

{precondition(overlaps(ENTITY1,ENTITY2,true),OUTCOME) :potentialOutcomes(OUTCOME)} :- 
    entity(ENTITY1),
    entity(ENTITY2).


{result(OUTCOME,delete(ENTITY)) : entity(ENTITY), potentialOutcomes(OUTCOME)}.
{result(OUTCOME,add(ENTITY)) : entity(ENTITY), potentialOutcomes(OUTCOME)}.
{result(OUTCOME,increases(RESOURCE,VALUE)) : potentialOutcomes(OUTCOME),resource(RESOURCE), potentialValues(VALUE)}.
{result(OUTCOME,decreases(RESOURCE,VALUE)) : potentialOutcomes(OUTCOME),resource(RESOURCE), potentialValues(VALUE)}.


modes(narrative_progress;game_win;game_loss;game_over).
1 {result(END_OUTCOME,mode_change(MODE)) : modes(MODE)} 1 :- 
    end_outcome(END_OUTCOME).

{precondition(le(RESOURCE,VALUE),OUTCOME) : resource(RESOURCE),potentialValues(VALUE)} :- result(OUTCOME,mode_change(MODE)).

{precondition(ge(RESOURCE,VALUE),OUTCOME,potentialValues(VALUE)) : resource(RESOURCE), potentialValues(VALUE)} :- result(OUTCOME,mode_change(MODE)).



{precondition(overlaps(ENTITY1,ENTITY2,true),OUTCOME) : entity(ENTITY1),entity(ENTITY2)} :- result(OUTCOME,mode_change(MODE)).
