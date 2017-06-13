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

initialize(set_draggable(entity(e_1_XX_),true)).
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

controlLogic(draggable(entity(e_1_XX_))).

timer_logic(timer(t_1_XX_),scalar(3),loop).
timer_logic(timer(t_2_XX_),scalar(3),loop).
timer_logic(timer(pingpong_entity_e_3_XX__XX__XX_),scalar(3),loop).
timer_logic(timer(wander_entity_e_2_XX__XX__XX_),scalar(3),loop).

initialize(set_value(resource(r_1_XX_),scalar(9))).
initialize(set_value(resource(r_2_XX_),scalar(3))).

precondition(control_event(button(mouse,pressed)),outcome(click_to_chase_entity_e_3_XX__XX__XX_)).
result(outcome(click_to_chase_entity_e_3_XX__XX__XX_),decrease(property(entity(e_3_XX_),health),scalar(6))).
result(outcome(click_to_chase_entity_e_3_XX__XX__XX_),add(entity(e_1_XX_),scalar(1),location(bottom,center))).
result(outcome(click_to_chase_entity_e_3_XX__XX__XX_),look_at(entity(e_3_XX_),entity(e_1_XX_),nearest)).

precondition(timer_elapsed(t_1_XX_),outcome(o_1_XX_)).
result(outcome(o_1_XX_),decrease(property(entity(e_1_XX_),health),scalar(4))).
result(outcome(o_1_XX_),decrease(resource(r_1_XX_),scalar(3))).
result(outcome(o_1_XX_),add(entity(e_3_XX_),scalar(1),location(middle,center))).

precondition(timer_elapsed(t_2_XX_),outcome(o_2_XX_)).
result(outcome(o_2_XX_),add(entity(e_3_XX_),scalar(1),location(top,right))).

precondition(overlaps(entity(e_2_XX_),entity(e_3_XX_),true),outcome(o_3_XX_)).
precondition(le(resource(r_2_XX_),scalar(6)),outcome(o_3_XX_)).
result(outcome(o_3_XX_),increase(resource(r_1_XX_),scalar(2))).
result(outcome(o_3_XX_),add(entity(e_1_XX_),scalar(1),location(middle,center))).
result(outcome(o_3_XX_),delete(entity(e_3_XX_))).

precondition(le(resource(r_1_XX_),scalar(1)),outcome(o_4_XX_)).
result(outcome(o_4_XX_),mode_change(game_loss)).

precondition(overlaps(entity(e_1_XX_),entity(e_1_XX_),true),outcome(o_5_XX_)).
result(outcome(o_5_XX_),decrease(property(entity(e_2_XX_),health),scalar(2))).
result(outcome(o_5_XX_),increase(property(entity(e_2_XX_),health),scalar(4))).
result(outcome(o_5_XX_),delete(entity(e_1_XX_))).

precondition(control_event(button(mouse,held)),outcome(orbit_the_cursor_entity_e_2_XX__XX__XX_)).
result(outcome(orbit_the_cursor_entity_e_2_XX__XX__XX_),decrease_over_time(property(entity(e_2_XX_),health),scalar(1))).
result(outcome(orbit_the_cursor_entity_e_2_XX__XX__XX_),look_at(entity(e_2_XX_),cursor,nearest)).
result(outcome(orbit_the_cursor_entity_e_2_XX__XX__XX_),moves(entity(e_2_XX_),left,scalar(4))).

precondition(timer_elapsed(pingpong_entity_e_3_XX__XX__XX_),outcome(pingpong_entity_e_3_XX__XX__XX_)).
result(outcome(pingpong_entity_e_3_XX__XX__XX_),rotates(entity(e_3_XX_),cw,scalar(180))).
result(outcome(pingpong_entity_e_3_XX__XX__XX_),decrease(resource(r_2_XX_),scalar(1))).
result(outcome(pingpong_entity_e_3_XX__XX__XX_),add(entity(e_3_XX_),scalar(1),location(bottom,center))).

precondition(timer_elapsed(wander_entity_e_2_XX__XX__XX_),outcome(wander_entity_e_2_XX__XX__XX_)).
result(outcome(wander_entity_e_2_XX__XX__XX_),rotate_to(entity(e_2_XX_),random_int(scalar(0),scalar(360)))).
result(outcome(wander_entity_e_2_XX__XX__XX_),decrease(property(entity(e_2_XX_),health),scalar(9))).
result(outcome(wander_entity_e_2_XX__XX__XX_),add(entity(e_1_XX_),scalar(1),location(top,right))).

