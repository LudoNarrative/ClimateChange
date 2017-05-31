entity(e_1_XX_)
entity(e_2_XX_)

resource(r_1_XX_)
resource(r_2_XX_)

many(entity(e_1_XX_)).
many(entity(e_2_XX_)).

initialize(set_draggable(entity(e_1_XX_),true)).
initialize(add(entity(e_1_XX_),scalar(1),location(top,center))).
initialize(add(entity(e_1_XX_),scalar(1),location(top,right))).
initialize(add(entity(e_1_XX_),scalar(1),location(middle,right))).
initialize(add(entity(e_1_XX_),scalar(1),location(bottom,left))).
initialize(add(entity(e_2_XX_),scalar(1),location(top,center))).
initialize(add(entity(e_2_XX_),scalar(1),location(top,right))).
initialize(add(entity(e_2_XX_),scalar(1),location(middle,left))).
initialize(add(entity(e_2_XX_),scalar(1),location(bottom,left))).
initialize(set_sprite(entity(e_1_XX_),square)).
initialize(set_sprite(entity(e_2_XX_),circle)).
initialize(set_color(entity(e_1_XX_),blue)).
initialize(set_color(entity(e_2_XX_),yellow)).

controlLogic(draggable(entity(e_1_XX_))).

initialize(set_value(resource(r_1_XX_),scalar(8))).
initialize(set_value(resource(r_2_XX_),scalar(2))).

precondition(control_event(button(mouse,held)),outcome(drawn_to_cursor_entity_e_2_XX__XX__XX_)).
result(outcome(drawn_to_cursor_entity_e_2_XX__XX__XX_),move_towards(entity(e_2_XX_),cursor,scalar(4))).
result(outcome(drawn_to_cursor_entity_e_2_XX__XX__XX_),move_towards(entity(e_2_XX_),entity(e_1_XX_),scalar(4))).
result(outcome(drawn_to_cursor_entity_e_2_XX__XX__XX_),increase_over_time(resource(r_1_XX_),scalar(2))).

precondition(overlaps(entity(e_1_XX_),entity(e_2_XX_),true),outcome(o_1_XX_)).
result(outcome(o_1_XX_),mode_change(game_win)).

precondition(le(resource(r_2_XX_),scalar(7)),outcome(o_2_XX_)).
result(outcome(o_2_XX_),move_away(entity(e_1_XX_),cursor,scalar(4))).

precondition(overlaps(entity(e_1_XX_),entity(e_1_XX_),false),outcome(o_3_XX_)).
result(outcome(o_3_XX_),decrease_over_time(resource(r_2_XX_),scalar(1))).
result(outcome(o_3_XX_),increase_over_time(resource(r_1_XX_),scalar(8))).

precondition(tick,tick).
result(tick,move_away(entity(e_1_XX_),entity(e_2_XX_),scalar(4))).
