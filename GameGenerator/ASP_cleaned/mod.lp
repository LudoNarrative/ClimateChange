
% only allow something to decrease on tick if it can be increased
:- 1 {result(tick, modify(decrease,R));
		result(tick, modify(decrease,R,_))},
	resource(R),
	0 {action(modify(increase,R));
		action(modify(increase,R,_))} 0.