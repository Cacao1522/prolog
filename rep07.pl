% rep07: 第7回 演習課題レポート
% 提出日: 2024年6月1日
% 学籍番号: 34714037
% 名前: 加藤薫
%
/*
問題7.3 (教科書p.175)

    述語ground(Term)を，具体化されていない変数がTermに含まれない
    なら真となるように定義せよ．
*/
gnd(Term) :-
    nonvar(Term),       % 変数ならfalse
    Term =.. [F|Args],  % ArgsにはTermがアトムなら[]が、構造なら引数のリストが入る
    gnd_check(Args). % 引数のリストの中に変数がないか再帰的に調べる

gnd_check([]).       
gnd_check([H|T]) :-
    gnd(H),          % リストの先頭が変数でないか確認
    gnd_check(T).    % リストの次の要素を調べる

/*（実行例）
?- gnd(a).
true.

?- gnd(X).
false.

?- gnd(p(a,1)).
true.

?- gnd([a,1]).
true.

?- gnd([a,A]).
false.

?- gnd([a,p(A)]).
false.

[trace]  ?- gnd(p(1,b(3,Y))).
   Call: (12) gnd(p(1, b(3, _9470))) ? creep
   Call: (13) nonvar(p(1, b(3, _9470))) ? creep
   Exit: (13) nonvar(p(1, b(3, _9470))) ? creep
   Call: (13) p(1, b(3, _9470))=..[_12414|_12416] ? creep
   Exit: (13) p(1, b(3, _9470))=..[p, 1, b(3, _9470)] ? creep
   Call: (13) gnd_check([1, b(3, _9470)]) ? creep
   Call: (14) gnd(1) ? creep
   Call: (15) nonvar(1) ? creep
   Exit: (15) nonvar(1) ? creep
   Call: (15) 1=..[_17276|_17278] ? creep
   Exit: (15) 1=..[1] ? creep
   Call: (15) gnd_check([]) ? creep
   Exit: (15) gnd_check([]) ? creep
   Exit: (14) gnd(1) ? creep
   Call: (14) gnd_check([b(3, _9470)]) ? creep
   Call: (15) gnd(b(3, _9470)) ? creep
   Call: (16) nonvar(b(3, _9470)) ? creep
   Exit: (16) nonvar(b(3, _9470)) ? creep
   Call: (16) b(3, _9470)=..[_24544|_24546] ? creep
   Exit: (16) b(3, _9470)=..[b, 3, _9470] ? creep
   Call: (16) gnd_check([3, _9470]) ? creep
   Call: (17) gnd(3) ? creep
   Call: (18) nonvar(3) ? creep
   Exit: (18) nonvar(3) ? creep
   Call: (18) 3=..[_29406|_29408] ? creep
   Exit: (18) 3=..[3] ? creep
   Call: (18) gnd_check([]) ? creep
   Exit: (18) gnd_check([]) ? creep
   Exit: (17) gnd(3) ? creep
   Call: (17) gnd_check([_58]) ? creep
   Call: (18) gnd(_58) ? creep
   Call: (19) nonvar(_58) ? creep
   Fail: (19) nonvar(_58) ? creep % 変数Yでfalse
   Fail: (18) gnd(_58) ? creep
   Fail: (17) gnd_check([_58]) ? creep
   Fail: (16) gnd_check([3, _58]) ? creep
   Fail: (15) gnd(b(3, _58)) ? creep
   Fail: (14) gnd_check([b(3, _58)]) ? creep
   Fail: (13) gnd_check([1, b(3, _58)]) ? creep
   Fail: (12) gnd(p(1, b(3, _58))) ? creep
false.

(説明)
Termが構造の場合、引数は複数ある可能性があり、構造の入れ子の数と引数の数だけループして変数が存在しないか調べるため、手続きgnd_checkを用意した。ArgsにはTermがアトムなら[]が入り、すぐにgnd_check([]). を満たす。
Termが構造の場合、Term =.. [F|Args]でFには関数子が入り、関数子はアトムでなければならないが、そもそも関数子がアトムでなければ実行時にエラーとなるので、Fがアトムかどうかの確認はしていない。
traceの実行例では、入れ子の構造の関数子とアリティを分解できていて、アリティに含まれている変数をnonvarで検出できている。

問題7.5 (教科書p.175)

         subsumes(Term1,Term2)
    という関係を，Term1がTerm2と等しいか一般的であるように定義せよ．
    たとえば，
         ?- subsumes(X,c).
         yes
         ?- subsumes(g(X),g(t(Y))).
         yes
         ?- subsumes(f(X,X),f(a,b)).
         no
    つまり，subsumes(Term1,Term2)は以下の式を満足するときに真を
    返す述語とする．
         HB(Term1)⊇HB(Term2)
    ここでHB(T)は項Tのエルブラン基底の集合を表す．
*/
naf(P) :- P,!,fail.
naf(_).
canmatch(Term1,Term2) :- naf(Term1=Term2),!,fail. % 項がマッチしないならカット
canmatch(Term1,Term2). % 項がマッチするならTrueを返す

