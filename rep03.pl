% rep03: 第3回 演習課題レポート
% 提出日: 2024年5月6日
% 学籍番号: 34714037
% 名前: 加藤薫
%
%
% [述語の説明]
% mem(X,Y): XがY中に出現するなら真である
% conc(L1,L2,L3): リストL1とリストL2を連結するとリストL3になるなら真である
% del(X,L,L1): リストLから項目Xを削除する
% insert(X,L,L1): リストLの任意の場所に項目Xを挿入する
% len(List,N): NはリストListの長さ
% /*ここから本当のPrologプログラムを書く*/
mem(X,[X | Tail]).
mem(X, [Head | Tail]) :- mem(X, Tail).

conc([], L, L).
conc([X|L1], L2, [X|L3]) :- conc(L1, L2, L3).

del(X,[X|Tail],Tail).
del(X,[Y|Tail],[Y|Tail1]) :-del(X,Tail,Tail1).
insert(X,List,BiggerList) :- del(X,BiggerList,List).

:- op(300,xfx,plays).
:- op(200,xfy,and).

len([],0).
len([_|Tail],N) :- len(Tail,N1), N is 1 + N1.
/*
問題3.8 (教科書p.79)

    関係
    	subs(Set,Subset)
    を定義せよ．ただし，SetとSubsetは集合を表すリストである．この関
    係は，部分集合関係を調べるだけではなく，与えられた集合の可能な部
    分集合をすべて生成するためにも使えるようにしたい．たとえば
    	?- subs([a,b,c],S).
    	S=[a,b,c];
    	S=[b,c];
    	S=[c];
    	S=[];
    	S=[a,c];
    	S=[a];
    	…  */

subs([],[]).
subs([Head|Tail],[Head|Sub]) :- subs(Tail,Sub). % 第１、第２引数ともに先頭を消す（出力部分集合には残る）
subs([_|Tail],Sub) :- subs(Tail,Sub). % 第１引数の先頭を消す（出力部分集合には残らない）

permutation([],[]).
permutation([X|L],P) :- permutation(L,L1),insert(X,L1,P).
subs2(A,P) :- subs(A,B),permutation(B,P).
/*（実行例）   
?- subs([a,b,c],S).
S = [a, b, c] ;
S = [a, b] ;
S = [a, c] ;
S = [a] ;
S = [b, c] ;
S = [b] ;
S = [c] ;
S = [].

?- subs([a,b,c],[a]).
true ;
false.

?- subs([a,b,c],[a,d]).
false.

?- subs2([a,b,c],S).
S = [a, b, c] ;
S = [b, a, c] ;
S = [b, c, a] ;
S = [a, c, b] ;
S = [c, a, b] ;
S = [c, b, a] ;
S = [a, b] ;
S = [b, a] ;
S = [a, c] ;
S = [c, a] ;
S = [a] ;
S = [b, c] ;
S = [c, b] ;
S = [b] ;
S = [c] ;
S = [].

[trace]  ?- subs([a,b,c],S).
   Call: (12) subs([a, b, c], _30174) ? creep
   Call: (13) subs([b, c], _31526) ? creep
   Call: (14) subs([c], _32342) ? creep
   Call: (15) subs([], _33158) ? creep
   Exit: (15) subs([], []) ? creep
   Exit: (14) subs([c], [c]) ? creep
   Exit: (13) subs([b, c], [b, c]) ? creep
   Exit: (12) subs([a, b, c], [a, b, c]) ? creep
S = [a, b, c] ;
   Redo: (14) subs([c], _32342) ? creep
   Call: (15) subs([], _32342) ? creep
   Exit: (15) subs([], []) ? creep
   Exit: (14) subs([c], []) ? creep % cはsubs([_|Tail],Sub) :- subs(Tail,Sub). が適用されている
   Exit: (13) subs([b, c], [b]) ? creep
   Exit: (12) subs([a, b, c], [a, b]) ? creep
S = [a, b] ;
   Redo: (13) subs([b, c], _31526) ? creep
   Call: (14) subs([c], _31526) ? creep
   Call: (15) subs([], _46726) ? creep
   Exit: (15) subs([], []) ? creep
   Exit: (14) subs([c], [c]) ? creep
   Exit: (13) subs([b, c], [c]) ? creep
   Exit: (12) subs([a, b, c], [a, c]) ? creep
S = [a, c] .
以下省略
(説明)
上の再帰ルールを適用する場合は第１引数のリストの要素が出力部分集合には残り、下の再帰ルールを適用する場合は第１引数のリストの要素が出力部分集合には残らない。これらのルールが非決定的に適応されるので、すべての部分集合を生成することができる。順番を入れ替えたものをすべて出力するために、リストの置換を生成する関係permutationを用意し、subsの後に適用させた。permutationを実現するためにdelとinsertも用意した。

問題3.11 (教科書p.80)

関係
	flat(List,FlatList)
を定義せよ．ただしListはリストのリストで，FlatListはListの部分リスト(またはそのまた部分リスト)の要素が
平板なリストとなるように，Listを平滑化したものである．たとえば，
	?-flat([a,b,[c,d],[],[[[e]]],f],L).
	  L=[a,b,c,d,e,f]*/

