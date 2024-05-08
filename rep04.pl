% rep04: 第4回 演習課題レポート
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

family(
    person(tom,fox,date(7,may,1950),works(bbc,15200)),
    person(ann,fox,date(9,may,1951),unemployed),
    [person(pat,fox,date(5,may,1973),unemployed),
    person(jim,fox,date(5,may,1973),unemployed),
    person(bob,fox,date(10,april,1976),unemployed)]
).
family(
    person(owen,douglas,date(4,august,1952),works(apple,20000)),
    person(cathy,douglas,date(11,june,1951),unemployed),
    [person(emma,douglas,date(1,july,1980),unemployed),
    person(alex,douglas,date(13,october,1983),unemployed)]
).
family(
    person(arthur,fox,date(4,august,1925),works(bbc,15500)),
    person(chloe,fox,date(17,june,1925),unemployed),
    [person(tom,fox,date(7,may,1950),works(bbc,15200)),
    person(cathy,douglas,date(11,june,1951),unemployed)]
).

dateofbirth(person(_,_,Date,_),Date).
parent(X,Y) :- family(X,_,Children),mem(Y,Children).
parent(X,Y) :- family(_,X,Children),mem(Y,Children).
grandparent(X,Z) :- parent(X,Y),parent(Y,Z).
different(X,Y):-X\==Y.
/*
練習4.2 (p.98)

    家族データベースで双子を見つけるために，twins(Child1,Child2)という関係を定義せよ．
    また，従兄弟を見つけるための述語cousin(P1,P2)という関係を定義せよ．
    血縁関係等を参考に各自でDBをつくり確認すること．
*/
twins(Child1,Child2) :- family(_,_,Children),del(Child1,Children,OtherChildren),mem(Child2,OtherChildren),dateofbirth(Child1,Date),dateofbirth(Child2,Date).
cousin(P1,P2) :- parent(X,Y),parent(Y,P1),parent(X,Z),parent(Z,P2),different(Y,Z).

/*（実行例）   

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

(説明)
第１引数をインクリメントまたは第２引数をデクリメントしながら調べる。bet(N1,N2,N1) :- N1 =< N2.で条件を満たしていればN1を出力する。N1==N2となるとN1 < N2を満たさず終了する。算術計算は（変数）is（計算式）という形式で書く。普通if文で書くところは連言でつなぐ。

問題3.9-別解
conc(A, B, C)とlength(D, E)(p.90)を用いてdividelist(F, G, H)の別解dividelist2(F, G, H)を定義せよ．
lengthは組込み述語が存在するので述語名をlenとせよ．

*/
dividelist2(List1,List2,List3) :- permutation(List1,P),conc(List2,List3,P), len(List1,L1), Len1 is L1//2, len(List3,Len3),Len1 =:= Len3.

/*（実行例）


(説明)
どう分割しても真偽判定ができるように分割前のリストを置換する。concを使って分割前リスト==分割後リストの結合かどうか判定し、さらに分割前リストの長さ//2==分割後の右のリストの長さかどうかを判定する。分割前リストの長さが奇数のときは分割後は左のリストの要素数が右のリストよりも１多くなるようにした。前回の問題3.9の例解は分割前リストの奇数番目が分割後左リストに、分割前リストの偶数番目が分割後右リストに入っていなければfalseになるが、この別解ではリストの中身がどうであれ２分割されていればtrueになるようにした。
*/