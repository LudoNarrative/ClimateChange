entity(e_1_XX_)
entity(e_2_XX_)

resource(r_1_XX_)

many(entity(e_1_XX_)).
many(entity(e_2_XX_)).

initialize(add(entity(e_1_XX_),scalar(1),location(top,left))).
initialize(add(entity(e_1_XX_),scalar(1),location(middle,right))).
initialize(add(entity(e_1_XX_),scalar(1),location(bottom,center))).
initialize(add(entity(e_1_XX_),scalar(1),location(bottom,right))).
initialize(add(entity(e_2_XX_),scalar(3),location(middle,center))).
initialize(set_draggable(entity(e_1_XX_),true)).
initialize(set_sprite(entity(e_2_XX_),square)).
initialize(set_sprite(entity(e_1_XX_),triangle)).
initialize(set_color(entity(e_2_XX_),green)).
initialize(set_color(entity(e_1_XX_),cyan)).

controlLogic(draggable(entity(e_1_XX_))).

initialize(set_value(resource(r_1_XX_),scalar(9))).

precondition(control_event(button(mouse,held)),outcome(drawn_to_cursor_entity_e_2_XX__XX__XX_)).
precondition(le(resource(r_1_XX_),scalar(10)),outcome(drawn_to_cursor_entity_e_2_XX__XX__XX_)).
result(outcome(drawn_to_cursor_entity_e_2_XX__XX__XX_),move_towards(entity(e_2_XX_),cursor,scalar(1))).

precondition(le(resource(r_1_XX_),scalar(0)),outcome(o_1_XX_)).
result(outcome(o_1_XX_),mode_change(narrative_gating)).

precondition(overlaps(entity(e_1_XX_),entity(e_2_XX_),true),outcome(o_2_XX_)).
result(outcome(o_2_XX_),increase(resource(r_1_XX_),scalar(8))).
result(outcome(o_2_XX_),delete(entity(e_1_XX_))).

precondition(control_event(click(entity(e_2_XX_))),outcome(o_3_XX_)).
result(outcome(o_3_XX_),decrease(resource(r_1_XX_),scalar(2))).
result(outcome(o_3_XX_),add(entity(e_1_XX_),scalar(1),location(bottom,center))).

precondition(tick,tick).
result(tick,move_away(entity(e_1_XX_),cursor,scalar(4))).
result(tick,decrease_over_time(resource(r_1_XX_),scalar(3))).

reading(bad,tick).
reading(bad,outcome(o_3_XX_)).
reading(good,resource(r_1_XX_)).
reading(good,outcome(o_2_XX_)).
reading(sharing,relation(entity(e_1_XX_),entity(e_2_XX_))).
reading(maintenance,resource(r_1_XX_)).
reading(goal(produce),resource(r_1_XX_)).
reading(good,property(entity(e_1_XX_),health)).
reading(consumes,relation(entity(e_2_XX_),entity(e_1_XX_))).

The goal is to produce satiation

They will do this by
	attempting to make a friend and food touch

They will avoid
	clicking on a friend

The player controls the game by

	clicking-and-dragging foods
	the friend moves towards the cursor
	the food moves away from the cursor
