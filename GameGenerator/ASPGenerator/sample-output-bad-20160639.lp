%% Based on dinner-design-intent.lp

entity(e1).
entity(e2).

resource(r1).

singular(e1).

many(e2).

initialize(set(r1,low)).

precondition(control_event(button(mouse_button,held)),drawn_to_cursor(e2)).
result(drawn_to_cursor(e2),move_towards(e2,cursor)).

precondition(control_event(button(mouse_button,held)),drawn_to_cursor(e1)).
result(drawn_to_cursor(e1),move_towards(e1,cursor)).

precondition(tick,tick).
result(tick,decrease(r1,low)).
result(tick,move_towards(e1,e2)).
result(tick,move_away(e2,cursor)).

precondition(le(r1,0),o1).
precondition(control_event(click(e1)),o1).
result(o1,increase(r1,r1)).

precondition(overlaps(e1,e2,true),eo4).
precondition(le(r1,0),eo4).
result(eo4,mode_change(narrative_progress)).
