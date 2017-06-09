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

initialize(set_static(entity(e_3_XX_),true)).
initialize(add(entity(e_1_XX_),scalar(1),location(top,left))).
initialize(add(entity(e_1_XX_),scalar(1),location(top,right))).
initialize(add(entity(e_1_XX_),scalar(1),location(bottom,center))).
initialize(add(entity(e_2_XX_),scalar(1),location(top,center))).
initialize(add(entity(e_2_XX_),scalar(1),location(bottom,left))).
initialize(add(entity(e_2_XX_),scalar(1),location(bottom,right))).
initialize(add(entity(e_3_XX_),scalar(1),location(middle,center))).
initialize(set_color(entity(e_1_XX_),red)).
initialize(set_sprite(entity(e_1_XX_),circle)).
initialize(set_sprite(entity(e_2_XX_),circle)).
initialize(set_sprite(entity(e_3_XX_),circle)).
initialize(set_color(entity(e_2_XX_),blue)).
initialize(set_color(entity(e_3_XX_),green)).

timer_logic(timer(t_1_XX_),scalar(2),loop).
timer_logic(timer(patrol_entity_e_2_XX__XX__XX_),scalar(2),loop).

initialize(set_value(resource(r_1_XX_),scalar(1))).
initialize(set_value(resource(r_2_XX_),scalar(7))).

precondition(timer_elapsed(patrol_entity_e_2_XX__XX__XX_),outcome(o_1_XX_)).
result(outcome(o_1_XX_),decrease(property(health,entity(e_2_XX_)),scalar(10))).
result(outcome(o_1_XX_),increase(resource(r_1_XX_),scalar(1))).

precondition(overlaps(entity(e_1_XX_),entity(e_2_XX_),false),outcome(o_2_XX_)).
result(outcome(o_2_XX_),decrease_over_time(resource(r_1_XX_),scalar(3))).

precondition(timer_elapsed(t_1_XX_),outcome(o_3_XX_)).
result(outcome(o_3_XX_),apply_impulse(entity(e_1_XX_),direction(towards,cursor),scalar(2))).

precondition(overlaps(entity(e_1_XX_),entity(e_3_XX_),false),outcome(o_4_XX_)).
result(outcome(o_4_XX_),move_away(entity(e_2_XX_),entity(e_3_XX_),scalar(2))).

precondition(control_event(button(mouse,pressed)),outcome(o_5_XX_)).
precondition(ge(resource(r_2_XX_),scalar(1)),outcome(o_5_XX_)).
result(outcome(o_5_XX_),decrease(resource(r_2_XX_),scalar(5))).

precondition(ge(resource(r_1_XX_),scalar(10)),outcome(o_6_XX_)).
result(outcome(o_6_XX_),mode_change(game_loss)).

precondition(overlaps(entity(e_1_XX_),entity(e_3_XX_),true),outcome(patrol_entity_e_2_XX__XX__XX_)).
result(outcome(patrol_entity_e_2_XX__XX__XX_),rotates(entity(e_2_XX_),cw,scalar(90))).
result(outcome(patrol_entity_e_2_XX__XX__XX_),increase_over_time(resource(r_2_XX_),scalar(1))).

precondition(tick,tick).
result(tick,apply_restitution(entity(e_1_XX_),entity(e_1_XX_))).
result(tick,apply_restitution(entity(e_2_XX_),entity(e_2_XX_))).
result(tick,moves(entity(e_2_XX_),forward,scalar(2))).
result(tick,move(entity(e_1_XX_),look_at(entity(e_1_XX_),entity(e_2_XX_)))).
result(tick,move(entity(e_2_XX_),look_at(entity(e_2_XX_),entity(e_1_XX_)))).
result(tick,moves(entity(e_1_XX_),backward,scalar(4))).

reading(produces,relation(entity(e_1_XX_),resource(r_2_XX_))).
reading(produces,relation(entity(e_3_XX_),resource(r_2_XX_))).
reading(goal(reduce),resource(r_1_XX_)).
reading(bad,resource(r_1_XX_)).
reading(bad,outcome(o_1_XX_)).
reading(good,outcome(o_2_XX_)).
reading(hand_eye_coordination,game).
reading(maintenance,resource(r_1_XX_)).
reading(help,relation(entity(e_2_XX_),player)).
reading(stakes(low),resource(r_1_XX_)).
reading(stakes(low),resource(r_2_XX_)).
reading(outcome_helps,relation(outcome(o_2_XX_),resource(r_1_XX_))).
==========
<ul>
<li>The goal is to reduce stress</li>

<li>The player will do this by<ul>
<li>
	attempting to keep a [[blue|circle]] and [[red|circle]] from touching
</li>
</ul></li>
<li>The player controls the game by<ul>
<li>	the [[red|circle]] moves towards the cursor</li>
<li>
	pressing the mouse button
</li>
</ul></ul>
