%%%%%%%%%%%%%% DINNER 1

entity(e(1)).
entity(e(2)).

resource(r(1)).

many(e(1)).
many(e(2)).

controlLogic(draggable(e(1))).

precondition(control_event(click(e(1))),o(4)).
result(o(4),modify(decrease,r(1))).

precondition(overlaps(e(1),e(2),true),o(3)).
result(o(3),modify(increase,r(1))).
result(o(3),delete(e(1))).

precondition(compare(le,r(1)),o(2)).
result(o(2),mode_change(narrative_gating)).

precondition(tick,tick).
result(tick,move(e(2),direction(away,e(1)))).

precondition(compare(le,r(1)),o(1)).
precondition(control_event(click(e(2))),o(1)).
result(o(1),add(e(1))).

precondition(collide(e(2),e(2)),collide(e(2),e(2))).
result(collide(e(2),e(2)),apply_restitution(e(2),e(2))).

reading(sharing,relation(e(1),e(2))).
reading(goal(produce),r(1)).
reading(good,r(1)).
reading(consumes,relation(e(2),e(1))).
reading(hurt,relation(e(2),e(1))).
reading(flees,relation(e(2),e(1))).
reading(produces,relation(e(1),r(1))).
reading(produces,relation(e(2),r(1))).