% Term1が変数ならTrue
subsume(Term1, _) :- var(Term1), !.

% Term1とTerm2が同じアトムならTrue
subsume(Term1, Term2) :- atomic(Term1), atomic(Term2), Term1 == Term2, !.

% Term1とTerm2が構造またはリストで、同じ関数子とアリティを持つ（アリティは「右より左の方が一般的」でもよい）ならTrue
subsume(Term1, Term2) :-
    compound(Term1), compound(Term2),
    Term1 =.. [F|Args1],
    Term2 =.. [F|Args2],
    canmatch(Args1,Args2),
    subsume_check(Args1, Args2).

subsume_check([], []).
subsume_check([H1 | T1], [H2 | T2]) :-
    subsume(H1, H2),
    subsume_check(T1, T2).
    
/*（実行例）
?- subsume(c,c).
true.

?- subsume(X,c).
true.

?- subsume(c,X).
false.

?- subsume(g(X),g(t(Y))).
true.

?- subsume(g(t(X)),g(Y)).
false.

?- subsume([A,B,C],[a,b,C]).
true.

?- subsume([a,B,C],[A,b,C]).
false.

?- subsume([B,B,C],[A,b,C]).
true.

?- subsume([B,B,C],[a,b,C]).
false.

[trace]  ?- subsume(f(X,X),f(a,b)).
   Call: (12) subsume(f(_2554, _2554), f(a, b)) ? creep
   Call: (13) var(f(_2554, _2554)) ? creep
   Fail: (13) var(f(_2554, _2554)) ? creep
   Redo: (12) subsume(f(_2554, _2554), f(a, b)) ? creep
   Call: (13) atomic(f(_2554, _2554)) ? creep
   Fail: (13) atomic(f(_2554, _2554)) ? creep
   Redo: (12) subsume(f(_2554, _2554), f(a, b)) ? creep
   Call: (13) compound(f(_2554, _2554)) ? creep
   Exit: (13) compound(f(_2554, _2554)) ? creep
   Call: (13) compound(f(a, b)) ? creep
   Exit: (13) compound(f(a, b)) ? creep
   Call: (13) f(_2554, _2554)=..[_11970|_11972] ? creep
   Exit: (13) f(_2554, _2554)=..[f, _2554, _2554] ? creep
   Call: (13) f(a, b)=..[f|_13610] ? creep
   Exit: (13) f(a, b)=..[f, a, b] ? creep
   Call: (13) canmatch([_2554, _2554], [a, b]) ? creep
   Call: (14) naf([_2554, _2554]=[a, b]) ? creep
   Call: (15) [_2554, _2554]=[a, b] ? creep
   Fail: (15) [_2554, _2554]=[a, b] ? creep
   Redo: (14) naf([_2554, _2554]=[a, b]) ? creep
   Exit: (14) naf([_2554, _2554]=[a, b]) ? creep % マッチングができないのでfalse
   Call: (14) fail ? creep
   Fail: (14) fail ? creep
   Fail: (13) canmatch([_2554, _2554], [a, b]) ? creep
   Fail: (12) subsume(f(_2554, _2554), f(a, b)) ? creep
false.

(説明)
マッチするかどうかという情報だけでは一般的であるというのは判断できないので、オブジェクトの型によって判定方法を変えた。Term1が変数ならTerm2が何であれTrueとなる。Term1とTerm2が同じアトムならTrueとなる。
Term1とTerm2が構造またはリストの場合は、中身が条件を満たしているか再帰的に調べる必要があり、Term1 =.. [F|Args1], Term2 =.. [F|Args2]で同じ関数子を持っていることを確認し、canmatch(Args1,Args2)でマッチングできるかを調べ、subsume(f(X,X),f(a,b))のように具体化できない変数があればFalseを返す。
その後、手続きsubsume_check(Args1, Args2)で引数一組ずつに関して、Args2よりもArgs1の方が一般的かを調べる。
traceの実行例では、型判定、構造の関数子とアリティの分解はできていて、canmatchの中でマッチングが失敗してfalseになっている。

問題7.8 (教科書p.185)

与えられた集合(集合はリストで表わされるとする)のすべての部分集合の集合を
計算するために，関係powerset(Set,Subsets)をbagofを用いて定義せよ
*/
subs([],[]).
subs([Head|Tail],[Head|Sub]) :- subs(Tail,Sub). % 第１、第２引数ともに先頭を消す（出力部分集合には残る）
subs([_|Tail],Sub) :- subs(Tail,Sub). % 第１引数の先頭を消す（出力部分集合には残らない）

