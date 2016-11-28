
entity(e1).
entity(e2).
entity(e3).
resource(r1).
many(e1).
many(e2).
many(e3).
goal(prevent(o2)).
goal(maintain(r1)).

timerLogic(change_direction(e2)).
static(e3).


initialize(set_sprite(e1,square)).
initialize(set_color(e1,green)).
initialize(set_color(e2,blue)).
initialize(set_sprite(e3,square)).

initialize(set(r1,10)).

initialize(add(e1,2,location(top,right))).
initialize(add(e1,2,location(bottom,right))).
initialize(add(e2,2,location(top,left))).
initialize(add(e2,2,location(bottom,left))).
initialize(add(e3,10,location(top,center))).
initialize(add(e3,10,location(bottom,center))).

precondition(control_event(button(mouse_button,held)),o3).
precondition(overlaps(e1,e2,true),o3).
result(o3,modify(increase,r1)).

precondition(timerElapsed(change_direction(e2)),change_direction(e2)).
result(change_direction(e2),rotate_to(e2,random_int(0,360))).

precondition(tick,tick).
result(tick,moves(e2,forward)).
result(tick,modify(decrease,r1)).

precondition(control_event(button(mouse_button,held)),o1).
precondition(overlaps(e1,e2,false),o1).
result(o1,modify(decrease,r1)).

precondition(control_event(button(mouse_button,held)),o4).
result(o4,move_towards(e1,cursor)).

precondition(compare(le,r1),o2).
result(o2,mode_change(game_loss)).

precondition(collide(e1,e1),collide(e1,e1)).
result(collide(e1,e1),apply_restitution(e1,e1)).
precondition(collide(e1,e2),collide(e1,e2)).
result(collide(e1,e2),apply_restitution(e1,e2)).
precondition(collide(e1,e3),collide(e1,e3)).
result(collide(e1,e3),apply_restitution(e1,e3)).
precondition(collide(e2,e2),collide(e2,e2)).
result(collide(e2,e2),apply_restitution(e2,e2)).
precondition(collide(e2,e3),collide(e2,e3)).
result(collide(e2,e3),apply_restitution(e2,e3)).
