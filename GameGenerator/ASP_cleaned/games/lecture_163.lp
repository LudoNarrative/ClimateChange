label(entity(e_1_XX_),e1).
label(resource(r_1_XX_),stress).
label(entity(e_2_XX_),e(2)).
label(entity(e_3_XX_),e(3)).
label(resource(r_1_XX_),r(1),private).

entity(e_1_XX_).
entity(e_2_XX_).
entity(e_3_XX_).

resource(r_1_XX_).

many(entity(e_1_XX_)).
many(entity(e_2_XX_)).
many(entity(e_3_XX_)).

initialize(add(entity(e_1_XX_),scalar(1),location(top,center))).
initialize(add(entity(e_1_XX_),scalar(1),location(middle,left))).
initialize(add(entity(e_1_XX_),scalar(1),location(middle,right))).
initialize(add(entity(e_1_XX_),scalar(1),location(bottom,center))).
initialize(add(entity(e_2_XX_),scalar(1),location(middle,center))).
initialize(add(entity(e_3_XX_),scalar(1),location(top,left))).
initialize(add(entity(e_3_XX_),scalar(1),location(top,right))).
initialize(add(entity(e_3_XX_),scalar(1),location(bottom,left))).
initialize(add(entity(e_3_XX_),scalar(1),location(bottom,right))).
initialize(set_color(entity(e_1_XX_),red)).
initialize(set_sprite(entity(e_1_XX_),circle)).
initialize(set_sprite(entity(e_2_XX_),circle)).
initialize(set_sprite(entity(e_3_XX_),circle)).
initialize(set_color(entity(e_2_XX_),blue)).
initialize(set_color(entity(e_3_XX_),green)).

timer_logic(timer(patrol_entity_e_3_XX__XX__XX_),scalar(7),loop).
timer_logic(timer(pingpong_entity_e_3_XX__XX__XX_),scalar(5),loop).

initialize(set_value(resource(r_1_XX_),scalar(3))).

precondition(control_event(button(mouse,held)),outcome(drawn_to_cursor_entity_e_1_XX__XX__XX_)).
result(outcome(drawn_to_cursor_entity_e_1_XX__XX__XX_),look_at(entity(e_1_XX_),cursor,nearest)).
result(outcome(drawn_to_cursor_entity_e_1_XX__XX__XX_),moves(entity(e_1_XX_),forward,scalar(7))).

precondition(ge(resource(r_1_XX_),scalar(6)),outcome(o_1_XX_)).
result(outcome(o_1_XX_),mode_change(game_loss)).

precondition(overlaps(entity(e_1_XX_),entity(e_2_XX_),true),outcome(o_2_XX_)).
result(outcome(o_2_XX_),decrease(resource(r_1_XX_),scalar(12))).
result(outcome(o_2_XX_),add(entity(e_1_XX_),scalar(1),location(middle,left))).
result(outcome(o_2_XX_),delete(entity(e_1_XX_))).

precondition(overlaps(entity(e_1_XX_),entity(e_3_XX_),true),outcome(o_3_XX_)).
result(outcome(o_3_XX_),increase_over_time(property(entity(e_1_XX_),health),scalar(4))).
result(outcome(o_3_XX_),increase_over_time(property(entity(e_2_XX_),health),scalar(8))).

precondition(timer_elapsed(patrol_entity_e_3_XX__XX__XX_),outcome(patrol_entity_e_3_XX__XX__XX_)).
result(outcome(patrol_entity_e_3_XX__XX__XX_),rotates(entity(e_3_XX_),ccw,scalar(60))).
result(outcome(patrol_entity_e_3_XX__XX__XX_),decrease(property(entity(e_1_XX_),health),scalar(3))).
result(outcome(patrol_entity_e_3_XX__XX__XX_),increase(resource(r_1_XX_),scalar(1))).

precondition(timer_elapsed(pingpong_entity_e_3_XX__XX__XX_),outcome(pingpong_entity_e_3_XX__XX__XX_)).
result(outcome(pingpong_entity_e_3_XX__XX__XX_),rotates(entity(e_3_XX_),cw,scalar(180))).
result(outcome(pingpong_entity_e_3_XX__XX__XX_),increase(property(entity(e_2_XX_),health),scalar(9))).

precondition(tick,tick).
result(tick,apply_restitution(entity(e_1_XX_),entity(e_1_XX_))).
result(tick,apply_restitution(entity(e_2_XX_),entity(e_2_XX_))).
result(tick,apply_restitution(entity(e_3_XX_),entity(e_3_XX_))).
result(tick,moves(entity(e_3_XX_),forward,scalar(5))).
result(tick,moves(entity(e_2_XX_),backward,scalar(5))).
result(tick,look_at(entity(e_2_XX_),entity(e_3_XX_),random)).

reading(good,property(entity(e_1_XX_),health)).
reading(produces,relation(location(middle,left),entity(e_1_XX_))).
reading(consumes,relation(entity(e_1_XX_),resource(r_1_XX_))).
reading(consumes,relation(entity(e_2_XX_),resource(r_1_XX_))).
reading(goal(reduce),resource(r_1_XX_)).
reading(bad,resource(r_1_XX_)).
reading(bad,outcome(o_2_XX_)).
reading(bad,outcome(patrol_entity_e_3_XX__XX__XX_)).
reading(good,outcome(o_3_XX_)).
reading(good,outcome(o_2_XX_)).
reading(good,entity(e_1_XX_)).
reading(hand_eye_coordination,game).
reading(maintenance,resource(r_1_XX_)).
reading(tradeoff,outcome(o_2_XX_)).
reading(help,relation(entity(e_3_XX_),player)).
reading(stakes(low),resource(r_1_XX_)).
reading(outcome_helps,relation(outcome(o_3_XX_),property(entity(e_1_XX_),health))).
==========
<ul>
<li>The goal is to reduce r(1)</li>

<li>The player will do this by<ul>
<li>
attempting to make a [[green|circle]] and [[red|circle]] touch
</li>
</ul></li>
<li>The player controls the game by<ul>
<li>
	holding the mouse button
</li>
</ul></ul>
