%%%%%%%%%%%%%%%%%%%%%%
%% Player has no real control
entity(e1).
entity(e2).

resource(r1).

many(e1).
many(e2).

initialize(add(e1,location(top,center))).
initialize(add(e2,location(top,left))).

static(e1).

timerLogic(change_direction(e2),1,loop).

precondition(tick,tick).
result(tick,moves(e2,forward)).
result(tick,decrease_over_time(r1)).

precondition(overlaps(e1,e2,true),o3).
result(o3,increase(r1)).
result(o3,delete(e2)).

precondition(le(r1),o2).
result(o2,mode_change(narrative_gating)).

precondition(timerElapsed(change_direction(e2)),change_direction(e2)).
result(change_direction(e2),rotate_to(e2,random_int(0,360))).

precondition(control_event(click(e1)),o1).
result(o1,delete(e1)).

interpretation(e1,consumes(e2)).
interpretation(e2,creates(r1)).
interpretation(e1,creates(r1)).
interpretation(e1,autonomous).
interpretation(e2,autonomous).
interpretation(e1,static).


%%%%%%%%%%%%%%%%%%%%%%
%% Move the people to the food?  More of a buffet simulator?

entity(e1).
entity(e2).

resource(r1).

many(e1).
many(e2).

initialize(add(e1,location(bottom,left))).
initialize(add(e2,location(bottom,right))).

controlLogic(draggable(e2)).

static(e1).

timerLogic(spawn(e1,location(bottom,left)),3,loop).

precondition(timerElapsed(spawn(e1,location(bottom,left))),spawn(e1,location(bottom,left))).
result(spawn(e1,location(bottom,left)),add(e1,location(bottom,left))).

precondition(le(r1),o2).
result(o2,mode_change(narrative_gating)).

precondition(overlaps(e1,e2,true),o1).
result(o1,increase(r1)).
result(o1,delete(e1)).

precondition(tick,tick).
result(tick,decrease_over_time(r1)).

interpretation(e2,consumes(e1)).
interpretation(e2,creates(r1)).
interpretation(e1,creates(r1)).
interpretation(e1,autonomous).
interpretation(e2,player_controlled).
interpretation(e1,static).