powerset(Set, Subsets) :- bagof(Subset, subs(Set, Subset), Subsets).

/*（実行例）
?- powerset([a],[[a],[]]).
true.

?- powerset([a],[[],[a]]).
false.

?- powerset([a,b,c],X).
X = [[a, b, c], [a, b], [a, c], [a], [b, c], [b], [c], []].

?- powerset([a,b,a],X).
X = [[a, b, a], [a, b], [a, a], [a], [b, a], [b], [a], []].

[trace]  ?- powerset([a,b],X).
   Call: (12) powerset([a, b], _24986) ? creep
^  Call: (13) bagof(_26332, subs([a, b], _26332), _24986) ? creep
   Call: (18) subs([a, b], _26332) ? creep
   Call: (19) subs([b], _28024) ? creep
   Call: (20) subs([], _28840) ? creep
   Exit: (20) subs([], []) ? creep
   Exit: (19) subs([b], [b]) ? creep
   Exit: (18) subs([a, b], [a, b]) ? creep
   Redo: (19) subs([b], _28024) ? creep
   Call: (20) subs([], _28024) ? creep
   Exit: (20) subs([], []) ? creep
   Exit: (19) subs([b], []) ? creep
   Exit: (18) subs([a, b], [a]) ? creep
   Redo: (18) subs([a, b], _26332) ? creep
   Call: (19) subs([b], _26332) ? creep
   Call: (20) subs([], _37756) ? creep
   Exit: (20) subs([], []) ? creep
   Exit: (19) subs([b], [b]) ? creep
   Exit: (18) subs([a, b], [b]) ? creep
   Redo: (19) subs([b], _26332) ? creep
   Call: (20) subs([], _26332) ? creep
   Exit: (20) subs([], []) ? creep
   Exit: (19) subs([b], []) ? creep
   Exit: (18) subs([a, b], []) ? creep
^  Exit: (13) bagof(_26332, user:subs([a, b], _26332), [[a, b], [a], [b], []]) ? creep
   Exit: (12) powerset([a, b], [[a, b], [a], [b], []]) ? creep
X = [[a, b], [a], [b], []].

(説明)
bagofによってsubsのすべての解をリストに集めて出力することができる。subs(Set, Subset)をbagofの第一引数に、出力Subsetを第二引数に、powersetの出力Subsetsを第三引数に置けばよい。
traceの結果を見るとbagofは組み込み手続きだからなのか、bagofの処理は出力されなかった。
作成したpowersetはbagofの仕様上、第一引数にリスト、第二引数に変数という使い方以外の使い方はうまくできない場合が多い。
*/