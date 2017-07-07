label(entity(e_1_XX_),e1).
label(resource(r_1_XX_),concentration).
label(entity(e_2_XX_),e(2)).
label(entity(e_3_XX_),e(3)).
label(resource(r_1_XX_),r(1),private).
label(resource(r_2_XX_),r(2),private).

entity(e_1_XX_).
entity(e_2_XX_).
entity(e_3_XX_).

resource(r_1_XX_).
resource(r_2_XX_).

singular(entity(e_3_XX_)).

many(entity(e_1_XX_)).
many(entity(e_2_XX_)).

initialize(add(entity(e_1_XX_),scalar(1),location(top,left))).
initialize(add(entity(e_1_XX_),scalar(1),location(top,right))).
initialize(add(entity(e_1_XX_),scalar(1),location(bottom,center))).
initialize(add(entity(e_2_XX_),scalar(1),location(top,center))).
initialize(add(entity(e_2_XX_),scalar(1),location(bottom,left))).
initialize(add(entity(e_2_XX_),scalar(1),location(bottom,right))).
initialize(add(entity(e_3_XX_),scalar(1),location(middle,center))).
initialize(set_color(entity(e_1_XX_),red)).
initialize(set_sprite(entity(e_1_XX_),circle)).
initialize(set_sprite(entity(e_2_XX_),circle)).
initialize(set_sprite(entity(e_3_XX_),circle)).
initialize(set_color(entity(e_2_XX_),blue)).
initialize(set_color(entity(e_3_XX_),green)).

timer_logic(timer(patrol_entity_e_3_XX__XX__XX_),scalar(7),loop).

initialize(set_value(resource(r_1_XX_),scalar(7))).
initialize(set_value(resource(r_2_XX_),scalar(5))).

precondition(control_event(click(entity(e_1_XX_))),outcome(click_to_spin_entity_e_1_XX__XX__XX_)).
result(outcome(click_to_spin_entity_e_1_XX__XX__XX_),decrease(resource(r_2_XX_),scalar(8))).
result(outcome(click_to_spin_entity_e_1_XX__XX__XX_),delete(entity(e_1_XX_))).
result(outcome(click_to_spin_entity_e_1_XX__XX__XX_),rotates(entity(e_1_XX_),ccw,scalar(45))).

precondition(control_event(button(mouse,held)),outcome(drawn_to_cursor_entity_e_2_XX__XX__XX_)).
result(outcome(drawn_to_cursor_entity_e_2_XX__XX__XX_),look_at(entity(e_2_XX_),cursor,nearest)).
result(outcome(drawn_to_cursor_entity_e_2_XX__XX__XX_),moves(entity(e_2_XX_),forward,scalar(7))).

precondition(le(resource(r_1_XX_),scalar(1)),outcome(o_1_XX_)).
result(outcome(o_1_XX_),mode_change(game_loss)).

precondition(overlaps(entity(e_2_XX_),entity(e_3_XX_),true),outcome(o_2_XX_)).
precondition(le(resource(r_2_XX_),scalar(4)),outcome(o_2_XX_)).
result(outcome(o_2_XX_),decrease_over_time(property(entity(e_1_XX_),health),scalar(2))).
result(outcome(o_2_XX_),increase_over_time(resource(r_1_XX_),scalar(4))).

precondition(timer_elapsed(patrol_entity_e_3_XX__XX__XX_),outcome(patrol_entity_e_3_XX__XX__XX_)).
result(outcome(patrol_entity_e_3_XX__XX__XX_),rotates(entity(e_3_XX_),ccw,scalar(60))).
result(outcome(patrol_entity_e_3_XX__XX__XX_),decrease(resource(r_1_XX_),scalar(1))).
result(outcome(patrol_entity_e_3_XX__XX__XX_),add(entity(e_1_XX_),scalar(1),location(top,left))).

precondition(tick,tick).
result(tick,apply_restitution(entity(e_1_XX_),entity(e_1_XX_))).
result(tick,apply_restitution(entity(e_2_XX_),entity(e_2_XX_))).
result(tick,apply_restitution(entity(e_3_XX_),entity(e_3_XX_))).
result(tick,moves(entity(e_1_XX_),forward,scalar(7))).
result(tick,moves(entity(e_3_XX_),forward,scalar(5))).
result(tick,decrease_over_time(resource(r_1_XX_),scalar(1))).
result(tick,moves(entity(e_3_XX_),left,scalar(5))).
result(tick,look_at(entity(e_3_XX_),entity(e_1_XX_),random)).

reading(goal(produce),resource(r_1_XX_)).
reading(good,resource(r_1_XX_)).
reading(good,property(entity(e_1_XX_),health)).
reading(produces,relation(entity(e_2_XX_),resource(r_1_XX_))).
reading(produces,relation(entity(e_3_XX_),resource(r_1_XX_))).
reading(bad,tick).
reading(bad,outcome(o_2_XX_)).
reading(bad,outcome(patrol_entity_e_3_XX__XX__XX_)).
reading(good,outcome(o_2_XX_)).
reading(hand_eye_coordination,game).
reading(maintenance,resource(r_1_XX_)).
reading(tradeoff,outcome(o_2_XX_)).
reading(consts,relation(entity(e_1_XX_),resource(r_1_XX_))).
reading(grinding,resource(r_2_XX_)).
==========
<ul>
<li>The goal is to produce r(1)</li>
<li>The player controls the game by<ul>
<li>
	clicking on a [[red|circle]]
</li>
<li>
	holding the mouse button
</li>
</ul></ul>
