label(entity(e_1_XX_),e1).
label(resource(r_1_XX_),stress).
label(entity(e_2_XX_),e(2)).
label(entity(e_3_XX_),e(3)).

entity(e_1_XX_).
entity(e_2_XX_).
entity(e_3_XX_).

resource(r_1_XX_).

many(entity(e_1_XX_)).
many(entity(e_2_XX_)).
many(entity(e_3_XX_)).

initialize(set_static(entity(e_3_XX_),true)).
initialize(set_draggable(entity(e_1_XX_),true)).
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

controlLogic(draggable(entity(e_1_XX_))).

timer_logic(timer(t_1_XX_),scalar(2),loop).
timer_logic(timer(t_2_XX_),scalar(3),loop).

initialize(set_value(resource(r_1_XX_),scalar(1))).

precondition(overlaps(entity(e_1_XX_),entity(e_2_XX_),false),outcome(o_1_XX_)).
result(outcome(o_1_XX_),decrease_over_time(resource(r_1_XX_),scalar(9))).

precondition(timer_elapsed(t_1_XX_),outcome(o_2_XX_)).
result(outcome(o_2_XX_),increase(resource(r_1_XX_),scalar(1))).
result(outcome(o_2_XX_),add(entity(e_1_XX_),scalar(1),location(middle,left))).

precondition(timer_elapsed(t_2_XX_),outcome(o_3_XX_)).
result(outcome(o_3_XX_),add(entity(e_1_XX_),scalar(1),location(middle,center))).

precondition(overlaps(entity(e_1_XX_),entity(e_3_XX_),true),outcome(o_4_XX_)).
result(outcome(o_4_XX_),delete(entity(e_1_XX_))).

precondition(ge(resource(r_1_XX_),scalar(7)),outcome(o_5_XX_)).
result(outcome(o_5_XX_),mode_change(game_loss)).

precondition(tick,tick).
result(tick,move_away(entity(e_2_XX_),entity(e_3_XX_),scalar(4))).
result(tick,apply_restitution(entity(e_1_XX_),entity(e_1_XX_))).
result(tick,apply_restitution(entity(e_2_XX_),entity(e_2_XX_))).

reading(bad,resource(r_1_XX_)).
reading(bad,outcome(o_2_XX_)).
reading(good,outcome(o_1_XX_)).
reading(hand_eye_coordination,game).
reading(maintenance,resource(r_1_XX_)).
reading(produces,relation(location(middle,left),entity(e_1_XX_))).
reading(produces,relation(location(middle,center),entity(e_1_XX_))).
reading(consumes,relation(entity(e_3_XX_),entity(e_1_XX_))).
reading(goal(reduce),resource(r_1_XX_)).
reading(hurt,relation(entity(e_3_XX_),entity(e_1_XX_))).
reading(flees,relation(entity(e_2_XX_),entity(e_3_XX_))).
reading(stakes(low),resource(r_1_XX_)).
reading(outcome_helps,relation(outcome(o_1_XX_),resource(r_1_XX_))).

==========
<ul>
<li>The goal is to reduce stress</li>

<li>The player will do this by<ul>
<li>
	attempting to keep a [[blue|circle]] and [[red|circle]] from touching
</li>
<li>
attempting to make a [[green|circle]] and [[red|circle]] touch
</li>
</ul></li>
<li>The player controls the game by<ul>
<li>
	clicking-and-dragging [[red|circle]]s
</li>
</ul></ul>