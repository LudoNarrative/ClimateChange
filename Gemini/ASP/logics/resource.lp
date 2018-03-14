logic(L) :- resource_logic(L).

:- resource_pool(L, _), not resource_logic(L).