precondition(tick,tick).
result(tick,apply_restitution(entity(e_1_XX_),entity(e_1_XX_))).
result(tick,apply_restitution(entity(e_2_XX_),entity(e_2_XX_))).
result(tick,apply_restitution(entity(e_3_XX_),entity(e_3_XX_))).
result(tick,moves(entity(e_2_XX_),forward,scalar(2))).
result(tick,moves(entity(e_3_XX_),forward,scalar(4))).
result(tick,decrease_over_time(resource(r_1_XX_),scalar(1))).
result(tick,look_at(entity(e_3_XX_),entity(e_2_XX_),random)).

reading(goal(produce),resource(r_1_XX_)).
reading(good,resource(r_1_XX_)).
reading(good,property(entity(e_1_XX_),health)).
reading(produces,relation(location(top,right),entity(e_1_XX_))).
reading(produces,relation(location(top,right),entity(e_3_XX_))).
reading(produces,relation(location(middle,center),entity(e_1_XX_))).
reading(produces,relation(location(middle,center),entity(e_3_XX_))).
reading(produces,relation(location(bottom,center),entity(e_1_XX_))).
reading(produces,relation(location(bottom,center),entity(e_3_XX_))).
reading(produces,relation(entity(e_1_XX_),property(entity(e_2_XX_),health))).
reading(consumes,relation(entity(e_1_XX_),entity(e_1_XX_))).
reading(consumes,relation(entity(e_1_XX_),property(entity(e_2_XX_),health))).
reading(bad,tick).
reading(bad,outcome(o_1_XX_)).
reading(good,outcome(o_3_XX_)).
reading(hand_eye_coordination,game).
reading(maintenance,resource(r_1_XX_)).
reading(hurt,relation(entity(e_1_XX_),player)).
reading(hurt,relation(entity(e_3_XX_),player)).
reading(hurt,relation(entity(e_1_XX_),entity(e_1_XX_))).
reading(hurt,relation(entity(e_2_XX_),entity(e_3_XX_))).
reading(hurt,relation(player,player)).
reading(defend_against,entity(e_1_XX_)).
reading(defend_against,entity(e_3_XX_)).
reading(survive,entity(e_1_XX_)).
reading(survive,entity(e_3_XX_)).
reading(help,relation(entity(e_3_XX_),player)).
reading(consts,relation(entity(e_1_XX_),property(entity(e_2_XX_),health))).
reading(consts,relation(entity(e_1_XX_),property(entity(e_3_XX_),health))).
reading(consts,relation(entity(e_3_XX_),property(entity(e_1_XX_),health))).
reading(consts,relation(entity(e_3_XX_),resource(r_1_XX_))).
reading(costs,relation(entity(e_1_XX_),property(entity(e_2_XX_),health))).
reading(costs,relation(entity(e_1_XX_),property(entity(e_3_XX_),health))).
reading(costs,relation(entity(e_3_XX_),property(entity(e_1_XX_),health))).
reading(costs,relation(entity(e_3_XX_),resource(r_1_XX_))).
reading(stakes(high),property(entity(e_1_XX_),health)).
reading(stakes(high),property(entity(e_2_XX_),health)).
reading(stakes(high),property(entity(e_3_XX_),health)).
reading(stakes(low),resource(r_1_XX_)).
reading(stakes(low),resource(r_2_XX_)).
reading(grinding,property(entity(e_3_XX_),health)).
reading(outcome_helps,relation(outcome(o_3_XX_),resource(r_1_XX_))).
==========
<ul>
<li>The goal is to produce concentration</li>

<li>The player will do this by<ul>
<li>
attempting to make a [[green|circle]] and [[blue|circle]] touch
	 at the same time as
compare(le,resource(r(2)))
</li>
</ul></li>
<li>The player controls the game by<ul>
<li>
	clicking-and-dragging [[red|circle]]s
</li>
<li>
	pressing the mouse button
</li>
<li>
	holding the mouse button
</li>
</ul></ul>
