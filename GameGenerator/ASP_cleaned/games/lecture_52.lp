label(entity(e_1_XX_),e1).
label(resource(r_1_XX_),stress).
label(entity(e_2_XX_),e(2)).
label(entity(e_3_XX_),e(3)).
label(resource(r_1_XX_),r(1),private).
label(resource(r_2_XX_),r(2),private).

entity(e_1_XX_).
entity(e_2_XX_).
entity(e_3_XX_).

resource(r_1_XX_).
resource(r_2_XX_).

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

initialize(set_value(resource(r_1_XX_),scalar(3))).
initialize(set_value(resource(r_2_XX_),scalar(4))).

precondition(control_event(click(entity(e_1_XX_))),outcome(click_to_spin_entity_e_1_XX__XX__XX_)).
result(outcome(click_to_spin_entity_e_1_XX__XX__XX_),add(entity(e_3_XX_),scalar(1),location(bottom,left))).
result(outcome(click_to_spin_entity_e_1_XX__XX__XX_),delete(entity(e_1_XX_))).
result(outcome(click_to_spin_entity_e_1_XX__XX__XX_),rotates(entity(e_1_XX_),ccw,scalar(45))).

precondition(control_event(button(mouse,held)),outcome(click_to_spin_entity_e_2_XX__XX__XX_)).
result(outcome(click_to_spin_entity_e_2_XX__XX__XX_),increase_over_time(property(entity(e_2_XX_),health),scalar(2))).
result(outcome(click_to_spin_entity_e_2_XX__XX__XX_),decrease_over_time(resource(r_2_XX_),scalar(1))).
result(outcome(click_to_spin_entity_e_2_XX__XX__XX_),rotate_to(entity(e_2_XX_),random_int(0,360))).

precondition(control_event(click(entity(e_2_XX_))),outcome(o_1_XX_)).
result(outcome(o_1_XX_),decrease(property(entity(e_1_XX_),health),scalar(1))).

precondition(overlaps(entity(e_2_XX_),entity(e_3_XX_),true),outcome(o_2_XX_)).
precondition(ge(resource(r_2_XX_),scalar(3)),outcome(o_2_XX_)).
result(outcome(o_2_XX_),decrease(property(entity(e_1_XX_),health),scalar(4))).
result(outcome(o_2_XX_),decrease(resource(r_1_XX_),scalar(12))).
result(outcome(o_2_XX_),delete(entity(e_3_XX_))).

precondition(ge(resource(r_1_XX_),scalar(16)),outcome(o_3_XX_)).
result(outcome(o_3_XX_),mode_change(game_loss)).

precondition(timer_elapsed(patrol_entity_e_3_XX__XX__XX_),outcome(patrol_entity_e_3_XX__XX__XX_)).
result(outcome(patrol_entity_e_3_XX__XX__XX_),rotates(entity(e_3_XX_),ccw,scalar(60))).
result(outcome(patrol_entity_e_3_XX__XX__XX_),increase(resource(r_1_XX_),scalar(1))).
result(outcome(patrol_entity_e_3_XX__XX__XX_),add(entity(e_1_XX_),scalar(1),location(middle,left))).

precondition(tick,tick).
result(tick,apply_restitution(entity(e_1_XX_),entity(e_1_XX_))).
result(tick,apply_restitution(entity(e_2_XX_),entity(e_2_XX_))).
result(tick,apply_restitution(entity(e_3_XX_),entity(e_3_XX_))).
result(tick,moves(entity(e_1_XX_),forward,scalar(7))).
result(tick,moves(entity(e_2_XX_),forward,scalar(7))).
result(tick,moves(entity(e_3_XX_),forward,scalar(5))).
result(tick,increase_over_time(resource(r_2_XX_),scalar(1))).
result(tick,moves(entity(e_3_XX_),left,scalar(5))).
result(tick,look_at(entity(e_3_XX_),entity(e_1_XX_),random)).

reading(produces,relation(location(middle,left),entity(e_1_XX_))).
reading(consumes,relation(entity(e_2_XX_),resource(r_1_XX_))).
reading(consumes,relation(entity(e_3_XX_),property(entity(e_1_XX_),health))).
reading(goal(reduce),resource(r_1_XX_)).
reading(bad,resource(r_1_XX_)).
reading(bad,outcome(patrol_entity_e_3_XX__XX__XX_)).
reading(good,outcome(o_2_XX_)).
reading(good,entity(e_2_XX_)).
reading(hand_eye_coordination,game).
reading(maintenance,resource(r_1_XX_)).
reading(help,relation(entity(e_3_XX_),player)).
reading(stakes(low),resource(r_1_XX_)).
reading(stakes(low),resource(r_2_XX_)).
reading(grinding,property(entity(e_2_XX_),health)).
==========
<ul>
<li>The goal is to reduce r(1)</li>

<li>The player will do this by<ul>
<li>
attempting to make a [[green|circle]] and [[blue|circle]] touch
	 at the same time as
compare(ge,resource(r(2)))
</li>
</ul></li>
<li>The player controls the game by<ul>
<li>
	clicking on a [[red|circle]]
</li>
<li>
	clicking on a [[blue|circle]]
</li>
<li>
	holding the mouse button
</li>
</ul></ul>
