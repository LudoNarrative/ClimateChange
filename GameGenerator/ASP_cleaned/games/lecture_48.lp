label(entity(e_1_XX_),e1).
label(resource(r_1_XX_),concentration).
label(entity(e_2_XX_),e(2)).
label(entity(e_3_XX_),e(3)).
label(resource(r_2_XX_),r(2)).

entity(e_1_XX_).
entity(e_2_XX_).
entity(e_3_XX_).

resource(r_1_XX_).
resource(r_2_XX_).

many(entity(e_1_XX_)).
many(entity(e_2_XX_)).
many(entity(e_3_XX_)).

initialize(set_static(entity(e_2_XX_),true)).
initialize(add(entity(e_1_XX_),scalar(1),location(middle,center))).
initialize(add(entity(e_2_XX_),scalar(1),location(top,left))).
initialize(add(entity(e_2_XX_),scalar(1),location(top,right))).
initialize(add(entity(e_2_XX_),scalar(1),location(bottom,left))).
initialize(add(entity(e_2_XX_),scalar(1),location(bottom,right))).
initialize(add(entity(e_3_XX_),scalar(1),location(top,center))).
initialize(add(entity(e_3_XX_),scalar(1),location(middle,left))).
initialize(add(entity(e_3_XX_),scalar(1),location(middle,right))).
initialize(add(entity(e_3_XX_),scalar(1),location(bottom,center))).
initialize(set_color(entity(e_1_XX_),red)).
initialize(set_sprite(entity(e_1_XX_),circle)).
initialize(set_sprite(entity(e_2_XX_),circle)).
initialize(set_sprite(entity(e_3_XX_),circle)).
initialize(set_color(entity(e_2_XX_),blue)).
initialize(set_color(entity(e_3_XX_),green)).

timer_logic(timer(t_1_XX_),scalar(3),loop).
timer_logic(timer(wander_entity_e_3_XX__XX__XX_),scalar(2),loop).

initialize(set_value(resource(r_1_XX_),scalar(6))).
initialize(set_value(resource(r_2_XX_),scalar(1))).

precondition(control_event(button(mouse,held)),outcome(drawn_to_cursor_entity_e_1_XX__XX__XX_)).
result(outcome(drawn_to_cursor_entity_e_1_XX__XX__XX_),look_at(entity(e_1_XX_),cursor)).
result(outcome(drawn_to_cursor_entity_e_1_XX__XX__XX_),moves(entity(e_1_XX_),forward,scalar(3))).

precondition(overlaps(entity(e_1_XX_),entity(e_2_XX_),true),outcome(o_1_XX_)).
precondition(le(resource(r_2_XX_),scalar(5)),outcome(o_1_XX_)).
result(outcome(o_1_XX_),increase(property(health,entity(e_1_XX_)),scalar(5))).
result(outcome(o_1_XX_),delete(entity(e_2_XX_))).

precondition(control_event(button(mouse,pressed)),outcome(o_2_XX_)).
precondition(le(resource(r_2_XX_),scalar(1)),outcome(o_2_XX_)).
result(outcome(o_2_XX_),increase(resource(r_1_XX_),scalar(4))).

precondition(timer_elapsed(t_1_XX_),outcome(o_3_XX_)).
result(outcome(o_3_XX_),decrease(resource(r_2_XX_),scalar(5))).
result(outcome(o_3_XX_),add(entity(e_2_XX_),scalar(1),location(top,left))).

precondition(le(resource(r_1_XX_),scalar(0)),outcome(o_4_XX_)).
result(outcome(o_4_XX_),mode_change(game_loss)).

precondition(overlaps(entity(e_1_XX_),entity(e_3_XX_),true),outcome(o_5_XX_)).
precondition(le(resource(r_2_XX_),scalar(2)),outcome(o_5_XX_)).
result(outcome(o_5_XX_),increase_over_time(resource(r_1_XX_),scalar(1))).

precondition(timer_elapsed(wander_entity_e_3_XX__XX__XX_),outcome(wander_entity_e_3_XX__XX__XX_)).
result(outcome(wander_entity_e_3_XX__XX__XX_),rotate_to(entity(e_3_XX_),random_int(scalar(0),scalar(360)))).

precondition(tick,tick).
result(tick,apply_restitution(entity(e_1_XX_),entity(e_1_XX_))).
result(tick,apply_restitution(entity(e_3_XX_),entity(e_3_XX_))).
result(tick,moves(entity(e_3_XX_),forward,scalar(4))).
result(tick,move(entity(e_3_XX_),look_at(entity(e_3_XX_),entity(e_1_XX_)))).
result(tick,decrease_over_time(resource(r_1_XX_),scalar(3))).

reading(goal(produce),resource(r_1_XX_)).
reading(good,resource(r_1_XX_)).
reading(produces,relation(location(top,left),entity(e_2_XX_))).
reading(produces,relation(entity(e_2_XX_),property(health,entity(e_1_XX_)))).
reading(produces,relation(entity(e_3_XX_),resource(r_1_XX_))).
reading(bad,tick).
reading(good,outcome(o_5_XX_)).
reading(good,outcome(o_2_XX_)).
reading(hand_eye_coordination,game).
reading(maintenance,resource(r_1_XX_)).
reading(hurt,relation(entity(e_2_XX_),player)).
reading(hurt,relation(entity(e_1_XX_),entity(e_2_XX_))).
reading(defend_against,entity(e_2_XX_)).
reading(survive,entity(e_2_XX_)).
reading(help,relation(entity(e_3_XX_),player)).
reading(consts,relation(entity(e_2_XX_),resource(r_2_XX_))).
reading(costs,relation(entity(e_2_XX_),resource(r_2_XX_))).
reading(stakes(low),resource(r_2_XX_)).
reading(outcome_helps,relation(outcome(o_2_XX_),resource(r_1_XX_))).
==========
<ul>
<li>The goal is to produce concentration</li>

<li>The player will do this by<ul>
<li>
attempting to make a [[green|circle]] and [[red|circle]] touch
	 at the same time as
compare(le,resource(r(2)))
</li>
<li>
	 pressing the mouse button
	 at the same time as
compare(le,resource(r(2)))
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
