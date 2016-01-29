
#const entityCount = 10.
#const minRelationshipCount = 1.
#const maxRelationshipCount = 6.
#const maxPerConcept = 3.
#const maxPerEntity = 3.
#const maxPerActor = 5.

%useOnly(somebody,1,1).
%useOnly(eats,2).


%%% SCENE SPECIFIC ENTITIES

actor(player,1).
entity(crab,1).
%entity(oil,1).
%entity(dishsoap,1).
entity(sand,1).

%%%% SCENE SPECIFIC RULES?
accumulation(crab).
accumulation(trash).
accumulation(clarity).
hyponym(obscured,crab).
%hyponym(obscured,trash).

%%%%%%%


input(neutralized,oil,1,1).
input(neutralized,dishsoap,1,2).
output(neutralized,trash,1,3).

input(dispose,unwanted,1,1).

hyponym(contemplative,reveal).

output(contemplative,contemplation,1,1).

input(reveal,revealer,1,1).
input(reveal,obscurant,1,2).
output(reveal,revealer,1,1).
output(reveal,clarity,1,3).

input(find,clarity,1,1).
output(find,obscured,1,2).

input(clear,clarity,1,1).

abstract(revealer).
abstract(obscured).
abstract(obscurant).
abstract(unwanted).
abstract(contemplative).

hyponym(unwanted,trash).
hyponym(revealer,brush).
hyponym(obscurant,sand).
