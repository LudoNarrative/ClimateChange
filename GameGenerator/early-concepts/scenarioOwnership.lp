
actor(player,1).
actor(friend,2).
actor(friend,3).

resource(plate,2).

#const resourceCount = 4.
#const minTransitionCount = 1.
#const maxTransitionCount = 6.
#const maxPerConcept = 3.
#const maxPerResource = 3.
#const maxPerActor = 5.
%%%%%%%%%


hyponym(something,food).
hyponym(something,plate).

abstract(something).

accumulation(food).
accumulation(hunger).


input(eat,food,1,1).

input(enjoys_eating,food,1,1).
output(enjoys_eating,satiation,1,2).

input(relieve_hunger,food,1,1).
input(relieve_hunger,hunger,1,2).


output(get_hungry,hunger,1,1).

input(offers, something,1,1).
output(offers,something,2,1).

input(serves,plate,1,1).
output(serves,plate,1,1).
output(serves,food,1,2).
