entity(e_1_XX_)
entity(e_2_XX_)

resource(r_1_XX_)

many(entity(e_1_XX_)).
many(entity(e_2_XX_)).

initialize(add(entity(e_1_XX_),scalar(1),location(top,right))).
initialize(add(entity(e_1_XX_),scalar(1),location(middle,center))).
initialize(add(entity(e_1_XX_),scalar(1),location(bottom,left))).
initialize(add(entity(e_2_XX_),scalar(1),location(top,left))).
initialize(add(entity(e_2_XX_),scalar(1),location(bottom,center))).
initialize(add(entity(e_2_XX_),scalar(1),location(bottom,right))).
initialize(set_static(entity(e_2_XX_),true)).
initialize(set_sprite(entity(e_1_XX_),circle)).
initialize(set_sprite(entity(e_2_XX_),circle)).
initialize(set_color(entity(e_2_XX_),yellow)).
initialize(set_color(entity(e_1_XX_),white)).

initialize(set_value(resource(r_1_XX_),scalar(10))).

precondition(le(resource(r_1_XX_),scalar(2)),outcome(o_3_XX_)).
result(outcome(o_3_XX_),mode_change(narrative_gating)).

precondition(tick,tick).
result(tick,move_towards(entity(e_1_XX_),entity(e_2_XX_),scalar(1))).
result(tick,decrease_over_time(resource(r_1_XX_),scalar(3))).

precondition(control_event(click(entity(e_2_XX_))),outcome(o_1_XX_)).
result(outcome(o_1_XX_),add(entity(e_1_XX_),scalar(1),location(bottom,left))).

precondition(overlaps(entity(e_1_XX_),entity(e_2_XX_),true),outcome(o_2_XX_)).
result(outcome(o_2_XX_),increase(resource(r_1_XX_),scalar(5))).
result(outcome(o_2_XX_),delete(entity(e_1_XX_))).

