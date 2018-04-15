% Awful agglomeration of syntactically correct Cygnus assertions
% (Definitely not semantically correct)

entity(foo).
flag  (bar).
resource(r(1)) .
entity(e_2_XX_).

% Comment about labels 
%label (entity(foo),foo).
label (entity(e_2_XX_),"person").
label (entity(e(2)),"orange").

many(entity(e_1_XX_)).
singular(entity(e(2))).

boundary(closed).
% comment

controlLogic(draggable(entity(e_1_XX_))).

timer_logic(timer(t_1_XX_),scalar(5),loop).
timer_logic(timer(t_2_XX_),scalar(7),loop).
timer_logic(timer(behavior_condition_polarity_entity_e_2_XX__XX__X_wander_X_tick_XX_),scalar(3),loop).

pool(entity(e_1_XX_),location(top,left),ordered,ordered).
pool(entity(e_1_XX_),location(top,center),ordered,ordered).
pool(entity(e_1_XX_),location(top,right),ordered,ordered).
pool(entity(e_1_XX_),location(middle,left),ordered,ordered).
pool(entity(e_1_XX_),location(middle,center),ordered,ordered).
pool(entity(e_1_XX_),location(middle,right),ordered,ordered).
pool(entity(e_1_XX_),location(bottom,left),ordered,ordered).
pool(entity(e_1_XX_),location(bottom,center),ordered,ordered).
pool(entity(e_1_XX_),location(bottom,right),ordered,ordered).
pool(entity(e_2_XX_),location(top,left),ordered,random).
pool(entity(e_2_XX_),location(top,center),ordered,random).
pool(entity(e_2_XX_),location(top,right),ordered,random).
pool(entity(e_2_XX_),location(middle,left),ordered,random).
pool(entity(e_2_XX_),location(middle,center),ordered,random).
pool(entity(e_2_XX_),location(middle,right),ordered,random).
pool(entity(e_2_XX_),location(bottom,left),ordered,random).
pool(entity(e_2_XX_),location(bottom,center),ordered,random).
pool(entity(e_2_XX_),location(bottom,right),ordered,random).

% Doesn't make semantic sense to have delete in initialize
initialize(delete(entity(e_1_XX_))).
initialize(delete(entity(e(5)))).
initialize(set_static(entity(e(3)),true)).

initialize(add(entity(e_1_XX_),scalar(1),location(middle,center))).

initialize(add(entity(e_1_XX_),scalar(1),location(middle,center))).
initialize(add(entity(e_2_XX_),scalar(1),location(top,left))).
initialize(add(entity(e_2_XX_),scalar(1),location(bottom,center))).
initialize(add(entity(e_2_XX_),scalar(1),location(top,right))).

% Testing all the different kinds of values (which includes settables) and points
initialize(add(entity(e_1_XX_),amount(orange),location(middle,center))).
initialize(add(entity(e_1_XX_),distance(entity(e(1)),entity(e(2)),nearest),location(middle,center))).
initialize(add(entity(e_1_XX_),resource(r(1)),location(middle,center))).
initialize(add(entity(e_1_XX_),property(entity(e_1_XX_),health),location(middle,center))).
initialize(add(entity(e_1_XX_),property(entity(e_2_XX_),money),cursor)).
initialize(add(entity(e_1_XX_),random_int(scalar(0),scalar(10)),cursor)).

 % Doesnt make sense to have increase or decrease action in initialize (but syntactically correct)
initialize(increase(resource(r(1)),scalar(1))).
initialize(decrease(property(entity(mario),health),random_int(scalar(0),scalar(2)))).

initialize(increase_over_time(property(entity(e_2_XX_),health),scalar(10))).
initialize(decrease_over_time(property(entity(e_2_XX_),health),scalar(10))).

% Set value, point, and bool
initialize(set_value(resource(r_1_XX_),scalar(0))).
initialize(set_value(resource(r_1_XX_),scalar(8))).
initialize(set_value(resource(r_2_XX_),distance(entity(e1),entity(e2),random))).
initialize(set_value(resource(r_3_XX_),distance(entity(e1),entity(e2),nearest))).
initialize(set_value(resource(r_4_XX_),distance(entity(e1),entity(e2),furthest))).
initialize(set_value(resource(r(1)),amount(clear))).
initialize(set_point(entity(r_1_XX_),location(bottom,right))).
initialize(set_bool(flag(questflag),true)).

% Pool
initialize(set_point(entity(e_1),pool(entity(e_1_XX_)))).
initialize(set_point(entity(e_1),pool(pool1))).
result(outcome(o_6_XX_),add(entity(e_1_XX_),scalar(1),pool(entity(e_1_XX_)))).

% Move
initialize(moves(entity(e1),right,scalar(2))).
initialize(move_toward(entity(e2),entity(e3),scalar(23))).
initialize(move_away(entity(heroine),entity(bunny),scalar(2))).

initialize(set_acceleration(entity(foo),location(top,right),amount(clear))).
initialize(set_acceleration(entity(foo),right,property(entity(foo),health))).
initialize(set_acceleration(entity(foo),north,amount(clear))).

initialize(set_acceleration ( entity(e(1)) , right, scalar(3) )).
initialize(set_acceleration ( entity(e(1)) , cursor , scalar(3) )).
initialize(apply_restitution ( entity(e(1)) , entity(e(1)) )).
initialize(rotates ( entity(e(1)) , ccw , scalar(3) )).
initialize(look_at ( entity(e(1)) , entity(target) , nearest )).
initialize(set_sprite ( entity(e(1)) , circle)).
initialize(set_color ( entity(e(1)) , red)).
initialize(set_size ( entity(e(1)) , scalar(2))).
initialize(set_bounce ( entity(e(1)) , scalar(5))).
initialize(set_draggable ( entity(e(1)) , true )).
initialize(mode_change(game_win)).

precondition(overlaps(entity(e_1_XX_),entity(e_1_XX_),true),outcome(o_1_XX_)).
result(outcome(o(1)),increase(resource(r_1_XX_),scalar(1))).
result(outcome(o(1)),clear(cursor)).
result(outcome(o_1_XX_),delete(entity(e_1_XX_))).

precondition(ge(resource(r_1_XX_),scalar(3)),outcome(o_2_XX_)).
precondition(le(amount(orange),scalar(9)),outcome(o_2_XX_)).
result(outcome(o(2)),decrease_over_time(property(entity(e_1_XX_),health),scalar(7))).
result(outcome(o_2_XX_),increase_over_time(property(entity(e_1_XX_),health),scalar(1))).

precondition(control_event(button(mouse,pressed)),outcome(o_3_XX_)).
%result(outcome(o_3_XX_),add(entity(e_1_XX_),scalar(1),pool(entity(e_1_XX_)))). % Wrong number of terms for pool

precondition(tick,tick).
result(tick,apply_restitution(entity(e_1_XX_),entity(e_1_XX_))).

precondition(timer_elapsed(t_1_XX_),outcome(o_1_XX_)).
result(outcome(o_1_XX_),set_value(resource(r_1_XX_),amount(clear))).
result(outcome(o_1_XX_),set_value(resource(r_2_XX_),amount(clear))).

precondition(timer_elapsed(timer(t_2_XX_)),outcome(o(1))).

precondition(timer_elapsed(behavior_condition_polarity_entity_e_2_XX__XX__X_wander_X_tick_XX_),outcome(o_5_XX_)).
result(outcome(o_5_XX_),set_value(resource(r_2_XX_),amount(clear))).
result(outcome(o_5_XX_),rotate_to(entity(e_2_XX_),random_int(scalar(0),scalar(360)))).
