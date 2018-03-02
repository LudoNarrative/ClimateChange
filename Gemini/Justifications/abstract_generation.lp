
#const max_resource_change_per = 4.
#const max_conditions_per = 4.



avatarControls(cardinal;horizontal_axis;vertical_axis;tank;platformer;asteroids).


indirectControls(click_and_drag;click_and_click;click_and_aim;drawn_to_cursor;repeled_from_cursor).


%%%%%% INITIALIZATIONS %%%%%%%

min_entities {entity(ENTITY) : potentialEntities(ENTITY)} max_entities.
min_resources {resource(RESOURCE) : potentialResources(RESOURCE)} max_resources.
min_outcomes {outcome(OUTCOME) : potentialOutcomes(OUTCOME)} max_outcomes.

{avatar(ENTITY): entity(ENTITY)} 1 .




1 {controlScheme(ENTITY,SCHEME) : avatarControls(SCHEME) } 1 :- avatar(ENTITY).



1 {controlScheme(ENTITY,SCHEME) : indirectControls(SCHEME)} :- entity(ENTITY).

outcome(avatar_move_up) :- 
    1 {controlScheme(ENTITY,cardinal); 
    controlScheme(ENTITY,vertical_axis)}.
outcome(avatar_move_left) :- 
    1 {controlScheme(ENTITY,cardinal); 
    controlScheme(ENTITY,horizontal_axis); 
    controlScheme(ENTITY,platformer)}.
    
outcome(avatar_jump) :-
    controlScheme(ENTITY,platformer).
    
outcome(avatar_move_right) :- 
    1 {controlScheme(ENTITY,cardinal); 
    controlScheme(ENTITY,horizontal_axis); 
    controlScheme(ENTITY,platformer)}.
outcome(avatar_move_down) :- 
    1 {controlScheme(ENTITY,cardinal); 
    controlScheme(ENTITY,vertical_axis)}.

precondition(control_event(up_arrow, held),avatar_move_up) :- 
    avatar(ENTITY), 
    outcome(avatar_move_up).
precondition(empty(ENTITY,up,low),avatar_move_up) :- 
    avatar(ENTITY), 
    outcome(avatar_move_up).
result(avatar_move_up,moves(ENTITY, up, low))  :- 
    avatar(ENTITY), 
    outcome(avatar_move_up).

precondition(control_event(down_arrow, held),avatar_move_down) :- 
    avatar(ENTITY), 
    outcome(avatar_move_down).
precondition(empty(ENTITY,down,low),avatar_move_down) :- 
    avatar(ENTITY), 
    outcome(avatar_move_down).
result(avatar_move_down,moves(ENTITY, down, low))  :- 
    avatar(ENTITY), 
    outcome(avatar_move_down).

precondition(control_event(right_arrow, held),avatar_move_right) :- 
    avatar(ENTITY), 
    outcome(avatar_move_right).
    
precondition(empty(ENTITY,right,low),avatar_move_right) :- 
    avatar(ENTITY), 
    outcome(avatar_move_right).
result(avatar_move_right,moves(ENTITY, right, low))  :- 
    avatar(ENTITY), 
    outcome(avatar_move_right).

precondition(control_event(left_arrow, held),avatar_move_left) :- 
    avatar(ENTITY), 
    outcome(avatar_move_left).
precondition(empty(ENTITY,left,low),avatar_move_left) :- 
    avatar(ENTITY), 
    outcome(avatar_move_left).
result(avatar_move_left,moves(ENTITY, left, low))  :- 
    avatar(ENTITY), outcome(avatar_move_left).

    

outcome(avatar_move_forward) :- 
    1 {controlScheme(ENTITY,tank); 
    controlScheme(ENTITY,asteroids)}.
    
outcome(avatar_move_backward) :- controlScheme(ENTITY,tank).
    
outcome(avatar_rotate_right) :- 
    1{controlScheme(ENTITY,tank); 
    controlScheme(ENTITY,asteroids)}.
outcome(avatar_rotate_left) :- 
    1{controlScheme(ENTITY,tank); 
    controlScheme(ENTITY,asteroids)}.
    

precondition(control_event(up_arrow, held),avatar_move_forward) :- 
    avatar(ENTITY), 
    outcome(avatar_move_forward).
precondition(empty(ENTITY,forward,low),avatar_move_forward) :- 
    avatar(ENTITY), 
    outcome(avatar_move_forward).
result(avatar_move_forward,moves(ENTITY, forward, low))  :- 
    avatar(ENTITY), 
    outcome(avatar_move_forward).

