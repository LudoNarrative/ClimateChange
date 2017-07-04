label(entity(e_1_XX_),food).
label(entity(e_2_XX_),friend).
label(resource(r_1_XX_),satiation,write).
label(resource(r_1_XX_),r(1)).
label(resource(r_2_XX_),r(2)).

entity(e_1_XX_).
entity(e_2_XX_).

resource(r_1_XX_).
resource(r_2_XX_).

many(entity(e_1_XX_)).
many(entity(e_2_XX_)).

initialize(add(entity(e_1_XX_),scalar(1),location(bottom,left))).
initialize(add(entity(e_1_XX_),scalar(1),location(top,center))).
initialize(add(entity(e_1_XX_),scalar(1),location(bottom,right))).
initialize(add(entity(e_2_XX_),scalar(1),location(top,left))).
initialize(add(entity(e_2_XX_),scalar(1),location(bottom,center))).
initialize(add(entity(e_2_XX_),scalar(1),location(top,right))).
initialize(set_color(entity(e_1_XX_),red)).
initialize(set_sprite(entity(e_1_XX_),circle)).
initialize(set_sprite(entity(e_2_XX_),circle)).
initialize(set_color(entity(e_2_XX_),blue)).

timer_logic(timer(t_1_XX_),scalar(5),loop).
timer_logic(timer(t_2_XX_),scalar(5),loop).
timer_logic(timer(pingpong_entity_e_2_XX__XX__XX_),scalar(5),loop).

initialize(set_value(resource(r_1_XX_),scalar(7))).
initialize(set_value(resource(r_2_XX_),scalar(6))).

precondition(control_event(button(mouse,held)),outcome(click_to_spin_entity_e_1_XX__XX__XX_)).
result(outcome(click_to_spin_entity_e_1_XX__XX__XX_),rotate_to(entity(e_1_XX_),random_int(0,360))).

precondition(timer_elapsed(t_1_XX_),outcome(o_1_XX_)).
result(outcome(o_1_XX_),increase(property(entity(e_1_XX_),health),scalar(8))).

precondition(control_event(click(entity(e_1_XX_))),outcome(o_2_XX_)).
result(outcome(o_2_XX_),increase(resource(r_2_XX_),scalar(1))).

precondition(le(resource(r_1_XX_),scalar(4)),outcome(o_3_XX_)).
result(outcome(o_3_XX_),mode_change(narrative_gating)).

precondition(ge(resource(r_2_XX_),scalar(8)),outcome(o_4_XX_)).
precondition(overlaps(entity(e_1_XX_),entity(e_2_XX_),true),outcome(o_4_XX_)).
result(outcome(o_4_XX_),increase(resource(r_1_XX_),scalar(4))).
result(outcome(o_4_XX_),add(entity(e_1_XX_),scalar(1),location(top,center))).
result(outcome(o_4_XX_),delete(entity(e_1_XX_))).

precondition(timer_elapsed(t_2_XX_),outcome(o_5_XX_)).
result(outcome(o_5_XX_),decrease(resource(r_2_XX_),scalar(1))).

precondition(timer_elapsed(pingpong_entity_e_2_XX__XX__XX_),outcome(pingpong_entity_e_2_XX__XX__XX_)).
result(outcome(pingpong_entity_e_2_XX__XX__XX_),rotates(entity(e_2_XX_),cw,scalar(180))).
result(outcome(pingpong_entity_e_2_XX__XX__XX_),decrease(resource(r_2_XX_),scalar(10))).
result(outcome(pingpong_entity_e_2_XX__XX__XX_),add(entity(e_1_XX_),scalar(1),location(top,right))).

precondition(tick,tick).
result(tick,apply_restitution(entity(e_1_XX_),entity(e_1_XX_))).
result(tick,apply_restitution(entity(e_1_XX_),entity(e_2_XX_))).
result(tick,apply_restitution(entity(e_2_XX_),entity(e_2_XX_))).
result(tick,moves(entity(e_1_XX_),forward,scalar(7))).
result(tick,moves(entity(e_2_XX_),forward,scalar(3))).
result(tick,decrease_over_time(resource(r_1_XX_),scalar(1))).
result(tick,increase_over_time(resource(r_2_XX_),scalar(1))).

reading(goal(produce),resource(r_1_XX_)).
reading(good,resource(r_1_XX_)).
reading(produces,relation(entity(e_1_XX_),resource(r_1_XX_))).
reading(consumes,relation(entity(e_2_XX_),entity(e_1_XX_))).
reading(bad,tick).
reading(good,outcome(o_4_XX_)).
reading(sharing,relation(entity(e_1_XX_),entity(e_2_XX_))).
reading(maintenance,resource(r_1_XX_)).
reading(help,relation(entity(e_2_XX_),player)).
reading(hand_eye_coordination,game).
reading(stakes(low),resource(r_2_XX_)).
==========
<ul>
<li>The goal is to produce r(1)</li>

<li>The player will do this by<ul>
<li>
compare(ge,resource(r(2)))
	 at the same time as
attempting to make a [[blue|circle]] and [[red|circle]] touch
</li>
</ul></li>
<li>The player controls the game by<ul>
<li>
	clicking on a [[red|circle]]
</li>
<li>
	holding the mouse button
</li>
</ul></ul>
