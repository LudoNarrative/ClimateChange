Dinner Game


Food : 
target

onCreate:
   Timer(time,if(nil,Urgent))
   Normal
Urgent:
   startFlash
   Timer(time,if(Urgent,VeryUrgent))
VeryUrgent:
   sendMessage("Player Sucks")
onClick:
    create(FoodMiddle(target))

FoodMiddle : 
target

onCreate:
   Timer(time,if(nil,Urgent))
   Normal
Urgent:
   startFlash
   Timer(time,if(Urgent,VeryUrgent))
VeryUrgent:
   sendMessage("Player Sucks")
onClick(left):
    create(FoodEnd(target))   
onClick(down):
    sendMessage("Add to Plate")


	
Scrubbing Game:

Cover:
onCreate:
  

onClick:
  remove(X,Y,Size,Shape)

