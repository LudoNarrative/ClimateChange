%%% KNOWLEDGE ENGINEERING

source(offers,somebody,something).
sink(gives,somebody,something).
sink(eats,somebody,food).
converter(serves,plate,food).
converter(enjoys_eating,(somebody,food),(somebody,satiation)).
source(get_hungry,somebody,hunger).
converter(enjoy,(somebody,something),(somebody,happiness)).
source(wait,(somebody,time),impatience).

hyponym(somebody,friend).
hyponym(somebody,player).
hyponym(something,plate).
hyponym(something,food).
hyponym(food,banana).

