%% This example is supposed to be "easy" but it's actually impossible. r1 can never increase.
%% Entities e1 and e2 also never interact with resources r1 and r2.

entity(e1)
entity(e2)

resource(r1)
resource(r2)

many(e1)
many(e2)

initialize(set(r1,0))
initialize(set(r2,high))

goal(achieve(o4))
goal(gain(r1))

precondition(le(r2,0),o3)
result(o3,increase(r1,r2))

precondition(ge(r1,low),o4)
result(o4,mode_change(game_win))

precondition(overlaps(e1,e2,true),collide(e1,e2))
result(collide(e1,e2),apply_restitution(e1,e2))

precondition(le(r2,medium),o1)
result(o1,increase(r1,r2))

precondition(control_event(button(mouse_button,held)),repeled_from_cursor(e1))
result(repeled_from_cursor(e1),move_away(e1,cursor))

precondition(le(r2,low),o5)
result(o5,increase(r1,r2))

precondition(ge(r1,high),o2)
result(o2,decrease(r2,low))
