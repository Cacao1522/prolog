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

naf(P) :- P,!,fail.
naf(_).
/*
問題5.2 (教科書p.133)

    次の関係は正数，零，負数の３つに数を分類する．
        class(Number,positive) :- Number>0.
        class(0,zero).
        class(Number,negative) :- Number<0.
    この手続きを，カットを使ってもっと効率的に定義せよ．
*/
class(Number,positive) :- Number>0,!.
class(0,zero) :- !.
class(Number,negative).

/*（実行例）   

(説明)
上の再帰ルールを適用する場合は第１引数のリストの要素が出力部分集合には残り、下の再帰ルールを適用する場合は第１引数のリストの要素が出力部分集合には残らない。これらのルールが非決定的に適応されるので、すべての部分集合を生成することができる。順番を入れ替えたものをすべて出力するために、リストの置換を生成する関係permutationを用意し、subsの後に適用させた。permutationを実現するためにdelとinsertも用意した。

練習4.5 (p.105)

    acceptsの実行時のループは，たとえばそこまでの動作回数を数えることにより回避できる．
    そうすると，シュミレータはある決められた長さの道だけを探すように求められる．acceptsをそのように修正せよ．
    教科書P.104のaccepts/2のプログラムでは無限ループに陥るようなオートマトンを用意して動作確認を行うこと．*/

accepts(S,[],_) :- final(S).
accepts(S,[X|Rest],MaxMoves) :- MaxMoves>0,trans(S,X,S1),NewMax is MaxMoves - 1,accepts(S1,Rest).
accepts(S,String,MaxMoves) :- MaxMoves>0,silent(S,S1),NewMax is MaxMoves - 1,accepts(S1,String,NewMax).

/*（実行例）


(説明)
flat([],[]).
flat(X,[X]).
を先にするとflat(Head,FlatHead),flat(Tail,FlatTail)がすぐに事実を満たしてしまい、出力が大量になる。flatの第1引数が[Head|Tail]に分割できる間、先頭Headのリストが外れるまで再帰的に呼び出される。その後リストTailの先頭のリストを同様の手順で外していく。
*/