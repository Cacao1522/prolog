% rep01: 第1回 演習課題レポート
% 提出日: 2024年4月18日
% 学籍番号: 34714037
% 名前: 加藤薫
%
%
% [述語の説明]
% parent(X,Y): XはYの親である
% father(X,Y): XはYの父親である
% female(X): Xは女性である
% male(X): Xは男性である
% offspring(Y,X): YはXの子孫である
% mother(X,Y): XはYの母親である
% grandparent(X,Y): XはYの祖父または祖母である
% sister(X,Y): XはYの姉妹である
% predecessor(X,Z): XはZの先祖である
% different(X,Y): XとYは別人である
% aunt(X,Y): XはYのおばである
% predecessor2(X,Z): XはZの先祖である
% regular(R): Rが水平と垂直な辺をもった矩形である
% /*ここから本当のPrologプログラムを書く*/
parent(pam,bob).
parent(tom,bob).
parent(tom,liz).
parent(bob,ann).
parent(bob,pat).
parent(pat,jim).

female(pam).
male(tom).
male(bob).
female(liz).
female(ann).
female(pat).
male(jim).

offspring(Y,X):-parent(X,Y).
mother(X,Y):-parent(X,Y),female(X).
grandparent(X,Z) :- parent(X,Y),parent(Y,Z).
sister(X,Y):-parent(Z,X),parent(Z,Y),female(X),different(X,Y).
predecessor(X,Z):-parent(X,Z).
predecessor(X,Z):-parent(X,Y),predecessor(Y,Z).
different(X,Y):-X\==Y.
aunt(X,Y):-parent(Z,Y),sister(X,Z).

predecessor2(X,Z) :-
        parent(X,Z).
predecessor2(X,Z) :-
        parent(Y,Z),
        predecessor2(X,Y).

