
:- action(move(Entity,direction(towards,Other))),
    not result(tick,apply_restitution(Entity,Other)).