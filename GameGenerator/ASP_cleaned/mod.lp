
    
:- action(move(Entity,direction(away,_))),
   not action(apply_restitution(Entity,Entity)).