entity(e1).
entity(e2).

resource(r1).

many(e1).
many(e2).

initialize(add(e1,random)).
initialize(add(e2,random)).
initialize(set_sprite(e1,pentagon)).
initialize(set_sprite(e2,circle)).
initialize(set(r1,high)).

precondition(timerElapsed(t4),o3).
result(o3,decrease(r1,high)).

precondition(le(r1,high),o4).
precondition(control_event(click(e2)),o4).
result(o4,delete(e2)).
result(o4,add(e1,upper_right)).
result(o4,increase(r1,low)).

precondition(ge(r1,medium),o1).
precondition(control_event(click(e2)),o1).
result(o1,delete(e2)).
result(o1,decrease(r1,medium)).

precondition(ge(r1,low),o5).
precondition(control_event(click(e2)),o5).
result(o5,add(e1,upper_left)).
result(o5,add(e2,center)).
result(o5,decrease(r1,high)).

precondition(le(r1,0),o2).
precondition(control_event(click(e1)),o2).
result(o2,mode_change(narrative_progress)).

precondition(tick,tick).
result(tick,decrease(r1,low)).
