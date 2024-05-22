cube :- read(X),process(X).
process(stop) :- !.
process(N) :-