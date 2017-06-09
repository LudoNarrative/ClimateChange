label(resource(r_1_XX_),composure).
label(entity(e_1_XX_),yourself).
label(entity(e_2_XX_),help).
label(entity(e_3_XX_),harm).
label(resource(r_2_XX_),r(2)).

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

timer_logic(timer(t_1_XX_),scalar(2),loop).
timer_logic(timer(patrol_entity_e_1_XX__XX__XX_),scalar(3),loop).

initialize(set_value(resource(r_1_XX_),scalar(2))).
initialize(set_value(resource(r_2_XX_),scalar(10))).

precondition(control_event(button(mouse,held)),outcome(click_to_chase_entity_e_3_XX__XX__XX_)).
result(outcome(click_to_chase_entity_e_3_XX__XX__XX_),move_away(entity(e_2_XX_),entity(e_3_XX_),scalar(3))).

precondition(overlaps(entity(e_1_XX_),entity(e_3_XX_),true),outcome(o_1_XX_)).
result(outcome(o_1_XX_),increase(resource(r_1_XX_),scalar(2))).
result(outcome(o_1_XX_),add(entity(e_3_XX_),scalar(1),location(bottom,right))).
result(outcome(o_1_XX_),delete(entity(e_3_XX_))).

precondition(timer_elapsed(t_1_XX_),outcome(o_2_XX_)).
result(outcome(o_2_XX_),decrease(resource(r_2_XX_),scalar(4))).

precondition(timer_elapsed(patrol_entity_e_1_XX__XX__XX_),outcome(o_3_XX_)).
result(outcome(o_3_XX_),apply_impulse(entity(e_1_XX_),direction(towards,cursor),scalar(3))).

precondition(overlaps(entity(e_1_XX_),entity(e_3_XX_),true),outcome(o_4_XX_)).
precondition(ge(resource(r_1_XX_),scalar(10)),outcome(o_4_XX_)).
result(outcome(o_4_XX_),mode_change(game_win)).

precondition(overlaps(entity(e_1_XX_),entity(e_2_XX_),false),outcome(patrol_entity_e_1_XX__XX__XX_)).
precondition(le(resource(r_2_XX_),scalar(2)),outcome(patrol_entity_e_1_XX__XX__XX_)).
result(outcome(patrol_entity_e_1_XX__XX__XX_),rotates(entity(e_1_XX_),cw,scalar(10))).
result(outcome(patrol_entity_e_1_XX__XX__XX_),increase_over_time(resource(r_1_XX_),scalar(2))).

precondition(tick,tick).
result(tick,apply_restitution(entity(e_1_XX_),entity(e_1_XX_))).
result(tick,apply_restitution(entity(e_2_XX_),entity(e_2_XX_))).
result(tick,apply_restitution(entity(e_3_XX_),entity(e_3_XX_))).
result(tick,moves(entity(e_1_XX_),forward,scalar(3))).
result(tick,moves(entity(e_3_XX_),forward,scalar(4))).
result(tick,decrease_over_time(resource(r_1_XX_),scalar(9))).

reading(goal(produce),resource(r_1_XX_)).
reading(good,resource(r_1_XX_)).
reading(produces,relation(entity(e_1_XX_),resource(r_1_XX_))).
reading(bad,tick).
reading(good,outcome(o_1_XX_)).
reading(good,outcome(patrol_entity_e_1_XX__XX__XX_)).
reading(good,entity(e_1_XX_)).
reading(maintenance,resource(r_1_XX_)).
reading(hurt,relation(entity(e_3_XX_),player)).
reading(hurt,relation(entity(e_1_XX_),entity(e_3_XX_))).
reading(defend_against,entity(e_3_XX_)).
reading(survive,entity(e_3_XX_)).
reading(help,relation(entity(e_2_XX_),player)).
reading(help,relation(entity(e_3_XX_),player)).
reading(chases,relation(entity(e_1_XX_),cursor)).
reading(flees,relation(entity(e_2_XX_),entity(e_3_XX_))).
reading(hand_eye_coordination,game).
reading(stakes(low),resource(r_1_XX_)).
reading(stakes(low),resource(r_2_XX_)).
reading(outcome_helps,relation(outcome(o_1_XX_),resource(r_1_XX_))).
reading(outcome_helps,relation(outcome(patrol_entity_e_1_XX__XX__XX_),resource(r_1_XX_))).
reading(organization).
==========
<ul>
<li>The goal is to produce composure</li>

<li>The player will do this by<ul>
<li>
attempting to make a [[green|circle]] and [[red|circle]] touch
</li>
<li>
	attempting to keep a [[blue|circle]] and [[red|circle]] from touching
	 at the same time as
compare(le,resource(r(2)))
</li>
</ul></li>
<li>The player controls the game by<ul>
<li>	the [[red|circle]] moves towards the cursor</li>
<li>
	holding the mouse button
</li>
</ul></ul>
