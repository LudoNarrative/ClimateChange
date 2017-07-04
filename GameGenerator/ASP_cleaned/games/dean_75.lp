label(resource(r_1_XX_),composure).
label(resource(r_2_XX_),tension).
label(entity(e_1_XX_),yourself).
label(entity(e_2_XX_),help).
label(entity(e_3_XX_),harm).
label(resource(r_1_XX_),r(1),private).
label(resource(r_2_XX_),r(2),private).

entity(e_1_XX_).
entity(e_2_XX_).
entity(e_3_XX_).

resource(r_1_XX_).
resource(r_2_XX_).

singular(entity(e_1_XX_)).

many(entity(e_2_XX_)).
many(entity(e_3_XX_)).

initialize(add(entity(e_1_XX_),scalar(1),location(middle,center))).
initialize(add(entity(e_2_XX_),scalar(1),location(top,center))).
initialize(add(entity(e_2_XX_),scalar(1),location(middle,left))).
initialize(add(entity(e_2_XX_),scalar(1),location(middle,right))).
initialize(add(entity(e_2_XX_),scalar(1),location(bottom,center))).
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

timer_logic(timer(t_1_XX_),scalar(7),loop).

initialize(set_value(resource(r_1_XX_),scalar(1))).
initialize(set_value(resource(r_2_XX_),scalar(10))).

precondition(control_event(button(mouse,held)),outcome(click_to_spin_entity_e_1_XX__XX__XX_)).
result(outcome(click_to_spin_entity_e_1_XX__XX__XX_),rotate_to(entity(e_1_XX_),random_int(0,360))).

precondition(overlaps(entity(e_1_XX_),entity(e_2_XX_),true),outcome(o_1_XX_)).
result(outcome(o_1_XX_),increase_over_time(property(entity(e_1_XX_),health),scalar(7))).
result(outcome(o_1_XX_),increase_over_time(resource(r_1_XX_),scalar(4))).

precondition(overlaps(entity(e_1_XX_),entity(e_3_XX_),true),outcome(o_2_XX_)).
precondition(ge(resource(r_1_XX_),scalar(36)),outcome(o_2_XX_)).
result(outcome(o_2_XX_),mode_change(narrative_progress)).

precondition(timer_elapsed(t_1_XX_),outcome(o_3_XX_)).
result(outcome(o_3_XX_),increase(property(entity(e_3_XX_),health),scalar(7))).

precondition(control_event(button(mouse,pressed)),outcome(o_4_XX_)).
result(outcome(o_4_XX_),increase(property(entity(e_3_XX_),health),scalar(1))).

precondition(overlaps(entity(e_1_XX_),entity(e_3_XX_),true),outcome(o_5_XX_)).
result(outcome(o_5_XX_),decrease_over_time(resource(r_1_XX_),scalar(2))).

precondition(tick,tick).
result(tick,apply_restitution(entity(e_2_XX_),entity(e_2_XX_))).
result(tick,apply_restitution(entity(e_1_XX_),entity(e_1_XX_))).
result(tick,apply_restitution(entity(e_3_XX_),entity(e_3_XX_))).
result(tick,moves(entity(e_1_XX_),forward,scalar(7))).
result(tick,moves(entity(e_2_XX_),backward,scalar(3))).
result(tick,moves(entity(e_3_XX_),backward,scalar(3))).
result(tick,decrease_over_time(resource(r_1_XX_),scalar(1))).
result(tick,look_at(entity(e_3_XX_),entity(e_1_XX_),furthest)).
result(tick,look_at(entity(e_2_XX_),entity(e_1_XX_),furthest)).

reading(goal(produce),resource(r_1_XX_)).
reading(good,resource(r_1_XX_)).
reading(produces,relation(entity(e_2_XX_),property(entity(e_1_XX_),health))).
reading(bad,tick).
reading(bad,outcome(o_5_XX_)).
reading(good,outcome(o_1_XX_)).
reading(maintenance,resource(r_1_XX_)).
reading(hurt,relation(entity(e_3_XX_),player)).
reading(dodge,entity(e_3_XX_)).
reading(survive,entity(e_3_XX_)).
reading(help,relation(entity(e_2_XX_),player)).
reading(help,relation(entity(e_2_XX_),entity(e_1_XX_))).
reading(hand_eye_coordination,game).
reading(stakes(low),resource(r_2_XX_)).
==========
<ul>
<li>The goal is to produce r(1)</li>

<li>The player will do this by<ul>
<li>
attempting to make a [[blue|circle]] and [[red|circle]] touch
</li>
</ul></li>
<li>The player will avoid<ul>
<li>
	attempting to make a [[green|circle]] and [[red|circle]] touch
</li>
</ul>
<li>The player controls the game by<ul>
<li>
	pressing the mouse button
</li>
<li>
	holding the mouse button
</li>
</ul></ul>
