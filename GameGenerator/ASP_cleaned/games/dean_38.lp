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

timer_logic(timer(t_1_XX_),scalar(3),loop).

initialize(set_value(resource(r_1_XX_),scalar(0))).
initialize(set_value(resource(r_2_XX_),scalar(8))).
initialize(set_value(resource(r_3_XX_),scalar(0))).

precondition(overlaps(entity(e_1_XX_),entity(e_3_XX_),true),outcome(o_1_XX_)).
result(outcome(o_1_XX_),apply_impulse(entity(e_2_XX_),direction(towards,entity(e_2_XX_)),scalar(4))).
result(outcome(o_1_XX_),add(entity(e_3_XX_),scalar(1),location(bottom,left))).
result(outcome(o_1_XX_),delete(entity(e_3_XX_))).

precondition(timer_elapsed(t_1_XX_),outcome(o_2_XX_)).
result(outcome(o_2_XX_),increase(resource(r_1_XX_),scalar(1))).
result(outcome(o_2_XX_),increase(resource(r_3_XX_),scalar(1))).
result(outcome(o_2_XX_),add(entity(e_2_XX_),scalar(1),location(middle,right))).

precondition(overlaps(entity(e_2_XX_),entity(e_2_XX_),true),outcome(o_3_XX_)).
precondition(ge(resource(r_1_XX_),scalar(8)),outcome(o_3_XX_)).
result(outcome(o_3_XX_),mode_change(game_loss)).

precondition(overlaps(entity(e_1_XX_),entity(e_2_XX_),true),outcome(o_4_XX_)).
precondition(ge(resource(r_2_XX_),scalar(5)),outcome(o_4_XX_)).
result(outcome(o_4_XX_),increase(property(health,entity(e_1_XX_)),scalar(3))).
result(outcome(o_4_XX_),decrease(resource(r_1_XX_),scalar(7))).
result(outcome(o_4_XX_),delete(entity(e_2_XX_))).

precondition(overlaps(entity(e_1_XX_),entity(e_2_XX_),false),outcome(o_5_XX_)).
precondition(ge(resource(r_3_XX_),scalar(4)),outcome(o_5_XX_)).
result(outcome(o_5_XX_),decrease_over_time(property(health,entity(e_3_XX_)),scalar(7))).
result(outcome(o_5_XX_),increase_over_time(property(health,entity(e_2_XX_)),scalar(8))).

precondition(control_event(click(entity(e_1_XX_))),outcome(o_6_XX_)).
result(outcome(o_6_XX_),decrease(property(health,entity(e_1_XX_)),scalar(10))).
result(outcome(o_6_XX_),decrease(property(health,entity(e_3_XX_)),scalar(10))).

precondition(tick,tick).
result(tick,apply_restitution(entity(e_1_XX_),entity(e_1_XX_))).
result(tick,apply_restitution(entity(e_2_XX_),entity(e_2_XX_))).
result(tick,move_away(entity(e_1_XX_),cursor,scalar(2))).
result(tick,decrease_over_time(property(health,entity(e_1_XX_)),scalar(2))).
result(tick,increase_over_time(resource(r_2_XX_),scalar(1))).

reading(produces,relation(entity(e_1_XX_),property(health,entity(e_1_XX_)))).
reading(consumes,relation(entity(e_1_XX_),resource(r_1_XX_))).
reading(consumes,relation(entity(e_2_XX_),resource(r_1_XX_))).
reading(goal(reduce),resource(r_1_XX_)).
reading(bad,resource(r_1_XX_)).
reading(bad,outcome(o_2_XX_)).
reading(good,outcome(o_4_XX_)).
reading(good,entity(e_1_XX_)).
reading(maintenance,resource(r_1_XX_)).
reading(hurt,relation(entity(e_3_XX_),player)).
reading(hurt,relation(entity(e_1_XX_),entity(e_2_XX_))).
reading(hurt,relation(entity(e_1_XX_),entity(e_3_XX_))).
reading(defend_against,entity(e_3_XX_)).
reading(survive,entity(e_3_XX_)).
reading(help,relation(entity(e_2_XX_),player)).
reading(hand_eye_coordination,game).
reading(stakes(low),resource(r_2_XX_)).
reading(stakes(low),resource(r_3_XX_)).
==========
<ul>
<li>The goal is to reduce composure</li>

<li>The player will do this by<ul>
<li>
attempting to make a [[blue|circle]] and [[red|circle]] touch
	 at the same time as
compare(ge,resource(r(2)))
</li>
</ul></li>
<li>The player controls the game by<ul>
<li>	the [[red|circle]] moves away from the cursor</li>
<li>
	clicking on a [[red|circle]]
</li>
</ul></ul>
