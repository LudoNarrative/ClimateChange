


required(hand_eye_coordination).
entity(entity(e1)).
entity(entity(e2)).
resource(resource(r1)).


precondition(overlaps(entity(e1),entity(e2),true),outcome(o1)).
result(outcome(o1),modify(increase,resource(r1))).

precondition(tick,tick).
result(tick,move(entity(e1),direction(towards,entity(e2)))).
result(tick,apply_restitution(entity(e1),entity(e2))).

precondition(compare(le,resource(r1)),outcome(o2)).
result(outcome(o2),mode_change(game_loss)).


