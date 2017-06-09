label(entity(e_1_XX_),e1).
label(resource(r_1_XX_),stress).
label(entity(e_2_XX_),e(2)).
label(entity(e_3_XX_),e(3)).
label(resource(r_2_XX_),r(2)).

entity(e_1_XX_).
entity(e_2_XX_).
entity(e_3_XX_).

resource(r_1_XX_).
resource(r_2_XX_).

singular(entity(e_3_XX_)).

many(entity(e_1_XX_)).
many(entity(e_2_XX_)).

initialize(set_static(entity(e_3_XX_),true)).
initialize(add(entity(e_1_XX_),scalar(1),location(top,left))).
initialize(add(entity(e_1_XX_),scalar(1),location(top,right))).
initialize(add(entity(e_1_XX_),scalar(1),location(bottom,left))).
initialize(add(entity(e_1_XX_),scalar(1),location(bottom,right))).
initialize(add(entity(e_2_XX_),scalar(1),location(top,center))).
initialize(add(entity(e_2_XX_),scalar(1),location(middle,left))).
initialize(add(entity(e_2_XX_),scalar(1),location(middle,right))).
initialize(add(entity(e_2_XX_),scalar(1),location(bottom,center))).
initialize(add(entity(e_3_XX_),scalar(1),location(middle,center))).
initialize(set_color(entity(e_1_XX_),red)).
initialize(set_sprite(entity(e_1_XX_),circle)).
initialize(set_sprite(entity(e_2_XX_),circle)).
initialize(set_sprite(entity(e_3_XX_),circle)).
initialize(set_color(entity(e_2_XX_),blue)).
initialize(set_color(entity(e_3_XX_),green)).

timer_logic(timer(t_1_XX_),scalar(3),loop).
timer_logic(timer(t_2_XX_),scalar(2),loop).

initialize(set_value(resource(r_1_XX_),scalar(2))).
initialize(set_value(resource(r_2_XX_),scalar(1))).

precondition(overlaps(entity(e_1_XX_),entity(e_3_XX_),true),outcome(o_1_XX_)).
precondition(le(resource(r_2_XX_),scalar(0)),outcome(o_1_XX_)).
result(outcome(o_1_XX_),decrease_over_time(property(health,entity(e_2_XX_)),scalar(8))).

precondition(timer_elapsed(t_2_XX_),outcome(o_2_XX_)).
result(outcome(o_2_XX_),increase(resource(r_1_XX_),scalar(2))).

precondition(ge(resource(r_1_XX_),scalar(10)),outcome(o_3_XX_)).
result(outcome(o_3_XX_),mode_change(game_loss)).

precondition(control_event(button(mouse,pressed)),outcome(o_4_XX_)).
precondition(overlaps(entity(e_1_XX_),entity(e_3_XX_),true),outcome(o_4_XX_)).
result(outcome(o_4_XX_),decrease(resource(r_1_XX_),scalar(5))).

precondition(timer_elapsed(t_1_XX_),outcome(o_5_XX_)).
result(outcome(o_5_XX_),apply_impulse(entity(e_2_XX_),direction(towards,entity(e_2_XX_)),scalar(2))).

precondition(overlaps(entity(e_2_XX_),entity(e_2_XX_),false),outcome(o_6_XX_)).
result(outcome(o_6_XX_),decrease_over_time(resource(r_1_XX_),scalar(1))).

precondition(control_event(button(mouse,held)),outcome(orbit_the_cursor_entity_e_1_XX__XX__XX_)).
result(outcome(orbit_the_cursor_entity_e_1_XX__XX__XX_),decrease_over_time(resource(r_2_XX_),scalar(4))).
result(outcome(orbit_the_cursor_entity_e_1_XX__XX__XX_),look_at(entity(e_1_XX_),cursor)).
result(outcome(orbit_the_cursor_entity_e_1_XX__XX__XX_),moves(entity(e_1_XX_),left,scalar(2))).

precondition(tick,tick).
result(tick,apply_restitution(entity(e_1_XX_),entity(e_1_XX_))).
result(tick,apply_restitution(entity(e_2_XX_),entity(e_2_XX_))).
result(tick,moves(entity(e_2_XX_),forward,scalar(2))).
result(tick,move(entity(e_2_XX_),look_at(entity(e_2_XX_),entity(e_3_XX_)))).
result(tick,move_away(entity(e_1_XX_),entity(e_3_XX_),scalar(3))).
result(tick,moves(entity(e_2_XX_),right,scalar(2))).

reading(consumes,relation(entity(e_1_XX_),property(health,entity(e_2_XX_)))).
reading(consumes,relation(entity(e_3_XX_),property(health,entity(e_2_XX_)))).
reading(consumes,relation(entity(e_3_XX_),resource(r_1_XX_))).
reading(goal(reduce),resource(r_1_XX_)).
reading(bad,resource(r_1_XX_)).
reading(bad,outcome(o_2_XX_)).
reading(good,outcome(o_6_XX_)).
reading(good,outcome(o_4_XX_)).
reading(hand_eye_coordination,game).
reading(maintenance,resource(r_1_XX_)).
reading(help,relation(entity(e_2_XX_),player)).
reading(chases,relation(entity(e_2_XX_),entity(e_2_XX_))).
reading(flees,relation(entity(e_1_XX_),entity(e_3_XX_))).
reading(stakes(low),resource(r_1_XX_)).
reading(stakes(low),resource(r_2_XX_)).
reading(grinding,property(health,entity(e_2_XX_))).
reading(grinding,resource(r_2_XX_)).
reading(outcome_helps,relation(outcome(o_4_XX_),resource(r_1_XX_))).
==========
<ul>
<li>The goal is to reduce stress</li>

<li>The player will do this by<ul>
<li>
	 pressing the mouse button
	 at the same time as
attempting to make a [[green|circle]] and [[red|circle]] touch
</li>
</ul></li>
<li>The player controls the game by<ul>
<li>
	pressing the mouse button
</li>
<li>
	holding the mouse button
</li>
</ul></ul>