precondition(control_event(down_arrow, held),avatar_move_backward) :- 
    avatar(ENTITY), 
    outcome(avatar_move_backward).
precondition(empty(ENTITY,behind,low),avatar_move_backward) :- 
    avatar(ENTITY), 
    outcome(avatar_move_backward).
result(avatar_move_backward,moves(ENTITY, behind, low))  :- 
    avatar(ENTITY), 
    outcome(avatar_move_backward).
    
precondition(control_event(left_arrow, held),avatar_rotate_left) :- 
    avatar(ENTITY), 
    outcome(avatar_rotate_left).
result(avatar_rotate_left,rotates(ENTITY, ccw, low))  :- 
    avatar(ENTITY), 
    outcome(avatar_rotate_left).
    
precondition(control_event(right_arrow, held),avatar_rotate_right) :- 
    avatar(ENTITY), 
    outcome(avatar_rotate_right).
result(avatar_rotate_right,rotates(ENTITY, cw, low))  :- 
    avatar(ENTITY), 
    outcome(avatar_rotate_right).
    
precondition(control_event(up_arrow, pressed),avatar_jump) :- 
    avatar(ENTITY), 
    outcome(avatar_jump).
result(avatar_jump,moves(ENTITY, up, high))  :- 
    avatar(ENTITY), 
    outcome(avatar_jump).
    

outcome(click_and_drag(ENTITY)) :- controlScheme(ENTITY,click_and_drag).
outcome(drag(ENTITY)) :- controlScheme(ENTITY,click_and_drag).
outcome(end_drag(ENTITY)) :- controlScheme(ENTITY,click_and_drag).

outcome(click_and_click(ENTITY)) :- controlScheme(ENTITY,click_and_click).
outcome(click_and_aim(ENTITY)) :- controlScheme(ENTITY,click_and_aim). 
outcome(drawn_to_cursor(ENTITY)) :- controlScheme(ENTITY,drawn_to_cursor).
outcome(repeled_from_cursor(ENTITY)) :- controlScheme(ENTITY,repeled_from_cursor).      
   
precondition(control_event(mouse_button, pressed),click_and_drag(ENTITY)) :- 
    outcome(click_and_drag(ENTITY)).   
precondition(overlaps(cursor,ENTITY),click_and_drag(ENTITY)) :- 
    outcome(click_and_drag(ENTITY)).
result(click_and_drag(ENTITY), set(sub(ENTITY,dragged),true)) :- 
    outcome(click_and_drag(ENTITY)).

precondition(eq(sub(ENTITY,dragged),true),drag(ENTITY)) :-
     outcome(click_and_drag(ENTITY)).
result(drag(ENTITY), move_towards(ENTITY,cursor)):-
     outcome(click_and_drag(ENTITY)).    
    

precondition(control_event(mouse_button, released),end_drag(ENTITY)) :- 
    outcome(click_and_drag(ENTITY)). 
    
result(end_drag(ENTITY), set(sub(ENTITY,dragged),false)) :- 
    outcome(click_and_drag(ENTITY)).      
  

precondition(control_event(mouse_button, held),drawn_to_cursor(ENTITY)) :- 
    outcome(drawn_to_cursor(ENTITY)). 
result(drawn_to_cursor(ENTITY), move_towards(ENTITY,cursor)):-
    outcome(drawn_to_cursor(ENTITY)).


precondition(control_event(mouse_button, held),repeled_from_cursor(ENTITY)) :- 
    outcome(repeled_from_cursor(ENTITY)). 
result(repeled_from_cursor(ENTITY), move_away(ENTITY,cursor)):-
    outcome(repeled_from_cursor(ENTITY)).

   
precondition(control_event(mouse_button, pressed),select(ENTITY)) :- 
    outcome(select(ENTITY)).   
precondition(overlaps(cursor,ENTITY),select(ENTITY)) :- 
    outcome(select(ENTITY)).
result(select(ENTITY), set(sub(ENTITY,selected),true)) :- 
    outcome(select(ENTITY)). 
    
precondition(control_event(mouse_button, pressed),move_selected(ENTITY)) :- 
    outcome(move_selected(ENTITY)).   
precondition( eq(sub(ENTITY,selected),true),move_selected(ENTITY)) :- 
    outcome(move_selected(ENTITY)).
result(move_selected(ENTITY), set(sub(ENTITY,selected),false)) :- 
    outcome(move_selected(ENTITY)).     
