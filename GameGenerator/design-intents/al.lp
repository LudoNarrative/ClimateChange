


game(travel).

has_entity(travel, city, many).
has_value(travel, money).
has_value(travel, co2).
has_value(travel, fame).
has_value(travel,city(cost)).
has_value(travel,city(pollution)).
has_value(travel,city(prestige)).
narrative(travel, co2).
narrative(travel, fame).

goal(travel, accumulation,fame).
has_mechanic(travel,selection).

precondition(thresh(gt,0,money),selection).
decreases(travel,selection,money,city(cost)).
increases(travel,selection,co2,city(pollution)).
increases(travel,selection,fame,city(prestive)). % perhaps not necessary?  
chooses(travel,selection,city,multiple). %perhaps not necessary - perhaps choosing+accumulating(x) means chooses(x)? 


game(beach).

has_entity(beach,crab,many).
has_entity(beach,sand,singular).
has_value(beach,sand(amount)).
goal(beach,discard,sand(amount)).
has_mechanic(beach,scrubbing).
decreases(beach,scrubbing,sand(amount),amount).
%Don't feel need to specify any sort of mechanic type


game(lecture).


has_entity(lecture,target,singular).
has_entity(lecture,cursor,singular).
has_value(lecture,confidence).
precondition(thresh(gt,0,confidence), end_game).

%goal(lecture,outplay,confidence). %outplay - assumption that the value must remain above threshold
decreases(lecture,time,confidence,amount). % assume there's a universal time 'mechanic' that can be used
has_mechanic(lecture,focus).
increases(lecture,focus,confidence,amount).
system_controlled(lecture,time). % better name than time needed
player_controlled(lecture,focus).
has_goal(lecture,focus,align,target,cursor). % maybe align(target,cursor)?