flat([Head|Tail],List) :- flat(Head,FlatHead),flat(Tail,FlatTail),conc(FlatHead,FlatTail,List). 
flat([],[]). % 空リストのflat(Head,FlatHead)flat(Tail,FlatTail)、多重リストのflat(Tail,FlatTail)はこれを満たす
flat(X,[X]) :- atomic(X),X \== []. % 通常要素、多重リストのflat(Head,FlatHead)はこれを満たす

/*（実行例）
?- flat([a,b,[c,d],[],[[[e]]],f],L).
L = [a, b, c, d, e, f] ;
L = [a, b, c, d, e, f, []] ;
L = [a, b, c, d, e, [f]] ;
以下省略

[trace]  ?- flat([a,[b],[],[[c]],d],L).
   Call: (12) flat([a, [b], [], [[c]], d], _39240) ? creep
   Call: (13) flat(a, _40662) ? creep
   Exit: (13) flat(a, [a]) ? creep	% FlatHead=[a]
   Call: (13) flat([[b], [], [[c]], d], _42290) ? creep
   Call: (14) flat([b], _43102) ? creep
   Call: (15) flat(b, _43914) ? creep
   Exit: (15) flat(b, [b]) ? creep 	% Head=b,FlatHead=[b]
   Call: (15) flat([], _45542) ? creep
   Exit: (15) flat([], []) ? creep 	% Tail=[],FlatTail=[]
   Call: (15) conc([b], [], _43102) ? creep
   Call: (16) conc([], [], _47982) ? creep
   Exit: (16) conc([], [], []) ? creep
   Exit: (15) conc([b], [], [b]) ? creep
   Exit: (14) flat([b], [b]) ? creep 	% [b]の復元完了
   Call: (14) flat([[], [[c]], d], _51236) ? creep
   Call: (15) flat([], _52048) ? creep
   Exit: (15) flat([], []) ? creep 	% FlatHead=[]
   Call: (15) flat([[[c]], d], _53670) ? creep
   Call: (16) flat([[c]], _54482) ? creep
   Call: (17) flat([c], _55294) ? creep
   Call: (18) flat(c, _56106) ? creep
   Exit: (18) flat(c, [c]) ? creep 	% FlatHead=[c]
   Call: (18) flat([], _57734) ? creep
   Exit: (18) flat([], []) ? creep % FlatTail=[]
   Call: (18) conc([c], [], _55294) ? creep
   Call: (19) conc([], [], _60174) ? creep
   Exit: (19) conc([], [], []) ? creep
   Exit: (18) conc([c], [], [c]) ? creep
   Exit: (17) flat([c], [c]) ? creep % FlatHead=[c]
   Call: (17) flat([], _63428) ? creep
   Exit: (17) flat([], []) ? creep % FlatTail=[]
   Call: (17) conc([c], [], _198) ? creep
   Call: (18) conc([], [], _1822) ? creep
   Exit: (18) conc([], [], []) ? creep
   Exit: (17) conc([c], [], [c]) ? creep
   Exit: (16) flat([[c]], [c]) ? creep	% [[c]]の復元完了
   Call: (16) flat([d], _5076) ? creep
   Call: (17) flat(d, _5888) ? creep
   Exit: (17) flat(d, [d]) ? creep	% FlatHead=[d]
   Call: (17) flat([], _7516) ? creep
   Exit: (17) flat([], []) ? creep % FlatTail=[]
   Call: (17) conc([d], [], _5076) ? creep
   Call: (18) conc([], [], _9956) ? creep
   Exit: (18) conc([], [], []) ? creep
   Exit: (17) conc([d], [], [d]) ? creep % [Head|Tail]の分割完了、復元開始
   Exit: (16) flat([d], [d]) ? creep 	% FlatTail=[d]
   Call: (16) conc([c], [d], _196) ? creep
   Call: (17) conc([], [d], _14028) ? creep
   Exit: (17) conc([], [d], [d]) ? creep
   Exit: (16) conc([c], [d], [c, d]) ? creep
   Exit: (15) flat([[[c]], d], [c, d]) ? creep % FlatTail=[c, d]
   Call: (15) conc([], [c, d], _192) ? creep
   Exit: (15) conc([], [c, d], [c, d]) ? creep
   Exit: (14) flat([[], [[c]], d], [c, d]) ? creep % FlatTail=[c, d]
   Call: (14) conc([b], [c, d], _172) ? creep
   Call: (15) conc([], [c, d], _20538) ? creep
   Exit: (15) conc([], [c, d], [c, d]) ? creep
   Exit: (14) conc([b], [c, d], [b, c, d]) ? creep
   Exit: (13) flat([[b], [], [[c]], d], [b, c, d]) ? creep % FlatTail=[b, c, d]
   Call: (13) conc([a], [b, c, d], _58) ? creep
   Call: (14) conc([], [b, c, d], _24610) ? creep
   Exit: (14) conc([], [b, c, d], [b, c, d]) ? creep
   Exit: (13) conc([a], [b, c, d], [a, b, c, d]) ? creep
   Exit: (12) flat([a, [b], [], [[c]], d], [a, b, c, d]) ? creep % FlatTail=[a, b, c, d]
L = [a, b, c, d] .

(説明)
flat([],[]).
flat(X,[X]).
を先にするとflat(Head,FlatHead),flat(Tail,FlatTail)がすぐに事実を満たしてしまい、出力が大量になる。flatの第1引数が[Head|Tail]に分割できる間、先頭Headのリストが外れるまで再帰的に呼び出される。その後リストTailの先頭のリストを同様の手順で外していく。


問題3.12 (教科書p.85)  
    :- op(300,xfx,plays).
    :- op(200,xfy,and).
というオペレータ定義を仮定すると，次の2つの項は構文的に正しいオブジェクトである．
    Term1 = jimmy plays football and squash
    Term2 = susan plays tennis and basketball and volleyball
これらの項はPrologによりいかに解釈されるか．その主関数子と構造を示せ．

Term1 = plays(jimmy,and(football,squash))
Term2 = plays(susan,and(tennis,and(basketball, volleyball)))

（実行例）
?- Term1 = jimmy plays football and squash.
Term1 = jimmy plays football and squash.

?- Term1 = plays(jimmy,and(football,squash)).
Term1 = jimmy plays football and squash.

?- Term1 = and(plays(jimmy,football),squash).
Term1 = (jimmy plays football)and squash.

?- Term2 = susan plays tennis and basketball and volleyball.
Term2 = susan plays tennis and basketball and volleyball.

?- Term2 = plays(susan,and(tennis,and(basketball, volleyball))).
Term2 = susan plays tennis and basketball and volleyball.

?- Term2 = plays(susan,and(and(tennis,basketball), volleyball)).
Term2 = susan plays (tennis and basketball)and volleyball.

?- Term3 = jimmy and susan plays football and (bob plays tennis).
Term3 = jimmy and susan plays football and (bob plays tennis).

?- Term3 = plays(and(plays(and(jimmy, susan), football),bob), tennis).
Term3 = (jimmy and susan plays football)and bob plays tennis.

?- Term3 = and(plays(and(jimmy, susan), football),plays(bob, tennis)).
Term3 = (jimmy and susan plays football)and(bob plays tennis).
(説明)
オペレータは順位が低いほど結合力が強いので、playsよりもandの方が先に結合する。andはxfyなので、andが連続する場合は右のandが先に結合する。実行結果を見ると、構文的に正しければ括弧なしで表現できている。Term3はplaysが２つあるが、playsはxfxなので括弧を使わなければ構文的に正しくない。

問題3.21 (教科書p.92)  
手続き
    bet(N1,N2,X)
が，与えられた２つの整数N1,N2に対して，制約N1≦X≦N2を満たすすべての整数Xをバックトラックにより
生成するよう定義せよ．
*/
bet(N1,N2,N1) :- N1 =< N2.
bet(N1,N2,X) :- N1 < N2, N1_new is N1 + 1, bet(N1_new,N2,X).
% または
bet2(N1,N2,N2) :- N1 =< N2.
bet2(N1,N2,X) :- N1 < N2, N2_new is N2 - 1, bet2(N1,N2_new,X).

