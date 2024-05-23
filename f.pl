apple.
p(a).
3.
p(t(b)).
parent(pam,bob).
parent(tom,bob).
parent(p(a),t(b)).
bob.
p(S).
mem(X,[X | Tail]).
mem(X, [Head | Tail]) :- mem(X, Tail).