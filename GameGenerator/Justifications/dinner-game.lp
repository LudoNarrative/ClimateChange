
entity(left_side). singular(left_side).
entity(plate). singular(plate).
entity(right_side). singular(right_side).
entity(food). many(food).
entity(platter). many(platter).

resource(patience).
initialize(set(patience,high)).

precondition(overlaps(platter, left_side, true), accept_platter).
precondition(control_event(click(platter)), accept_platter).
result(accept_platter, move_toward(platter, plate)).

precondition(overlaps(platter, plate, true), serve_self).
precondition(control_event(click(platter)), serve_self).
result(serve_self, add(food)).

precondition(overlaps(platter, plate, true), pass_platter).
precondition(control_event(click(right_side)), pass_platter).
result(pass_platter, move_toward(platter, right_side)).
result(pass_platter, delete(platter)).
result(pass_platter, increase(patience, med)).

precondition(tick, tick).
result(tick, decrease(patience, low)).

precondition(tick, more_food).
precondition(overlaps(platter, left_side, false), more_food).
result(more_food, add(platter)).
