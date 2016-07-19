entity(e1).
entity(e2).
entity(e3).

resource(r1).

many(e1).
many(e2).
many(e3).

initialize(add(e1,upper_left)).
initialize(add(e2,lower_left)).
initialize(add(e3,upper_right)).
initialize(set_sprite(e1,circle)).
initialize(set_sprite(e2,pentagon)).
initialize(set_sprite(e3,square)).
initialize(set(r1,medium)).

precondition(le(r1,0),o3).
precondition(control_event(click(e2)),o3).
result(o3,add(e1,upper_left)).
result(o3,add(e2,random)).
result(o3,add(e3,center)).
result(o3,increase(r1,medium)).

precondition(control_event(click(e1)),o4).
result(o4,delete(e1)).
result(o4,add(e2,upper_left)).
result(o4,add(e3,lower_left)).
result(o4,decrease(r1,medium)).

precondition(ge(r1,high),o1).
precondition(control_event(click(e2)),o1).
result(o1,delete(e2)).
result(o1,add(e1,lower_right)).
result(o1,add(e3,center)).
result(o1,decrease(r1,medium)).

precondition(timerElapsed(change_direction(e1)),change_direction(e1)).
result(change_direction(e1),rotate(e1,random_int(0,360))).

precondition(le(r1,low),o5).
precondition(control_event(click(e2)),o5).
result(o5,mode_change(narrative_progress)).

precondition(control_event(click(e3)),o2).
result(o2,delete(e3)).
result(o2,add(e1,upper_right)).
result(o2,add(e2,upper_left)).
result(o2,decrease(r1,high)).

precondition(tick,tick).
result(tick,moves(e1,forward,low)).
result(tick,moves(e3,forward,high)).
result(tick,apply_force(e1,south,mid)).
result(tick,apply_force(e2,south,mid)).
result(tick,decrease(r1,low)).
