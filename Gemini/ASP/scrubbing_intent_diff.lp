#const min_entities = 0.
#const max_entities = 2.
#const min_resources = 1.
#const max_resources = 1.
#const min_outcomes = 2.
#const max_outcomes = 6.
#const min_timers = 0.
#const max_timers = 2.

#const min_end_outcomes = 0.
#const max_end_outcomes = 1.
#const max_resource_change_per = 2.
#const max_conditions_per = 4.

required(maintenance).

reading(bad,orange).

palette(orange).
allowed(monotonic(orange)).
label(resource(r(1)),effort,write).
allowed(monotonic(resource(r(1)))).
allowed(monotonic(r(1))).
allowed(superfluous(resource(r(1)))).
:- not monotonic(orange,decrease).
:- not initialize(fill(all,orange)).

:- action(mode_change(_)).

:- not player_controls(_).
:- not player_creates_effect(clear(_)).
:- player_doesnt_create_effect(clear(_)).

:- player_model(O,player_must_do),
   not result(O,modify(increase,resource(r(1)))).

:- not monotonic(resource(r(1)),increase).

initialize(set_value(resource(r(1)),scalar(0))).

%:- not condition(compare(_,_,amount(_))).

% make it real different
:- initialize(set_draggable(_,true)).
%:- controlScheme(entity(e(1)),click_and_drag).

:- 2{same_cause_effect(_,_)}.
:- 3{same_init(_)}.
:- 3{same_tick(_)}.

same_cause_effect(C,E) :-
  precondition(O1, C),
  result(O1, E),
  O1 != tick,
  old_precondition(OOld, C),
  old_result(OOld, C).

same_tick(E) :-
  result(tick, E),
  old_result(tick, E).

same_init(I) :-
  initialize(I),
  old_initialize(I).

old_initialize(set_value(resource(r_1_XX_),scalar(0))).
old_initialize(fill(all,orange)).
old_initialize(set_draggable(entity(e_1_XX_),true)).
old_initialize(add(entity(e_1_XX_),scalar(1),location(middle,center))).
old_initialize(set_sprite(entity(e_1_XX_),triangle)).
old_initialize(set_color(entity(e_1_XX_),red)).
old_controlLogic(draggable(entity(e_1_XX_))).
old_pool(entity(e_1_XX_),location(top,left),random,ordered).
old_pool(entity(e_1_XX_),location(top,center),random,ordered).
old_pool(entity(e_1_XX_),location(top,right),random,ordered).
old_pool(entity(e_1_XX_),location(middle,left),random,ordered).
old_pool(entity(e_1_XX_),location(middle,center),random,ordered).
old_pool(entity(e_1_XX_),location(middle,right),random,ordered).
old_pool(entity(e_1_XX_),location(bottom,left),random,ordered).
old_pool(entity(e_1_XX_),location(bottom,center),random,ordered).
old_pool(entity(e_1_XX_),location(bottom,right),random,ordered).
old_boundary(closed).
old_initialize(set_value(resource(r_1_XX_),scalar(0))).
old_initialize(set_value(resource(r_1_XX_),scalar(1))).
old_precondition(overlaps(entity(e_1_XX_),entity(e_1_XX_),true),outcome(o_1_XX_)).
old_result(outcome(o_1_XX_),increase(resource(r_1_XX_),scalar(1))).
old_result(outcome(o_1_XX_),clear(cursor)).
old_result(outcome(o_1_XX_),delete(entity(e_1_XX_))).
old_precondition(ge(resource(r_1_XX_),scalar(3)),outcome(o_2_XX_)).
old_precondition(le(amount(orange),scalar(9)),outcome(o_2_XX_)).
old_result(outcome(o_2_XX_),decrease_over_time(property(entity(e_1_XX_),health),scalar(7))).
old_result(outcome(o_2_XX_),increase_over_time(property(entity(e_1_XX_),health),scalar(1))).
old_precondition(control_event(button(mouse,pressed)),outcome(o_3_XX_)).
old_result(outcome(o_3_XX_),add(entity(e_1_XX_),scalar(1),pool(entity(e_1_XX_)))).