regular(rectangle(point(X1,Y1),point(X2,Y1),point(X2,Y2),point(X1,Y2))).
/*
練習1.2 (教科書p.6) parent関係に関する次の質問をPrologで表せ．
(解答)
a) Patの親は誰か．
?- parent(X,Pat).
b) Lizは子どもをもつか．
?- parent(Liz,X).
c) Patの祖父母は誰か
?- grandparent(X,Pat).
(説明)
質問したいことを変数として引数に書く。

練習1.5 (教科書p.12) parentとsisterという関係を用いてaunt(X,Y)を定義せよ．
(解答)
aunt(X,Y):-parent(Z,Y),sister(X,Z).
(説明)
:-の左側に結論部を、右側に条件部を置く。Yから見てXをおばとしたい。
（実行例）
?- aunt(X,Y).
X = liz,
Y = ann ;
X = liz,
Y = pat ;
X = ann,
Y = jim ;
false.

練習1.6 (教科書p.18) 次に示すもう１つのpredecessor関係の定義について考察せよ．

      predecessor2(X,Z) :-
        parent(X,Z).

      predecessor2(X,Z) :-
        parent(Y,Z),
        predecessor2(X,Y).
(解答)
これもpredecessorの適切な定義と思える。元のpredecessorは下の世代から上の世代に向かって再帰的に呼び出されるのに対して、predecessor2は上の世代から下の世代に向かって再帰的に呼び出される。どちらのpredecessorでもすべての祖先関係を調べることができる。実行結果も同じであった。
（実行例）
?- predecessor(X,Z).
X = pam,
Z = bob ;
X = tom,
Z = bob ;
X = tom,
Z = liz ;
X = bob,
Z = ann ;
X = bob,
Z = pat ;
X = pat,
Z = jim ;
X = pam,
Z = ann ;
X = pam,
Z = pat ;
X = pam,
Z = jim ;
X = tom,
Z = ann ;
X = tom,(解答)
Z = pat ;
X = tom,
Z = jim ;
X = bob,
Z = jim ;
false.

?- predecessor2(X,Z).
X = pam,
Z = bob ;
X = tom,
Z = bob ;
X = tom,
Z = liz ;
X = bob,
Z = ann ;
X = bob,
Z = pat ;
X = pat,
Z = jim ;
X = pam,
Z = ann ;
X = tom,
Z = ann ;
X = pam,
Z = pat ;
X = tom,
Z = pat ;
X = bob,
Z = jim ;
X = pam,
Z = jim ;
X = tom,
Z = jim ;
false.

問題2.1 (教科書p.34)
  次のどれが構文的に正しいPrologオブジェクトであるか．
  それらはどんな種類のオブジェクト（アトム，数，変数，構造）か．
(解答)
     (a)Diana               正しい、変数
     (b)diana               正しい、アトム
     (c)'Diana'             正しい、アトム
     (d)_diana              正しい、変数
     (e)'Diana goes south'  正しい、アトム
     (f)goes(diana,south)   正しい、構造
     (g)45                  正しい、数
     (h)5(X,Y)              正しくない
     (i)+(north,west)       正しい、構造
     (j)three(Black(Cats))  正しい、構造
(説明)
アトムは小文字または特殊文字で始まる、または引用符で囲まれている。変数は大文字または_で始まる。構造は名前(引数1,引数2, ...) の形式である。構造の名前（関数子）はアトムでなければならないため(h)は正しくない。

問題2.3 (教科書p.40)
  次のマッチング操作は成功するか失敗するか．
  成功するなら，結果としてどのような変数の変数の具体化が得られるか．
(解答)
     (a)point(A,B)=point(1,2)   成功、A=1,B=2
     (b)point(A,B)=point(X,Y,Z) 失敗
     (c)plus(2,2)=4             失敗
     (d)+(2,D)=+(E,2)           成功、D=2,E=2
     (e)triangle(point(-1,0),P2,P3)=triangle(P1,point(1,0),point(0,Y))  成功、P1=point(-1,0),P2=point(1,0),P3=point(0,Y)  
(説明)
教科書p.37のマッチングの規則に従って判断する。(b)はアリティが異なるのでマッチングに失敗する。(c)は構造＝定数となっているのでマッチングに失敗する。
  （実行例）
?- point(A,B)=point(1,2).
A = 1,
B = 2.

?- point(A,B)=point(X,Y,Z).
false.

?- plus(2,2)=4.
false.

?- +(2,D) = +(E,2).
D = E, E = 2.

?- triangle(point(-1,0),P2,P3)=triangle(P1,point(1,0),point(0,Y)).
P2 = point(1, 0),
P3 = point(0, Y),
P1 = point(-1, 0).

    この結果得られる具体化は三角形のあるクラスを定義する．この三角形がどのようなものかを記述せよ．
(解答)X軸上の1と-1に2頂点を、Y軸上に1頂点をもつ二等辺三角形のクラス
(説明)得られる三角形は３頂点P1,P2,P3をもつ三角形であり、point(X,Y)は２次元座標を表し、point(0,Y)のYは変数である。

 問題2.5 (教科書p.40)
  矩形がrectangle(P1,P2,P3,P4)という項で表現されていると仮定せよ．
　ただしPは矩形の頂点で，正方向に順序づけられているとする．
　Rが水平と垂直な辺をもった矩形である場合に真となる関係

     regular(R) 

  を定義せよ．
  (解答)
  regular(rectangle(point(X1,Y1),point(X2,Y1),point(X2,Y2),point(X1,Y2))).
  (説明)
  rectangle(P1,P2,P3,P4)のP1,P2,P3,P4に頂点のクラスpoint(X,Y)を入れればよく、Rが水平と垂直な辺をもった矩形である場合はx座標が同じ２頂点が２組、y座標が同じ２頂点が２組存在するようにする。正方向に順序づけられているので、左下、右下、右上、左上の順番にする。
  （実行例）
?- regular(rectangle(point(0,0),point(2,0),point(2,2),point(0,2))).
true.

?- regular(rectangle(point(0,0),point(2,0),point(2,2),point(0,1))).
false.


*/
