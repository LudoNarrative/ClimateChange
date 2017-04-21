entity(e_1_XX_)
entity(e_2_XX_)

resource(r_1_XX_)
resource(r_2_XX_)

many(entity(e_1_XX_)).
many(entity(e_2_XX_)).

initialize(add(entity(e_1_XX_),scalar(2),location(top,center))).
initialize(add(entity(e_1_XX_),scalar(2),location(top,right))).
initialize(add(entity(e_1_XX_),scalar(2),location(middle,center))).
initialize(add(entity(e_1_XX_),scalar(2),location(middle,right))).
initialize(add(entity(e_1_XX_),scalar(2),location(bottom,left))).
initialize(add(entity(e_2_XX_),scalar(1),location(top,right))).
initialize(add(entity(e_2_XX_),scalar(1),location(middle,left))).
initialize(add(entity(e_2_XX_),scalar(1),location(bottom,left))).
initialize(set_static(entity(e_2_XX_),true)).
initialize(set_sprite(entity(e_1_XX_),square)).
initialize(set_sprite(entity(e_2_XX_),square)).
initialize(set_color(entity(e_2_XX_),blue)).
initialize(set_color(entity(e_1_XX_),black)).
initialize(set_draggable(entity(e_1_XX_))).

initialize(set_value(resource(r_1_XX_),scalar(10))).
initialize(set_value(resource(r_2_XX_),scalar(1))).

precondition(control_event(button(mouse,held)),outcome(o_3_XX_)).
result(outcome(o_3_XX_),decrease_over_time(resource(r_1_XX_),scalar(2))).
result(outcome(o_3_XX_),increase_over_time(resource(r_2_XX_),scalar(3))).

precondition(le(resource(r_2_XX_),scalar(3)),outcome(o_4_XX_)).
precondition(overlaps(entity(e_1_XX_),entity(e_2_XX_),true),outcome(o_4_XX_)).
result(outcome(o_4_XX_),increase(resource(r_1_XX_),scalar(1))).
result(outcome(o_4_XX_),delete(entity(e_1_XX_))).

precondition(tick,tick).
result(tick,apply_restitution(entity(e_2_XX_),entity(e_2_XX_))).
result(tick,decrease_over_time(resource(r_2_XX_),scalar(10))).

precondition(control_event(click(entity(e_2_XX_))),outcome(o_1_XX_)).
result(outcome(o_1_XX_),add(entity(e_1_XX_),scalar(1),entity(e_2_XX_))).

precondition(le(resource(r_1_XX_),scalar(0)),outcome(o_2_XX_)).
result(outcome(o_2_XX_),mode_change(narrative_gating)).
