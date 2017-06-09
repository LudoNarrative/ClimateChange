label(resource(r_1_XX_),composure).
label(entity(e_1_XX_),yourself).
label(entity(e_2_XX_),help).
label(entity(e_3_XX_),harm).
label(resource(r_2_XX_),r(2)).
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

timer_logic(timer(patrol_entity_e_3_XX__XX__XX_),scalar(3),loop).

initialize(set_value(resource(r_1_XX_),scalar(1))).
initialize(set_value(resource(r_2_XX_),scalar(2))).
initialize(set_value(resource(r_3_XX_),scalar(2))).

precondition(control_event(button(mouse,held)),outcome(click_to_chase_entity_e_2_XX__XX__XX_)).
precondition(overlaps(entity(e_1_XX_),entity(e_2_XX_),true),outcome(click_to_chase_entity_e_2_XX__XX__XX_)).
result(outcome(click_to_chase_entity_e_2_XX__XX__XX_),decrease_over_time(resource(r_1_XX_),scalar(6))).

precondition(control_event(button(mouse,held)),outcome(drawn_to_cursor_entity_e_1_XX__XX__XX_)).
result(outcome(drawn_to_cursor_entity_e_1_XX__XX__XX_),look_at(entity(e_1_XX_),cursor)).
result(outcome(drawn_to_cursor_entity_e_1_XX__XX__XX_),moves(entity(e_1_XX_),forward,scalar(3))).

precondition(overlaps(entity(e_2_XX_),entity(e_2_XX_),true),outcome(o_1_XX_)).
precondition(ge(resource(r_1_XX_),scalar(9)),outcome(o_1_XX_)).
result(outcome(o_1_XX_),mode_change(game_loss)).

precondition(overlaps(entity(e_1_XX_),entity(e_2_XX_),true),outcome(o_2_XX_)).
precondition(le(resource(r_3_XX_),scalar(10)),outcome(o_2_XX_)).
result(outcome(o_2_XX_),decrease_over_time(property(health,entity(e_2_XX_)),scalar(2))).

precondition(timer_elapsed(patrol_entity_e_3_XX__XX__XX_),outcome(o_3_XX_)).
result(outcome(o_3_XX_),apply_impulse(entity(e_1_XX_),direction(away,cursor),scalar(4))).
result(outcome(o_3_XX_),apply_impulse(entity(e_2_XX_),direction(towards,entity(e_2_XX_)),scalar(2))).
result(outcome(o_3_XX_),decrease(resource(r_2_XX_),scalar(2))).

precondition(overlaps(entity(e_1_XX_),entity(e_3_XX_),true),outcome(patrol_entity_e_3_XX__XX__XX_)).
precondition(le(resource(r_2_XX_),scalar(9)),outcome(patrol_entity_e_3_XX__XX__XX_)).
result(outcome(patrol_entity_e_3_XX__XX__XX_),rotates(entity(e_3_XX_),ccw,scalar(30))).
result(outcome(patrol_entity_e_3_XX__XX__XX_),decrease_over_time(resource(r_3_XX_),scalar(5))).
result(outcome(patrol_entity_e_3_XX__XX__XX_),increase_over_time(resource(r_1_XX_),scalar(1))).

precondition(tick,tick).
result(tick,apply_restitution(entity(e_1_XX_),entity(e_1_XX_))).
result(tick,apply_restitution(entity(e_2_XX_),entity(e_2_XX_))).
result(tick,apply_restitution(entity(e_3_XX_),entity(e_3_XX_))).
result(tick,moves(entity(e_2_XX_),forward,scalar(4))).
result(tick,moves(entity(e_3_XX_),forward,scalar(4))).
result(tick,increase_over_time(resource(r_1_XX_),scalar(2))).

reading(produces,relation(entity(e_1_XX_),resource(r_1_XX_))).
reading(consumes,relation(entity(e_1_XX_),resource(r_3_XX_))).
reading(consumes,relation(entity(e_2_XX_),property(health,entity(e_2_XX_)))).
reading(goal(reduce),resource(r_1_XX_)).
reading(bad,resource(r_1_XX_)).
reading(bad,tick).
reading(bad,outcome(patrol_entity_e_3_XX__XX__XX_)).
reading(bad,entity(e_1_XX_)).
reading(good,outcome(click_to_chase_entity_e_2_XX__XX__XX_)).
reading(maintenance,resource(r_1_XX_)).
reading(hurt,relation(entity(e_3_XX_),player)).
reading(dodge,entity(e_3_XX_)).
reading(survive,entity(e_3_XX_)).
reading(help,relation(entity(e_2_XX_),player)).
reading(chases,relation(entity(e_2_XX_),entity(e_2_XX_))).
reading(hand_eye_coordination,game).
reading(stakes(high),resource(r_1_XX_)).
reading(stakes(low),resource(r_2_XX_)).
reading(stakes(low),resource(r_3_XX_)).
reading(grinding,resource(r_3_XX_)).
==========
<ul>
<li>The goal is to reduce composure</li>

<li>The player will do this by<ul>
<li>
	 holding the mouse button
	 at the same time as
attempting to make a [[blue|circle]] and [[red|circle]] touch
</li>
</ul></li>
<li>The player will avoid<ul>
<li>
	attempting to make a [[green|circle]] and [[red|circle]] touch
	 at the same time as
compare(le,resource(r(2)))
</li>
</ul>
<li>The player controls the game by<ul>
<li>	the [[red|circle]] moves away from the cursor</li>
<li>
	holding the mouse button
</li>
</ul></ul>
