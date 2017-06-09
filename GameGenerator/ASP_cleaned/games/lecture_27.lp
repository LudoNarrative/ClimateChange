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

initialize(set_static(entity(e_3_XX_),true)).
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

timer_logic(timer(patrol_entity_e_1_XX__XX__XX_),scalar(2),loop).
timer_logic(timer(click_to_move_entity_e_2_XX__XX__XX_),scalar(2),loop).

initialize(set_value(resource(r_1_XX_),scalar(5))).
initialize(set_value(resource(r_2_XX_),scalar(7))).

precondition(control_event(button(mouse,pressed)),outcome(click_to_move_entity_e_2_XX__XX__XX_)).
result(outcome(click_to_move_entity_e_2_XX__XX__XX_),apply_impulse(entity(e_1_XX_),direction(towards,cursor),scalar(2))).
result(outcome(click_to_move_entity_e_2_XX__XX__XX_),apply_impulse(entity(e_2_XX_),direction(forward),scalar(2))).

precondition(overlaps(entity(e_1_XX_),entity(e_3_XX_),true),outcome(o_1_XX_)).
precondition(le(resource(r_1_XX_),scalar(8)),outcome(o_1_XX_)).
result(outcome(o_1_XX_),decrease_over_time(resource(r_2_XX_),scalar(9))).

precondition(le(resource(r_1_XX_),scalar(2)),outcome(o_2_XX_)).
result(outcome(o_2_XX_),mode_change(game_loss)).

precondition(timer_elapsed(click_to_move_entity_e_2_XX__XX__XX_),outcome(o_3_XX_)).
result(outcome(o_3_XX_),decrease(resource(r_1_XX_),scalar(1))).

precondition(timer_elapsed(patrol_entity_e_1_XX__XX__XX_),outcome(o_4_XX_)).
result(outcome(o_4_XX_),add(entity(e_2_XX_),scalar(1),location(middle,right))).

precondition(le(resource(r_2_XX_),scalar(3)),outcome(patrol_entity_e_1_XX__XX__XX_)).
result(outcome(patrol_entity_e_1_XX__XX__XX_),rotates(entity(e_1_XX_),cw,scalar(30))).

precondition(tick,tick).
result(tick,apply_restitution(entity(e_1_XX_),entity(e_1_XX_))).
result(tick,apply_restitution(entity(e_2_XX_),entity(e_2_XX_))).
result(tick,moves(entity(e_1_XX_),forward,scalar(4))).
result(tick,move(entity(e_1_XX_),look_at(entity(e_1_XX_),entity(e_3_XX_)))).
result(tick,moves(entity(e_1_XX_),backward,scalar(4))).

precondition(overlaps(entity(e_1_XX_),entity(e_2_XX_),true),timer_elapsed(click_to_move_entity_e_2_XX__XX__XX_)).
result(timer_elapsed(click_to_move_entity_e_2_XX__XX__XX_),rotates(entity(e_2_XX_),ccw,scalar(20))).
result(timer_elapsed(click_to_move_entity_e_2_XX__XX__XX_),increase(resource(r_1_XX_),scalar(1))).
result(timer_elapsed(click_to_move_entity_e_2_XX__XX__XX_),delete(entity(e_2_XX_))).

reading(goal(produce),resource(r_1_XX_)).
reading(good,resource(r_1_XX_)).
reading(produces,relation(location(middle,right),entity(e_2_XX_))).
reading(consumes,relation(entity(e_3_XX_),resource(r_2_XX_))).
reading(bad,outcome(o_3_XX_)).
reading(good,timer_elapsed(click_to_move_entity_e_2_XX__XX__XX_)).
reading(hand_eye_coordination,game).
reading(maintenance,resource(r_1_XX_)).
reading(hurt,relation(entity(e_2_XX_),player)).
reading(hurt,relation(entity(e_1_XX_),entity(e_2_XX_))).
reading(defend_against,entity(e_2_XX_)).
reading(survive,entity(e_2_XX_)).
reading(help,relation(entity(e_2_XX_),player)).
reading(chases,relation(entity(e_1_XX_),cursor)).
reading(stakes(low),resource(r_1_XX_)).
reading(stakes(low),resource(r_2_XX_)).
reading(outcome_helps,relation(timer_elapsed(click_to_move_entity_e_2_XX__XX__XX_),resource(r_1_XX_))).
==========
<ul>
<li>The goal is to produce concentration</li>

<li>The player will do this by<ul>
<li>
attempting to make a [[blue|circle]] and [[red|circle]] touch
</li>
</ul></li>
<li>The player controls the game by<ul>
<li>	the [[red|circle]] moves towards the cursor</li>
<li>
	pressing the mouse button
</li>
</ul></ul>