/*（実行例）
?- bet(1,3,X).
X = 1 ;
X = 2 ;
X = 3 ;
false.

?- bet(2,1,X).
false.

?- bet(1,2,1).
true ;
false.

?- bet(1,2,3).
false.

?- bet2(1,3,X).
X = 3 ;
X = 2 ;
X = 1 ;
false.

[trace]  ?- bet(1,2,X).
   Call: (12) bet(1, 2, _76936) ? creep
   Call: (13) 1=<2 ? creep
   Exit: (13) 1=<2 ? creep % N1 =< N2が成立
   Exit: (12) bet(1, 2, 1) ? creep % X=1で成立
X = 1 ;
   Redo: (12) bet(1, 2, _76936) ? creep
   Call: (13) 1<2 ? creep
   Exit: (13) 1<2 ? creep % N1 < N2が成立
   Call: (13) _84626 is 1+1 ? creep
   Exit: (13) 2 is 1+1 ? creep % N1_new=2で成立
   Call: (13) bet(2, 2, _76936) ? creep
   Call: (14) 2=<2 ? creep
   Exit: (14) 2=<2 ? creep % N1 =< N2が成立
   Exit: (13) bet(2, 2, 2) ? creep % 復元中
   Exit: (12) bet(1, 2, 2) ? creep % X=2で成立
X = 2 ;
   Redo: (13) bet(2, 2, _76936) ? creep
   Call: (14) 2<2 ? creep
   Fail: (14) 2<2 ? creep % N1 < N2が不成立
   Fail: (13) bet(2, 2, _76936) ? creep
   Fail: (12) bet(1, 2, _76936) ? creep
false.
(説明)
第１引数をインクリメントまたは第２引数をデクリメントしながら調べる。bet(N1,N2,N1) :- N1 =< N2.で条件を満たしていればN1を出力する。N1==N2となるとN1 < N2を満たさず終了する。算術計算は（変数）is（計算式）という形式で書く。普通if文で書くところは連言でつなぐ。

問題3.9-別解
conc(A, B, C)とlength(D, E)(p.90)を用いてdividelist(F, G, H)の別解dividelist2(F, G, H)を定義せよ．
lengthは組込み述語が存在するので述語名をlenとせよ．

*/
dividelist2(List1,List2,List3) :- permutation(List1,P),conc(List2,List3,P), len(List1,L1), Len1 is L1//2, len(List3,Len3),Len1 =:= Len3.

