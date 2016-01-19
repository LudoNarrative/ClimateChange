%%% KNOWLEDGE ENGINEERING
%THOUGHTS
% 1) Still missing something personal, I want it encoded that the one eating is the one gaining satisfaction.  Ownership of resources should be (or be able to) encoded
% 2) The hyponym system feels right to me - should expand it to actions as well

%infinite(somebody).
%accumulation(plate).
%boolean(food).

accumulation(clarity).

hyponym(food,banana).
hyponym(something,plate).

hyponym(somebody,friend).
hyponym(somebody,player).
hyponym(somebody,coworker).

hyponym(something,food).

hyponym(wanted,plate).

hyponym(tick,stutter).

hyponym(unwanted,trash).
hyponym(unwanted,oil).

hyponym(revealer,scrubber).
hyponym(obscurant,oil).
hyponym(obscured,trash).
hyponym(obscurant,sand).
hyponym(obscured,crab).
hyponym(obscured,stone).

hyponym(contemplative,reveal).
hyponym(contemplative,shave).

output(contemplative,contemplation,1).


input(neutralized,oil,1).
input(neutralized,dishsoap,2).
output(neutralized,trash,3).

input(dispose,unwanted,1).


input(eats,somebody,1).
input(eats,food,2).
output(eats,somebody,1).

input(serves,plate,1).
output(serves,food,2).


input(enjoys_eating,somebody,1).
input(enjoys_eating,food,2).
output(enjoys_eating,somebody,1).
output(enjoys_eating,satiation,3).

input(get_hungry,somebody,1).
input(get_hungry,time,2).
output(get_hungry,somebody,1).
output(get_hungry,time,2).
output(get_hungry,hunger,2).


input(relieve_hunger,somebody,1).
input(relieve_hunger,food,2).
input(relieve_hunger,hunger,3).
output(relieve_hunger,somebody,1).

input(offers, somebody,1).
output(offers, somebody,1).
output(offers,something,2).


input(accepts,somebody,1).
input(accepts,something,2).
output(accepts,somebody,1).

input(ignore,somebody,1).
input(ignore,wanted,2).
output(ignore,somebody,1).
output(ignore,wanted,2).
output(ignore,impatience,3).

input(gives,somebody,1).
input(gives,something,2).
output(gives,somebody,1).

input(wait,somebody,1).
input(wait,time,2).
output(wait,somebody,1).
output(wait,time,2).
output(wait,impatience,3).

input(succeeds,somebody,1).
input(succeeds,task,2).
output(succeeds,somebody,1).
output(succeeds,task,2).
output(succeeds,confidence,3).


input(fails,somebody,1).
input(fails,task,2).
output(fails,somebody,1).
output(fails,task,2).
output(fails,nervousness,3).

input(has_tick,somebody,1).
input(has_tick,nervousness,2).
output(has_tick,somebody,1).
output(has_tick,nervousness,2).
output(has_tick,tick,3).

input(relieves_tick,somebody,1).
input(relieves_tick,tick,2).
input(relieves_tick,confidence,2).
output(relieves_tick,somebody,1).
output(relieves_tick,confidence,2).



input(reveal,revealer,1).
input(reveal,obscurant,2).
output(reveal,revealer,1).
output(reveal,clarity,3).

input(find,clarity,1).
output(find,obscured,2).

input(clear,clarity,1).




