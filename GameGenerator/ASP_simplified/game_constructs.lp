
concept(up_to_up) :- precondition(control_event(button(up_arrow, held)),O1) ,
		     result(O1,moves(ENTITY,  north)).
concept(down_to_down) :- precondition(control_event(button(down_arrow, held)),O1) ,
		     result(O1,moves(ENTITY,  south)).
concept(left_to_left) :- precondition(control_event(button(left_arrow, held)),O1) ,
		     result(O1,moves(ENTITY,  west)).
concept(right_to_right) :- precondition(control_event(button(right_arrow, held)),O1) ,
			   result(O1,moves(ENTITY,  east)).

concept(horizontal_avatar) :- concept(left_to_left),
			      concept(right_to_right).

concept(vertical_avatar) :- concept(up_to_up),
			    concept(down_to_down).

concept(cardinal_avatar) :-concept(horizontal_avatar),
			   concept(vertical_avatar).