/*（実行例）
?- dividelist2([a,b,c,d,e],[a,c,e],[b,d]).
true ;
false.

?- dividelist2([a,b,c],[a,b],[c]).
true ;
false.

?- dividelist2([a,b,c],[a,b,c],[]).
false.

?- dividelist2([a,b,c],[b],[a,c]).
false.

[trace]  ?- dividelist2([a,b,c],[a,b],[c]).
   Call: (12) dividelist2([a, b, c], [a, b], [c]) ? creep
   Call: (13) permutation([a, b, c], _35822) ? creep
   Call: (14) permutation([b, c], _36634) ? creep
   Call: (15) permutation([c], _37446) ? creep
   Call: (16) permutation([], _38258) ? creep
   Exit: (16) permutation([], []) ? creep
   Call: (16) insert(c, [], _37446) ? creep
   Call: (17) del(c, _37446, []) ? creep
   Exit: (17) del(c, [c], []) ? creep
   Exit: (16) insert(c, [], [c]) ? creep
   Exit: (15) permutation([c], [c]) ? creep
   Call: (15) insert(b, [c], _36634) ? creep
   Call: (16) del(b, _36634, [c]) ? creep
   Exit: (16) del(b, [b, c], [c]) ? creep
   Exit: (15) insert(b, [c], [b, c]) ? creep
   Exit: (14) permutation([b, c], [b, c]) ? creep
   Call: (14) insert(a, [b, c], _35822) ? creep
   Call: (15) del(a, _35822, [b, c]) ? creep
   Exit: (15) del(a, [a, b, c], [b, c]) ? creep
   Exit: (14) insert(a, [b, c], [a, b, c]) ? creep
   Exit: (13) permutation([a, b, c], [a, b, c]) ? creep % P=[a, b, c]
   Call: (13) conc([a, b], [c], [a, b, c]) ? creep
   Call: (14) conc([b], [c], [b, c]) ? creep
   Call: (15) conc([], [c], [c]) ? creep
   Exit: (15) conc([], [c], [c]) ? creep
   Exit: (14) conc([b], [c], [b, c]) ? creep
   Exit: (13) conc([a, b], [c], [a, b, c]) ? creep % List2=[a, b],List3=[c]
   Call: (13) len([a, b, c], _56980) ? creep
   Call: (14) len([b, c], _57792) ? creep
   Call: (15) len([c], _58604) ? creep
   Call: (16) len([], _59416) ? creep
   Exit: (16) len([], 0) ? creep
   Call: (16) _58604 is 1+0 ? creep
   Exit: (16) 1 is 1+0 ? creep
   Exit: (15) len([c], 1) ? creep
   Call: (15) _57792 is 1+1 ? creep
   Exit: (15) 2 is 1+1 ? creep
   Exit: (14) len([b, c], 2) ? creep
   Call: (14) _166 is 1+2 ? creep
   Exit: (14) 3 is 1+2 ? creep
   Exit: (13) len([a, b, c], 3) ? creep % L1=3
   Call: (13) _4212 is 3//2 ? creep
   Exit: (13) 1 is 3//2 ? creep % Len1=1
   Call: (13) len([c], _5840) ? creep
   Call: (14) len([], _6652) ? creep
   Exit: (14) len([], 0) ? creep
   Call: (14) _5840 is 1+0 ? creep
   Exit: (14) 1 is 1+0 ? creep
   Exit: (13) len([c], 1) ? creep % Len3=1
   Call: (13) 1=:=1 ? creep
   Exit: (13) 1=:=1 ? creep % 1==1が成立
   Exit: (12) dividelist2([a, b, c], [a, b], [c]) ? creep
true .

(説明)
どう分割しても真偽判定ができるように分割前のリストを置換する。concを使って分割前リスト==分割後リストの結合かどうか判定し、さらに分割前リストの長さ//2==分割後の右のリストの長さかどうかを判定する。分割前リストの長さが奇数のときは分割後は左のリストの要素数が右のリストよりも１多くなるようにした。前回の問題3.9の例解は分割前リストの奇数番目が分割後左リストに、分割前リストの偶数番目が分割後右リストに入っていなければfalseになるが、この別解ではリストの中身がどうであれ２分割されていればtrueになるようにした。
*/