result(move_selected(ENTITY), move_to(ENTITY,cursor)) :- 
    outcome(move_selected(ENTITY)). 
    
%%%%%%%%%% NPC   %%%%%%%%%%%%%%%%%%

npcMovements(projectile;random_walk;random_pathfind;attract;repel;patrol;bounce).

{movementScheme(ENTITY,SCHEME) : entity(ENTITY), npcMovements(SCHEME)}.

:- movementScheme(ENTITY,SCHEME),avatar(ENTITY).

1 {speed(ENTITY,AMOUNT) : constants(AMOUNT)} 1 :- 
    movementScheme(ENTITY,projectile).


result(tick,moves(ENTITY, forward, AMOUNT)) :- 
    movementScheme(ENTITY,projectile), speed(ENTITY,AMOUNT). 

    
outcome(change_direction(ENTITY)) :- 
    movementScheme(ENTITY,random_walk).
timerLogic(ENTITY,change_direction,duration) :- 
    movementScheme(ENTITY,random_walk).
precondition(timerElapsed(ENTITY,change_direction), change_direction(ENTITY)) :-
    movementScheme(ENTITY,random_walk).
result(change_direction(ENTITY), rotate(ENTITY,random_int(0,360))) :- 
    movementScheme(ENTITY,random_walk).
result(tick,moves(ENTITY, forward, low)) :- 
    movementScheme(ENTITY,random_walk). 

    
outcome(change_target(ENTITY)) :- 
    movementScheme(ENTITY,random_pathfind).
timerLogic(ENTITY,change_target,duration) :- 
    movementScheme(ENTITY,random_pathfind).
precondition(timerElapsed(ENTITY,change_target), change_target(ENTITY)) :-
    movementScheme(ENTITY,random_pathfind).
result(change_target(ENTITY), set(sub(ENTITY,target),random_point)) :- 
    movementScheme(ENTITY,random_pathfind).
result(tick,move_towards(ENTITY,sub(ENTITY,target))) :- 
    movementScheme(ENTITY,random_pathfind). 

outcome(tick) :- result(tick,ELSE).
precondition(tick,tick) :- outcome(tick).

attractions(ENTITY) :- entity(ENTITY).
attractions(cursor).
1 {attracted_to(ENTITY,OTHER) : attractions(OTHER) } :- 
    movementScheme(ENTITY,attract).
:- attracted_to(ENTITY,OTHER), ENTITY = OTHER .

result(tick,move_towards(ENTITY,OTHER)) :- 
    movementScheme(ENTITY,attract), 
    attracted_to(ENTITY,OTHER). 
    
    
1 {repeled_by(ENTITY,OTHER) : attractions(OTHER) } :- movementScheme(ENTITY,repel).
:- repeled_by(ENTITY,OTHER), ENTITY = OTHER .
:- attracted_to(ENTITY,OTHER), repeled_by(ENTITY,OTHER).
:- attracted_to(ENTITY,OTHER), repeled_by(OTHER,ENTITY).

result(tick,move_away(ENTITY,OTHER)) :- 
    movementScheme(ENTITY,repel),
    repeled_by(ENTITY,OTHER). 
       

precondition(overlaps(ENTITY,sub(ENTITY,target)), next_target(ENTITY)) :-
    movementScheme(ENTITY,patrol).
result(next_target(ENTITY), set_next_patrol_point(ENTITY)) :-
    movementScheme(ENTITY,patrol).
    
result(tick,move_to(ENTITY,sub(ENTITY,target))) :-
    movementScheme(ENTITY,patrol).
    

{physicsLogic(ENTITY,gravity) : entity(ENTITY)}  :- controlScheme(AVATAR,platformer).
physicsLogic(AVATAR,gravity) :- controlScheme(AVATAR,platformer).

result(tick,apply_force(ENTITY,down,middle)) :-
    physicsLogic(ENTITY,gravity).
    

1 {bounceLogic(ENTITY1,ENTITY2) : entity(ENTITY2)} :- movementScheme(ENTITY1,bounce).
:- bounceLogic(ENTITY1,ENTITY2), ENTITY1 = ENTITY2.

precondition(overlaps(ENTITY1,ENTITY2),bounce(ENTITY1,ENTITY2)) :-
    bounceLogic(ENTITY1,ENTITY2).
result(bounce(ENTITY1,ENTITY2),
    reflect_velocity(ENTITY1,collision_normal(ENTITY1,ENTITY2))) :-
    bounceLogic(ENTITY1,ENTITY2).
    
