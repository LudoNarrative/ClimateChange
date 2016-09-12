
hasInitial(ENTITY,L) :- initialize(add(ENTITY,N,L)),
			N > 0.

initialize(add(ENTITY,0,location(ROW,COL))) :- not hasInitial(ENTITY,location(ROW,COL)),
					       entity(ENTITY),
					       rows(ROW),
					       columns(COL).

initialCount(ENTITY,COUNT) :- COUNT = TR + TC + TL + MR + MC +ML + BR + BC +BL,
			      initialize(add(ENTITY,TR,location(top,right))),
			      initialize(add(ENTITY,TC,location(top,center))),
			      initialize(add(ENTITY,TL,location(top,left))),
			      initialize(add(ENTITY,MR,location(middle,right))),
			      initialize(add(ENTITY,MC,location(middle,center))),
			      initialize(add(ENTITY,ML,location(middle,left))),
			      initialize(add(ENTITY,BR,location(bottom,right))),
			      initialize(add(ENTITY,BC,location(bottom,center))),
			      initialize(add(ENTITY,BL,location(bottom,left))).

:- initialCount(ENTITY,C),
   singular(ENTITY),
   C > 1.


in_between_horizontal(center,left,right).
in_between_horizontal(center,right,left).
in_between_vertical(middle,top,bottom).
in_between_vertical(middle,bottom,top).

location(Y,X) :- rows(Y),columns(X).

in_between(location(YM,XM),location(Y1,X1),location(Y2,X2)) :- 1 {in_between_horizontal(XM,X1,X2); in_between_vertical(YM,Y1,Y2)},
							       location(YM,XM),location(Y1,X1),location(Y2,X2).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% THIS PROBABLY NEEDS REWORKING
% How do we favor (but not exclusively do) specific structure "recipes"


% Don't put player and anything else in same starting location
:-
    initialize(add(Player,C1,L)),
    C1 > 0,
    interpretation(Player,player_controlled),
    initialize(add(Other,C2,L)),
    Player != Other,
    C2 > 0.


% Place Enemy between Player and Helper
:- not in_between(L2,L1,L3),
    initialize(add(Player,C1,L1)),
    C1 > 0,
    interpretation(Player,player_controlled),
    initialize(add(Enemy,C2,L2)),
    C2 > 0,
    interpretation(Enemy,enemy),
    initialize(add(Helper,C3,L3)),
    C3 > 0,
    interpretation(Helper,helper).

%% good(singular_player) :- singular(Player),
%%    initialize(add(Player,C1,L1)),
%%    interpretation(Player,player_controlled),
%%    C1 > 0,
   
      


		  
