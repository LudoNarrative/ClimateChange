%%% KNOWLEDGE ENGINEERING


%infinite(somebody).
%accumulation(plate).
%boolean(food).


hyponym(food,banana).
hyponym(something,plate).

hyponym(somebody,friend).
hyponym(somebody,player).
hyponym(something,food).


input(eats,somebody,1).
input(eats,food,2).
output(eats,somebody,1).

input(serves,plate,1).
output(serves,food,2).


input(enjoys_eating,somebody,1).
input(enjoys_eating,food,2).
output(enjoys_eating,somebody,1).
output(enjoys_eating,satiation,3).


input(offers, somebody,1).
output(offers, somebody,1).
output(offers,something,2).

input(gives,somebody,1).
input(gives,something,2).
output(gives,somebody,1).

input(wait,somebody,1).
input(wait,time,2).
output(wait,somebody,1).
output(wait,time,2).
output(wait,impatience,3).



