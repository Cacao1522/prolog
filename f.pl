apple.
p(a).
3.
p(t(b)).
parent(pam,bob).
mem(X,[X | Tail]).
mem(X, [Head | Tail]) :- mem(X, Tail).
