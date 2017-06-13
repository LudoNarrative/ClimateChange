label(resource(r_1_XX_),composure).
label(resource(r_2_XX_),tension).
label(entity(e_1_XX_),yourself).
label(entity(e_2_XX_),help).
label(entity(e_3_XX_),harm).
label(resource(r_3_XX_),r(3)).

entity(e_1_XX_).
entity(e_2_XX_).
entity(e_3_XX_).

resource(r_1_XX_).
resource(r_2_XX_).
resource(r_3_XX_).

singular(entity(e_1_XX_)).

many(entity(e_2_XX_)).
many(entity(e_3_XX_)).

initialize(add(entity(e_1_XX_),scalar(1),location(middle,center))).
initialize(add(entity(e_2_XX_),scalar(1),location(top,left))).
initialize(add(entity(e_2_XX_),scalar(1),location(top,right))).
initialize(add(entity(e_2_XX_),scalar(1),location(bottom,center))).
initialize(add(entity(e_3_XX_),scalar(1),location(top,center))).
initialize(add(entity(e_3_XX_),scalar(1),location(bottom,left))).
initialize(add(entity(e_3_XX_),scalar(1),location(bottom,right))).
initialize(set_color(entity(e_1_XX_),red)).
initialize(set_sprite(entity(e_1_XX_),circle)).
initialize(set_sprite(entity(e_2_XX_),circle)).
initialize(set_sprite(entity(e_3_XX_),circle)).
initialize(set_color(entity(e_2_XX_),blue)).
initialize(set_color(entity(e_3_XX_),green)).

timer_logic(timer(t_1_XX_),scalar(4),loop).

initialize(set_value(resource(r_1_XX_),scalar(4))).
initialize(set_value(resource(r_2_XX_),scalar(3))).
initialize(set_value(resource(r_3_XX_),scalar(6))).

precondition(control_event(button(mouse,pressed)),outcome(click_to_chase_entity_e_1_XX__XX__XX_)).
result(outcome(click_to_chase_entity_e_1_XX__XX__XX_),look_at(entity(e_1_XX_),entity(e_3_XX_),furthest)).

precondition(overlaps(entity(e_1_XX_),entity(e_2_XX_),true),outcome(o_1_XX_)).
precondition(ge(resource(r_3_XX_),scalar(1)),outcome(o_1_XX_)).
result(outcome(o_1_XX_),decrease_over_time(property(entity(e_1_XX_),health),scalar(3))).
result(outcome(o_1_XX_),decrease_over_time(property(entity(e_2_XX_),health),scalar(5))).
result(outcome(o_1_XX_),increase_over_time(resource(r_1_XX_),scalar(1))).

precondition(overlaps(entity(e_1_XX_),entity(e_3_XX_),true),outcome(o_2_XX_)).
precondition(ge(resource(r_1_XX_),scalar(5)),outcome(o_2_XX_)).
result(outcome(o_2_XX_),mode_change(narrative_progress)).

precondition(timer_elapsed(t_1_XX_),outcome(o_3_XX_)).
result(outcome(o_3_XX_),decrease(property(entity(e_3_XX_),health),scalar(2))).
result(outcome(o_3_XX_),decrease(resource(r_1_XX_),scalar(3))).
result(outcome(o_3_XX_),increase(resource(r_3_XX_),scalar(1))).

precondition(overlaps(entity(e_1_XX_),entity(e_3_XX_),false),outcome(o_4_XX_)).
precondition(ge(resource(r_3_XX_),scalar(0)),outcome(o_4_XX_)).
result(outcome(o_4_XX_),decrease_over_time(property(entity(e_1_XX_),health),scalar(6))).

precondition(overlaps(entity(e_1_XX_),entity(e_3_XX_),false),outcome(o_5_XX_)).
precondition(ge(resource(r_1_XX_),scalar(0)),outcome(o_5_XX_)).
result(outcome(o_5_XX_),decrease_over_time(property(entity(e_1_XX_),health),scalar(2))).

precondition(tick,tick).
result(tick,apply_restitution(entity(e_2_XX_),entity(e_2_XX_))).
result(tick,apply_restitution(entity(e_1_XX_),entity(e_1_XX_))).
result(tick,apply_restitution(entity(e_3_XX_),entity(e_3_XX_))).
result(tick,moves(entity(e_1_XX_),forward,scalar(4))).
result(tick,moves(entity(e_2_XX_),forward,scalar(4))).
result(tick,moves(entity(e_3_XX_),forward,scalar(4))).
result(tick,moves(entity(e_2_XX_),backward,scalar(4))).
result(tick,moves(entity(e_3_XX_),backward,scalar(4))).
result(tick,look_at(entity(e_3_XX_),entity(e_1_XX_),nearest)).
result(tick,look_at(entity(e_2_XX_),entity(e_1_XX_),nearest)).

reading(goal(produce),resource(r_1_XX_)).
reading(good,resource(r_1_XX_)).
reading(good,property(entity(e_1_XX_),health)).
reading(bad,outcome(o_5_XX_)).
reading(bad,outcome(o_4_XX_)).
reading(bad,outcome(o_3_XX_)).
reading(bad,outcome(o_1_XX_)).
reading(good,outcome(o_1_XX_)).
reading(maintenance,resource(r_1_XX_)).
reading(hurt,relation(entity(e_3_XX_),player)).
reading(hurt,relation(entity(e_1_XX_),entity(e_2_XX_))).
reading(dodge,entity(e_3_XX_)).
reading(survive,entity(e_3_XX_)).
reading(help,relation(entity(e_2_XX_),player)).
reading(tradeoff,outcome(o_1_XX_)).
reading(stakes(low),resource(r_2_XX_)).
reading(stakes(low),resource(r_3_XX_)).
==========
<ul>
<li>The goal is to produce composure</li>
<li>The player will avoid<ul>
<li>
	attempting to keep a [[green|circle]] and [[red|circle]] from touching
	 at the same time as
compare(ge,resource(r(1)))
</li>
<li>
	attempting to keep a [[green|circle]] and [[red|circle]] from touching
	 at the same time as
compare(ge,resource(r(3)))
</li>
</ul>
<li>The player controls the game by<ul>
<li>
	pressing the mouse button
</li>
</ul></ul>
