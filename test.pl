% rep00: 第0回 演習課題レポート
% 提出日: 2024年4月10日
% 学籍番号: 34714037
% 名前: 加藤薫
%
% 練習X.Y △△関係を解くプログラム （テキスト???ページ）
% [述語の説明]
% parent(X,Y): XはYの親である
% father(X,Y): XはYの父親である
% ...
%
% /*ここから本当のPrologプログラムを書く*/
parent(pam,bob).
parent(tom,bob).
parent(tom,liz).
parent(bob,ann).
male(tom).
male(bob).
father(X,Y) :- parent(X,Y), male(X).
ancestor(X,Y) :- parent(X,Y).
ancestor(X,Y):-parent(X,Z),ancestor(Z,Y).%aaa
/*
（実行例）
?- grandparent(taro, X).
X = jiro ?
yes
...

?- ancestor(X,ann).
X = bob ;
X = pam ;
X = tom ;
false.
*/

/*
(説明，考察，評価)
...
*/

