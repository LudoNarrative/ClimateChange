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

many(entity(e_1_XX_)).
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

timer_logic(timer(t_1_XX_),scalar(2),loop).
timer_logic(timer(click_to_move_entity_e_2_XX__XX__XX_),scalar(2),loop).

initialize(set_value(resource(r_1_XX_),scalar(1))).
initialize(set_value(resource(r_2_XX_),scalar(0))).

precondition(control_event(button(mouse,pressed)),outcome(click_to_move_entity_e_2_XX__XX__XX_)).
result(outcome(click_to_move_entity_e_2_XX__XX__XX_),increase(resource(r_2_XX_),scalar(1))).
result(outcome(click_to_move_entity_e_2_XX__XX__XX_),apply_impulse(entity(e_2_XX_),direction(forward),scalar(3))).

precondition(timer_elapsed(t_1_XX_),outcome(o_1_XX_)).
result(outcome(o_1_XX_),increase(resource(r_1_XX_),scalar(1))).

precondition(overlaps(entity(e_1_XX_),entity(e_1_XX_),false),outcome(o_2_XX_)).
result(outcome(o_2_XX_),move_away(entity(e_1_XX_),cursor,scalar(3))).

precondition(overlaps(entity(e_1_XX_),entity(e_3_XX_),false),outcome(o_3_XX_)).
result(outcome(o_3_XX_),decrease_over_time(resource(r_1_XX_),scalar(10))).

precondition(timer_elapsed(click_to_move_entity_e_2_XX__XX__XX_),outcome(o_4_XX_)).
result(outcome(o_4_XX_),apply_impulse(entity(e_2_XX_),direction(away,entity(e_3_XX_)),scalar(4))).

precondition(control_event(button(mouse,held)),outcome(o_5_XX_)).
result(outcome(o_5_XX_),move_towards(entity(e_3_XX_),entity(e_3_XX_),scalar(3))).

precondition(ge(resource(r_1_XX_),scalar(8)),outcome(o_6_XX_)).
result(outcome(o_6_XX_),mode_change(game_loss)).

precondition(tick,tick).
result(tick,apply_restitution(entity(e_1_XX_),entity(e_1_XX_))).
result(tick,apply_restitution(entity(e_2_XX_),entity(e_2_XX_))).
result(tick,apply_restitution(entity(e_3_XX_),entity(e_3_XX_))).
result(tick,moves(entity(e_1_XX_),forward,scalar(4))).
result(tick,move(entity(e_1_XX_),look_at(entity(e_1_XX_),entity(e_3_XX_)))).
result(tick,moves(entity(e_1_XX_),left,scalar(4))).

precondition(overlaps(entity(e_1_XX_),entity(e_2_XX_),true),timer_elapsed(click_to_move_entity_e_2_XX__XX__XX_)).
precondition(ge(resource(r_2_XX_),scalar(9)),timer_elapsed(click_to_move_entity_e_2_XX__XX__XX_)).
result(timer_elapsed(click_to_move_entity_e_2_XX__XX__XX_),rotates(entity(e_2_XX_),ccw,scalar(20))).

reading(goal(reduce),resource(r_1_XX_)).
reading(bad,resource(r_1_XX_)).
reading(bad,outcome(o_1_XX_)).
reading(good,outcome(o_3_XX_)).
reading(hand_eye_coordination,game).
reading(maintenance,resource(r_1_XX_)).
reading(help,relation(entity(e_3_XX_),player)).
reading(flees,relation(entity(e_2_XX_),entity(e_3_XX_))).
reading(flees,relation(entity(e_1_XX_),cursor)).
reading(stakes(low),resource(r_2_XX_)).
==========
<ul>
<li>The goal is to reduce stress</li>

<li>The player will do this by<ul>
<li>
	attempting to keep a [[green|circle]] and [[red|circle]] from touching
</li>
</ul></li>
<li>The player controls the game by<ul>
<li>	the [[red|circle]] moves away from the cursor</li>
<li>
	pressing the mouse button
</li>
<li>
	holding the mouse button
</li>
</ul></ul>
