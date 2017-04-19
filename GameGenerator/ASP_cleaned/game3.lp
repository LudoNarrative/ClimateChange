entity(e_1_XX_)
entity(e_2_XX_)

resource(r_1_XX_)


initialize(add(entity(e_1_XX_),scalar(1),location(top,left))).
initialize(add(entity(e_1_XX_),scalar(1),location(top,right))).
initialize(add(entity(e_1_XX_),scalar(1),location(middle,left))).
initialize(add(entity(e_1_XX_),scalar(1),location(middle,center))).
initialize(add(entity(e_1_XX_),scalar(1),location(bottom,left))).
initialize(add(entity(e_1_XX_),scalar(1),location(bottom,right))).
initialize(add(entity(e_2_XX_),scalar(1),location(top,center))).
initialize(add(entity(e_2_XX_),scalar(1),location(top,right))).
initialize(add(entity(e_2_XX_),scalar(1),location(bottom,left))).
initialize(set_static(entity(e_2_XX_),true)).
initialize(set_sprite(entity(e_2_XX_),square)).
initialize(set_sprite(entity(e_1_XX_),triangle)).
initialize(set_color(entity(e_1_XX_),blue)).
initialize(set_color(entity(e_2_XX_),cyan)).

initialize(set_value(resource(r_1_XX_),scalar(7))).

precondition(control_event(click(entity(e_2_XX_))),outcome(o_4_XX_)).
result(outcome(o_4_XX_),add(entity(e_1_XX_),scalar(1),location(bottom,left))).

precondition(tick,tick).
result(tick,move_away(entity(e_1_XX_),cursor,scalar(4))).

precondition(le(resource(r_1_XX_),scalar(6)),outcome(o_3_XX_)).
result(outcome(o_3_XX_),mode_change(narrative_gating)).

precondition(control_event(button(mouse_button,held)),outcome(repeled_from_cursor_entity_e_1_XX__XX__XX_)).
result(outcome(repeled_from_cursor_entity_e_1_XX__XX__XX_),move_away(entity(e_1_XX_),cursor,scalar(4))).
result(outcome(repeled_from_cursor_entity_e_1_XX__XX__XX_),decrease_over_time(resource(r_1_XX_),scalar(9))).

precondition(overlaps(entity(e_1_XX_),entity(e_2_XX_),true),outcome(o_1_XX_)).
result(outcome(o_1_XX_),increase(resource(r_1_XX_),scalar(10))).
result(outcome(o_1_XX_),delete(entity(e_1_XX_))).

precondition(ge(resource(r_1_XX_),scalar(3)),outcome(o_2_XX_)).
result(outcome(o_2_XX_),move_away(entity(e_1_XX_),cursor,scalar(4))).
