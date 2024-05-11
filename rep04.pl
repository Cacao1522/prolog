% rep04: 第4回 演習課題レポート
% 提出日: 2024年5月11日
% 学籍番号: 34714037
% 名前: 加藤薫
%
%
% [述語の説明]
% mem(X,Y): XがY中に出現するなら真である
% conc(L1,L2,L3): リストL1とリストL2を連結するとリストL3になるなら真である
% del(X,L,L1): リストLから項目Xを削除する
% family(P): Pは家族である
% dateofbirth(P,D): Pの生年月日はDである
% parent(X,Y): XはYの親である
% grandparent(X,Y): XはYの祖父または祖母である
% different(X,Y): XとYは別人である
% final(S): Sはオートマトンの受理状態
% trans(S1,X,S2): その時点の入力記号がXであるとき状態S1からS2への園医が可能なことを意味する状態遷移
% silent(S1,S2): S1からS2への空動作
% /*ここから本当のPrologプログラムを書く*/
mem(X,[X | Tail]).
mem(X, [Head | Tail]) :- mem(X, Tail).

conc([], L, L).
conc([X|L1], L2, [X|L3]) :- conc(L1, L2, L3).

del(X,[X|Tail],Tail).
del(X,[Y|Tail],[Y|Tail1]) :-del(X,Tail,Tail1).

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
different(X,Y) :- X\==Y.

final(s4).
trans(s1,a,s1).
% trans(s1,a,s2).
trans(s3,a,s4).
trans(s1,b,s1).
trans(s2,b,s3).
trans(s3,b,s4).

silent(s2,s4).
silent(s3,s1).
silent(s1,s3).
/*
練習4.2 (p.98)

    家族データベースで双子を見つけるために，twins(Child1,Child2)という関係を定義せよ．
    また，従兄弟を見つけるための述語cousin(P1,P2)という関係を定義せよ．
    血縁関係等を参考に各自でDBをつくり確認すること．
*/
twins(Child1,Child2) :- family(_,_,Children),del(Child1,Children,OtherChildren),mem(Child2,OtherChildren),dateofbirth(Child1,Date),dateofbirth(Child2,Date).
twins2(Child1,Child2) :- family(_,_,Children),mem(Child1,Children),mem(Child2,Children),dateofbirth(Child1,Date),dateofbirth(Child2,Date),different(Child1,Child2).
twins3(Child1,Child2) :- parent(X,Child1),parent(X,Child2),dateofbirth(Child1,Date),dateofbirth(Child2,Date),different(Child1,Child2).
cousin(P1,P2) :- parent(X,Y),parent(Y,P1),parent(X,Z),parent(Z,P2),different(Y,Z).

/*（実行例）
?- twins(Child1,Child2).
Child1 = person(pat, fox, date(5, may, 1973), unemployed),
Child2 = person(jim, fox, date(5, may, 1973), unemployed) ;
Child1 = person(jim, fox, date(5, may, 1973), unemployed),
Child2 = person(pat, fox, date(5, may, 1973), unemployed) ;
false.

?- twins2(Child1,Child2).
Child1 = person(pat, fox, date(5, may, 1973), unemployed),
Child2 = person(jim, fox, date(5, may, 1973), unemployed) ;
Child1 = person(jim, fox, date(5, may, 1973), unemployed),
Child2 = person(pat, fox, date(5, may, 1973), unemployed) ;
false.

[trace]  ?- twins(Child1,Child2).
   Call: (12) twins(_25120, _25122) ? creep
   Call: (13) family(_26522, _26524, _26448) ? creep
   Exit: (13) family(person(tom, fox, date(7, may, 1950), works(bbc, 15200)), person(ann, fox, date(9, may, 1951), unemployed), [person(pat, fox, date(5, may, 1973), unemployed), person(jim, fox, date(5, may, 1973), unemployed), person(bob, fox, date(10, april, 1976), unemployed)]) ? creep
   Call: (13) del(_25120, [person(pat, fox, date(5, may, 1973), unemployed), person(jim, fox, date(5, may, 1973), unemployed), person(bob, fox, date(10, april, 1976), unemployed)], _28192) ? creep
   Exit: (13) del(person(pat, fox, date(5, may, 1973), unemployed), [person(pat, fox, date(5, may, 1973), unemployed), person(jim, fox, date(5, may, 1973), unemployed), person(bob, fox, date(10, april, 1976), unemployed)], [person(jim, fox, date(5, may, 1973), unemployed), person(bob, fox, date(10, april, 1976), unemployed)]) ? creep % person(pat, fox, date(5, may, 1973), unemployed)を削除
   Call: (13) mem(_25122, [person(jim, fox, date(5, may, 1973), unemployed), person(bob, fox, date(10, april, 1976), unemployed)]) ? creep
   Exit: (13) mem(person(jim, fox, date(5, may, 1973), unemployed), [person(jim, fox, date(5, may, 1973), unemployed), person(bob, fox, date(10, april, 1976), unemployed)]) ? creep % memが成立
   Call: (13) dateofbirth(person(pat, fox, date(5, may, 1973), unemployed), _31442) ? creep
   Exit: (13) dateofbirth(person(pat, fox, date(5, may, 1973), unemployed), date(5, may, 1973)) ? creep
   Call: (13) dateofbirth(person(jim, fox, date(5, may, 1973), unemployed), date(5, may, 1973)) ? creep
   Exit: (13) dateofbirth(person(jim, fox, date(5, may, 1973), unemployed), date(5, may, 1973)) ? creep % dateofbirthが成立
   Exit: (12) twins(person(pat, fox, date(5, may, 1973), unemployed), person(jim, fox, date(5, may, 1973), unemployed)) ? creep
Child1 = person(pat, fox, date(5, may, 1973), unemployed),
Child2 = person(jim, fox, date(5, may, 1973), unemployed) .
以下省略

?- cousin(P1,P2).
P1 = person(pat, fox, date(5, may, 1973), unemployed),
P2 = person(emma, douglas, date(1, july, 1980), unemployed) ;
P1 = person(pat, fox, date(5, may, 1973), unemployed),
P2 = person(alex, douglas, date(13, october, 1983), unemployed) ;
P1 = person(jim, fox, date(5, may, 1973), unemployed),
P2 = person(emma, douglas, date(1, july, 1980), unemployed) ;
P1 = person(jim, fox, date(5, may, 1973), unemployed),
P2 = person(alex, douglas, date(13, october, 1983), unemployed) ;
P1 = person(bob, fox, date(10, april, 1976), unemployed),
P2 = person(emma, douglas, date(1, july, 1980), unemployed) ;
P1 = person(bob, fox, date(10, april, 1976), unemployed),
P2 = person(alex, douglas, date(13, october, 1983), unemployed) ;
P1 = person(emma, douglas, date(1, july, 1980), unemployed),
P2 = person(pat, fox, date(5, may, 1973), unemployed) ;
P1 = person(emma, douglas, date(1, july, 1980), unemployed),
P2 = person(jim, fox, date(5, may, 1973), unemployed) ;
P1 = person(emma, douglas, date(1, july, 1980), unemployed),
P2 = person(bob, fox, date(10, april, 1976), unemployed) ;
P1 = person(alex, douglas, date(13, october, 1983), unemployed),
P2 = person(pat, fox, date(5, may, 1973), unemployed) ;
P1 = person(alex, douglas, date(13, october, 1983), unemployed),
P2 = person(jim, fox, date(5, may, 1973), unemployed) ;
P1 = person(alex, douglas, date(13, october, 1983), unemployed),
P2 = person(bob, fox, date(10, april, 1976), unemployed) ;
P1 = person(pat, fox, date(5, may, 1973), unemployed),
P2 = person(emma, douglas, date(1, july, 1980), unemployed) ;
P1 = person(pat, fox, date(5, may, 1973), unemployed),
P2 = person(alex, douglas, date(13, october, 1983), unemployed) ;
P1 = person(jim, fox, date(5, may, 1973), unemployed),
P2 = person(emma, douglas, date(1, july, 1980), unemployed) ;
P1 = person(jim, fox, date(5, may, 1973), unemployed),
P2 = person(alex, douglas, date(13, october, 1983), unemployed) ;
P1 = person(bob, fox, date(10, april, 1976), unemployed),
P2 = person(emma, douglas, date(1, july, 1980), unemployed) ;
P1 = person(bob, fox, date(10, april, 1976), unemployed),
P2 = person(alex, douglas, date(13, october, 1983), unemployed) ;
P1 = person(emma, douglas, date(1, july, 1980), unemployed),
P2 = person(pat, fox, date(5, may, 1973), unemployed) ;
P1 = person(emma, douglas, date(1, july, 1980), unemployed),
P2 = person(jim, fox, date(5, may, 1973), unemployed) ;
P1 = person(emma, douglas, date(1, july, 1980), unemployed),
P2 = person(bob, fox, date(10, april, 1976), unemployed) ;
P1 = person(alex, douglas, date(13, october, 1983), unemployed),
P2 = person(pat, fox, date(5, may, 1973), unemployed) ;
P1 = person(alex, douglas, date(13, october, 1983), unemployed),
P2 = person(jim, fox, date(5, may, 1973), unemployed) ;
P1 = person(alex, douglas, date(13, october, 1983), unemployed),
P2 = person(bob, fox, date(10, april, 1976), unemployed) ;
false.

[trace]  ?- cousin(person(pat, fox, date(5, may, 1973), unemployed),person(emma, douglas, date(1, july, 1980), unemployed)).
   Call: (12) cousin(person(pat, fox, date(5, may, 1973), unemployed), person(emma, douglas, date(1, july, 1980), unemployed)) ? creep
   Call: (13) parent(_16766, _16768) ? creep
   Call: (14) family(_16766, _17656, _17580) ? creep
   Exit: (14) family(person(tom, fox, date(7, may, 1950), works(bbc, 15200)), person(ann, fox, date(9, may, 1951), unemployed), [person(pat, fox, date(5, may, 1973), unemployed), person(jim, fox, date(5, may, 1973), unemployed), person(bob, fox, date(10, april, 1976), unemployed)]) ? creep
   Call: (14) mem(_16768, [person(pat, fox, date(5, may, 1973), unemployed), person(jim, fox, date(5, may, 1973), unemployed), person(bob, fox, date(10, april, 1976), unemployed)]) ? creep
   Exit: (14) mem(person(pat, fox, date(5, may, 1973), unemployed), [person(pat, fox, date(5, may, 1973), unemployed), person(jim, fox, date(5, may, 1973), unemployed), person(bob, fox, date(10, april, 1976), unemployed)]) ? creep
   Exit: (13) parent(person(tom, fox, date(7, may, 1950), works(bbc, 15200)), person(pat, fox, date(5, may, 1973), unemployed)) ? creep
   Call: (13) parent(person(pat, fox, date(5, may, 1973), unemployed), person(pat, fox, date(5, may, 1973), unemployed)) ? creep
   Call: (14) family(person(pat, fox, date(5, may, 1973), unemployed), _22640, _22564) ? creep
   Fail: (14) family(person(pat, fox, date(5, may, 1973), unemployed), _23454, _22564) ? creep % patは父親とはならず失敗
   Redo: (13) parent(person(pat, fox, date(5, may, 1973), unemployed), person(pat, fox, date(5, may, 1973), unemployed)) ? creep
   Call: (14) family(_25078, person(pat, fox, date(5, may, 1973), unemployed), _25004) ? creep
   Fail: (14) family(_25892, person(pat, fox, date(5, may, 1973), unemployed), _25004) ? creep
   Fail: (13) parent(person(pat, fox, date(5, may, 1973), unemployed), person(pat, fox, date(5, may, 1973), unemployed)) ? creep
   Redo: (14) mem(_16768, [person(pat, fox, date(5, may, 1973), unemployed), person(jim, fox, date(5, may, 1973), unemployed), person(bob, fox, date(10, april, 1976), unemployed)]) ? creep
   Call: (15) mem(_16768, [person(jim, fox, date(5, may, 1973), unemployed), person(bob, fox, date(10, april, 1976), unemployed)]) ? creep
   Exit: (15) mem(person(jim, fox, date(5, may, 1973), unemployed), [person(jim, fox, date(5, may, 1973), unemployed), person(bob, fox, date(10, april, 1976), unemployed)]) ? creep
   Exit: (14) mem(person(jim, fox, date(5, may, 1973), unemployed), [person(pat, fox, date(5, may, 1973), unemployed), person(jim, fox, date(5, may, 1973), unemployed), person(bob, fox, date(10, april, 1976), unemployed)]) ? creep
   Exit: (13) parent(person(tom, fox, date(7, may, 1950), works(bbc, 15200)), person(jim, fox, date(5, may, 1973), unemployed)) ? creep
   Call: (13) parent(person(jim, fox, date(5, may, 1973), unemployed), person(pat, fox, date(5, may, 1973), unemployed)) ? creep
   Call: (14) family(person(jim, fox, date(5, may, 1973), unemployed), _32380, _32304) ? creep
   Fail: (14) family(person(jim, fox, date(5, may, 1973), unemployed), _33194, _32304) ? creep
   Redo: (13) parent(person(jim, fox, date(5, may, 1973), unemployed), person(pat, fox, date(5, may, 1973), unemployed)) ? creep
   Call: (14) family(_34818, person(jim, fox, date(5, may, 1973), unemployed), _34744) ? creep
   Fail: (14) family(_35632, person(jim, fox, date(5, may, 1973), unemployed), _34744) ? creep
   Fail: (13) parent(person(jim, fox, date(5, may, 1973), unemployed), person(pat, fox, date(5, may, 1973), unemployed)) ? creep
   Redo: (15) mem(_16768, [person(jim, fox, date(5, may, 1973), unemployed), person(bob, fox, date(10, april, 1976), unemployed)]) ? creep
   Call: (16) mem(_16768, [person(bob, fox, date(10, april, 1976), unemployed)]) ? creep
   Exit: (16) mem(person(bob, fox, date(10, april, 1976), unemployed), [person(bob, fox, date(10, april, 1976), unemployed)]) ? creep
   Exit: (15) mem(person(bob, fox, date(10, april, 1976), unemployed), [person(jim, fox, date(5, may, 1973), unemployed), person(bob, fox, date(10, april, 1976), unemployed)]) ? creep
   Exit: (14) mem(person(bob, fox, date(10, april, 1976), unemployed), [person(pat, fox, date(5, may, 1973), unemployed), person(jim, fox, date(5, may, 1973), unemployed), person(bob, fox, date(10, april, 1976), unemployed)]) ? creep
   Exit: (13) parent(person(tom, fox, date(7, may, 1950), works(bbc, 15200)), person(bob, fox, date(10, april, 1976), unemployed)) ? creep
   Call: (13) parent(person(bob, fox, date(10, april, 1976), unemployed), person(pat, fox, date(5, may, 1973), unemployed)) ? creep
   Call: (14) family(person(bob, fox, date(10, april, 1976), unemployed), _42930, _42854) ? creep
   Fail: (14) family(person(bob, fox, date(10, april, 1976), unemployed), _43744, _42854) ? creep
   Redo: (13) parent(person(bob, fox, date(10, april, 1976), unemployed), person(pat, fox, date(5, may, 1973), unemployed)) ? creep
   Call: (14) family(_45368, person(bob, fox, date(10, april, 1976), unemployed), _45294) ? creep
   Fail: (14) family(_46182, person(bob, fox, date(10, april, 1976), unemployed), _45294) ? creep
   Fail: (13) parent(person(bob, fox, date(10, april, 1976), unemployed), person(pat, fox, date(5, may, 1973), unemployed)) ? creep
   Redo: (16) mem(_16768, [person(bob, fox, date(10, april, 1976), unemployed)]) ? creep
   Call: (17) mem(_16768, []) ? creep
   Fail: (17) mem(_16768, []) ? creep
   Fail: (16) mem(_16768, [person(bob, fox, date(10, april, 1976), unemployed)]) ? creep
   Fail: (15) mem(_16768, [person(jim, fox, date(5, may, 1973), unemployed), person(bob, fox, date(10, april, 1976), unemployed)]) ? creep
   Fail: (14) mem(_16768, [person(pat, fox, date(5, may, 1973), unemployed), person(jim, fox, date(5, may, 1973), unemployed), person(bob, fox, date(10, april, 1976), unemployed)]) ? creep
   Redo: (14) family(_16766, _52668, _17580) ? creep
   Exit: (14) family(person(owen, douglas, date(4, august, 1952), works(apple, 20000)), person(cathy, douglas, date(11, june, 1951), unemployed), [person(emma, douglas, date(1, july, 1980), unemployed), person(alex, douglas, date(13, october, 1983), unemployed)]) ? creep
   Call: (14) mem(_16768, [person(emma, douglas, date(1, july, 1980), unemployed), person(alex, douglas, date(13, october, 1983), unemployed)]) ? creep
   Exit: (14) mem(person(emma, douglas, date(1, july, 1980), unemployed), [person(emma, douglas, date(1, july, 1980), unemployed), person(alex, douglas, date(13, october, 1983), unemployed)]) ? creep
   Exit: (13) parent(person(owen, douglas, date(4, august, 1952), works(apple, 20000)), person(emma, douglas, date(1, july, 1980), unemployed)) ? creep
   Call: (13) parent(person(emma, douglas, date(1, july, 1980), unemployed), person(pat, fox, date(5, may, 1973), unemployed)) ? creep
   Call: (14) family(person(emma, douglas, date(1, july, 1980), unemployed), _57628, _57552) ? creep
   Fail: (14) family(person(jim, fox, date(5, may, 1973), unemployed), _33194, _32304) ? creep
   Redo: (13) parent(person(jim, fox, date(5, may, 1973), unemployed), person(pat, fox, date(5, may, 1973), unemployed)) ? creep
   Call: (14) family(_34818, person(jim, fox, date(5, may, 1973), unemployed), _34744) ? creep
   Fail: (14) family(_35632, person(jim, fox, date(5, may, 1973), unemployed), _34744) ? creep
   Fail: (13) parent(person(jim, fox, date(5, may, 1973), unemployed), person(pat, fox, date(5, may, 1973), unemployed)) ? creep
   Redo: (15) mem(_16768, [person(jim, fox, date(5, may, 1973), unemployed), person(bob, fox, date(10, april, 1976), unemployed)]) ? creep
   Call: (16) mem(_16768, [person(bob, fox, date(10, april, 1976), unemployed)]) ? creep
   Exit: (16) mem(person(bob, fox, date(10, april, 1976), unemployed), [person(bob, fox, date(10, april, 1976), unemployed)]) ? creep
   Exit: (15) mem(person(bob, fox, date(10, april, 1976), unemployed), [person(jim, fox, date(5, may, 1973), unemployed), person(bob, fox, date(10, april, 1976), unemployed)]) ? creep
   Exit: (14) mem(person(bob, fox, date(10, april, 1976), unemployed), [person(pat, fox, date(5, may, 1973), unemployed), person(jim, fox, date(5, may, 1973), unemployed), person(bob, fox, date(10, april, 1976), unemployed)]) ? creep
   Exit: (13) parent(person(tom, fox, date(7, may, 1950), works(bbc, 15200)), person(bob, fox, date(10, april, 1976), unemployed)) ? creep
   Call: (13) parent(person(bob, fox, date(10, april, 1976), unemployed), person(pat, fox, date(5, may, 1973), unemployed)) ? creep
   Call: (14) family(person(bob, fox, date(10, april, 1976), unemployed), _42930, _42854) ? creep
   Fail: (14) family(person(bob, fox, date(10, april, 1976), unemployed), _43744, _42854) ? creep
   Redo: (13) parent(person(bob, fox, date(10, april, 1976), unemployed), person(pat, fox, date(5, may, 1973), unemployed)) ? creep
   Call: (14) family(_45368, person(bob, fox, date(10, april, 1976), unemployed), _45294) ? creep
   Fail: (14) family(_46182, person(bob, fox, date(10, april, 1976), unemployed), _45294) ? creep
   Fail: (13) parent(person(bob, fox, date(10, april, 1976), unemployed), person(pat, fox, date(5, may, 1973), unemployed)) ? creep
   Redo: (16) mem(_16768, [person(bob, fox, date(10, april, 1976), unemployed)]) ? creep
   Call: (17) mem(_16768, []) ? creep
   Fail: (17) mem(_16768, []) ? creep
   Fail: (16) mem(_16768, [person(bob, fox, date(10, april, 1976), unemployed)]) ? creep
   Fail: (15) mem(_16768, [person(jim, fox, date(5, may, 1973), unemployed), person(bob, fox, date(10, april, 1976), unemployed)]) ? creep
   Fail: (14) mem(_16768, [person(pat, fox, date(5, may, 1973), unemployed), person(jim, fox, date(5, may, 1973), unemployed), person(bob, fox, date(10, april, 1976), unemployed)]) ? creep
   Redo: (14) family(_16766, _52668, _17580) ? creep
   Exit: (14) family(person(owen, douglas, date(4, august, 1952), works(apple, 20000)), person(cathy, douglas, date(11, june, 1951), unemployed), [person(emma, douglas, date(1, july, 1980), unemployed), person(alex, douglas, date(13, october, 1983), unemployed)]) ? creep
   Call: (14) mem(_16768, [person(emma, douglas, date(1, july, 1980), unemployed), person(alex, douglas, date(13, october, 1983), unemployed)]) ? creep
   Exit: (14) mem(person(emma, douglas, date(1, july, 1980), unemployed), [person(emma, douglas, date(1, july, 1980), unemployed), person(alex, douglas, date(13, october, 1983), unemployed)]) ? creep
   Exit: (13) parent(person(owen, douglas, date(4, august, 1952), works(apple, 20000)), person(emma, douglas, date(1, july, 1980), unemployed)) ? creep
   Call: (13) parent(person(emma, douglas, date(1, july, 1980), unemployed), person(pat, fox, date(5, may, 1973), unemployed)) ? creep
   Call: (14) family(person(emma, douglas, date(1, july, 1980), unemployed), _57628, _57552) ? creep
   Fail: (14) family(person(emma, douglas, date(1, july, 1980), unemployed), _58442, _57552) ? creep
   Redo: (13) parent(person(emma, douglas, date(1, july, 1980), unemployed), person(pat, fox, date(5, may, 1973), unemployed)) ? creep
   Call: (14) family(_60066, person(emma, douglas, date(1, july, 1980), unemployed), _59992) ? creep
   Fail: (14) family(_60880, person(emma, douglas, date(1, july, 1980), unemployed), _59992) ? creep
   Fail: (13) parent(person(emma, douglas, date(1, july, 1980), unemployed), person(pat, fox, date(5, may, 1973), unemployed)) ? creep
   Redo: (14) mem(_16768, [person(emma, douglas, date(1, july, 1980), unemployed), person(alex, douglas, date(13, october, 1983), unemployed)]) ? creep
   Call: (15) mem(_16768, [person(alex, douglas, date(13, october, 1983), unemployed)]) ? creep
   Exit: (15) mem(person(alex, douglas, date(13, october, 1983), unemployed), [person(alex, douglas, date(13, october, 1983), unemployed)]) ? creep
   Exit: (14) mem(person(alex, douglas, date(13, october, 1983), unemployed), [person(emma, douglas, date(1, july, 1980), unemployed), person(alex, douglas, date(13, october, 1983), unemployed)]) ? creep
   Exit: (13) parent(person(owen, douglas, date(4, august, 1952), works(apple, 20000)), person(alex, douglas, date(13, october, 1983), unemployed)) ? creep % owen-alex-emmaの家族関係を発見
   Call: (13) parent(person(alex, douglas, date(13, october, 1983), unemployed), person(pat, fox, date(5, may, 1973), unemployed)) ? creep
   Call: (14) family(person(alex, douglas, date(13, october, 1983), unemployed), _3398, _3322) ? creep
   Fail: (14) family(person(alex, douglas, date(13, october, 1983), unemployed), _4212, _3322) ? creep
   Redo: (13) parent(person(alex, douglas, date(13, october, 1983), unemployed), person(pat, fox, date(5, may, 1973), unemployed)) ? creep
   Call: (14) family(_8266, person(alex, douglas, date(13, october, 1983), unemployed), _8192) ? creep
   Fail: (14) family(_9080, person(alex, douglas, date(13, october, 1983), unemployed), _8192) ? creep
   Fail: (13) parent(person(alex, douglas, date(13, october, 1983), unemployed), person(pat, fox, date(5, may, 1973), unemployed)) ? creep
   Redo: (15) mem(_140, [person(alex, douglas, date(13, october, 1983), unemployed)]) ? creep
   Call: (16) mem(_140, []) ? creep
   Fail: (16) mem(_140, []) ? creep
   Fail: (15) mem(_140, [person(alex, douglas, date(13, october, 1983), unemployed)]) ? creep
   Fail: (14) mem(_140, [person(emma, douglas, date(1, july, 1980), unemployed), person(alex, douglas, date(13, october, 1983), unemployed)]) ? creep
   Redo: (14) family(_138, _14756, _142) ? creep
   Exit: (14) family(person(arthur, fox, date(4, august, 1925), works(bbc, 15500)), person(chloe, fox, date(17, june, 1925), unemployed), [person(tom, fox, date(7, may, 1950), works(bbc, 15200)), person(cathy, douglas, date(11, june, 1951), unemployed)]) ? creep
   Call: (14) mem(_140, [person(tom, fox, date(7, may, 1950), works(bbc, 15200)), person(cathy, douglas, date(11, june, 1951), unemployed)]) ? creep
   Exit: (14) mem(person(tom, fox, date(7, may, 1950), works(bbc, 15200)), [person(tom, fox, date(7, may, 1950), works(bbc, 15200)), person(cathy, douglas, date(11, june, 1951), unemployed)]) ? creep
   Exit: (13) parent(person(arthur, fox, date(4, august, 1925), works(bbc, 15500)), person(tom, fox, date(7, may, 1950), works(bbc, 15200))) ? creep
   Call: (13) parent(person(tom, fox, date(7, may, 1950), works(bbc, 15200)), person(pat, fox, date(5, may, 1973), unemployed)) ? creep
   Call: (14) family(person(tom, fox, date(7, may, 1950), works(bbc, 15200)), _19722, _19646) ? creep
   Exit: (14) family(person(tom, fox, date(7, may, 1950), works(bbc, 15200)), person(ann, fox, date(9, may, 1951), unemployed), [person(pat, fox, date(5, may, 1973), unemployed), person(jim, fox, date(5, may, 1973), unemployed), person(bob, fox, date(10, april, 1976), unemployed)]) ? creep
   Call: (14) mem(person(pat, fox, date(5, may, 1973), unemployed), [person(pat, fox, date(5, may, 1973), unemployed), person(jim, fox, date(5, may, 1973), unemployed), person(bob, fox, date(10, april, 1976), unemployed)]) ? creep
   Exit: (14) mem(person(pat, fox, date(5, may, 1973), unemployed), [person(pat, fox, date(5, may, 1973), unemployed), person(jim, fox, date(5, may, 1973), unemployed), person(bob, fox, date(10, april, 1976), unemployed)]) ? creep
   Exit: (13) parent(person(tom, fox, date(7, may, 1950), works(bbc, 15200)), person(pat, fox, date(5, may, 1973), unemployed)) ? creep
   Call: (13) parent(person(arthur, fox, date(4, august, 1925), works(bbc, 15500)), _23796) ? creep
   Call: (14) family(person(tom, fox, date(7, may, 1950), works(bbc, 15200)), _19722, _19646) ? creep
   Exit: (14) family(person(tom, fox, date(7, may, 1950), works(bbc, 15200)), person(ann, fox, date(9, may, 1951), unemployed), [person(pat, fox, date(5, may, 1973), unemployed), person(jim, fox, date(5, may, 1973), unemployed), person(bob, fox, date(10, april, 1976), unemployed)]) ? creep
   Call: (14) mem(person(pat, fox, date(5, may, 1973), unemployed), [person(pat, fox, date(5, may, 1973), unemployed), person(jim, fox, date(5, may, 1973), unemployed), person(bob, fox, date(10, april, 1976), unemployed)]) ? creep
   Exit: (14) mem(person(pat, fox, date(5, may, 1973), unemployed), [person(pat, fox, date(5, may, 1973), unemployed), person(jim, fox, date(5, may, 1973), unemployed), person(bob, fox, date(10, april, 1976), unemployed)]) ? creep
   Exit: (13) parent(person(tom, fox, date(7, may, 1950), works(bbc, 15200)), person(pat, fox, date(5, may, 1973), unemployed)) ? creep
   Call: (13) parent(person(arthur, fox, date(4, august, 1925), works(bbc, 15500)), _23796) ? creep
   Call: (14) family(person(arthur, fox, date(4, august, 1925), works(bbc, 15500)), _24684, _24608) ? creep
   Exit: (14) family(person(arthur, fox, date(4, august, 1925), works(bbc, 15500)), person(chloe, fox, date(17, june, 1925), unemployed), [person(tom, fox, date(7, may, 1950), works(bbc, 15200)), person(cathy, douglas, date(11, june, 1951), unemployed)]) ? creep
   Call: (14) mem(_23796, [person(tom, fox, date(7, may, 1950), works(bbc, 15200)), person(cathy, douglas, date(11, june, 1951), unemployed)]) ? creep
   Exit: (14) mem(person(tom, fox, date(7, may, 1950), works(bbc, 15200)), [person(tom, fox, date(7, may, 1950), works(bbc, 15200)), person(cathy, douglas, date(11, june, 1951), unemployed)]) ? creep
   Exit: (13) parent(person(arthur, fox, date(4, august, 1925), works(bbc, 15500)), person(tom, fox, date(7, may, 1950), works(bbc, 15200))) ? creep
   Call: (13) parent(person(tom, fox, date(7, may, 1950), works(bbc, 15200)), person(emma, douglas, date(1, july, 1980), unemployed)) ? creep
   Call: (14) family(person(tom, fox, date(7, may, 1950), works(bbc, 15200)), _29626, _29550) ? creep
   Exit: (14) family(person(tom, fox, date(7, may, 1950), works(bbc, 15200)), person(ann, fox, date(9, may, 1951), unemployed), [person(pat, fox, date(5, may, 1973), unemployed), person(jim, fox, date(5, may, 1973), unemployed), person(bob, fox, date(10, april, 1976), unemployed)]) ? creep
   Call: (14) mem(person(emma, douglas, date(1, july, 1980), unemployed), [person(pat, fox, date(5, may, 1973), unemployed), person(jim, fox, date(5, may, 1973), unemployed), person(bob, fox, date(10, april, 1976), unemployed)]) ? creep
   Call: (15) mem(person(emma, douglas, date(1, july, 1980), unemployed), [person(jim, fox, date(5, may, 1973), unemployed), person(bob, fox, date(10, april, 1976), unemployed)]) ? creep
   Call: (16) mem(person(emma, douglas, date(1, july, 1980), unemployed), [person(bob, fox, date(10, april, 1976), unemployed)]) ? creep
   Call: (17) mem(person(emma, douglas, date(1, july, 1980), unemployed), []) ? creep
   Fail: (17) mem(person(emma, douglas, date(1, july, 1980), unemployed), []) ? creep
   Fail: (16) mem(person(emma, douglas, date(1, july, 1980), unemployed), [person(bob, fox, date(10, april, 1976), unemployed)]) ? creep
   Fail: (15) mem(person(emma, douglas, date(1, july, 1980), unemployed), [person(jim, fox, date(5, may, 1973), unemployed), person(bob, fox, date(10, april, 1976), unemployed)]) ? creep
   Fail: (14) mem(person(emma, douglas, date(1, july, 1980), unemployed), [person(pat, fox, date(5, may, 1973), unemployed), person(jim, fox, date(5, may, 1973), unemployed), person(bob, fox, date(10, april, 1976), unemployed)]) ? creep
   Redo: (13) parent(person(tom, fox, date(7, may, 1950), works(bbc, 15200)), person(emma, douglas, date(1, july, 1980), unemployed)) ? creep
   Call: (14) family(_38634, person(tom, fox, date(7, may, 1950), works(bbc, 15200)), _38560) ? creep
   Fail: (14) family(_39448, person(tom, fox, date(7, may, 1950), works(bbc, 15200)), _38560) ? creep
   Fail: (13) parent(person(tom, fox, date(7, may, 1950), works(bbc, 15200)), person(emma, douglas, date(1, july, 1980), unemployed)) ? creep
   Redo: (14) mem(_23796, [person(tom, fox, date(7, may, 1950), works(bbc, 15200)), person(cathy, douglas, date(11, june, 1951), unemployed)]) ? creep
   Call: (15) mem(_23796, [person(cathy, douglas, date(11, june, 1951), unemployed)]) ? creep
   Exit: (15) mem(person(cathy, douglas, date(11, june, 1951), unemployed), [person(cathy, douglas, date(11, june, 1951), unemployed)]) ? creep
   Exit: (14) mem(person(cathy, douglas, date(11, june, 1951), unemployed), [person(tom, fox, date(7, may, 1950), works(bbc, 15200)), person(cathy, douglas, date(11, june, 1951), unemployed)]) ? creep
   Exit: (13) parent(person(arthur, fox, date(4, august, 1925), works(bbc, 15500)), person(cathy, douglas, date(11, june, 1951), unemployed)) ? creep
   Call: (13) parent(person(cathy, douglas, date(11, june, 1951), unemployed), person(emma, douglas, date(1, july, 1980), unemployed)) ? creep
   Call: (14) family(person(cathy, douglas, date(11, june, 1951), unemployed), _45936, _45860) ? creep
   Fail: (14) family(person(cathy, douglas, date(11, june, 1951), unemployed), _46750, _45860) ? creep
   Redo: (13) parent(person(cathy, douglas, date(11, june, 1951), unemployed), person(emma, douglas, date(1, july, 1980), unemployed)) ? creep
   Call: (14) family(_48374, person(cathy, douglas, date(11, june, 1951), unemployed), _48300) ? creep
   Exit: (14) family(person(owen, douglas, date(4, august, 1952), works(apple, 20000)), person(cathy, douglas, date(11, june, 1951), unemployed), [person(emma, douglas, date(1, july, 1980), unemployed), person(alex, douglas, date(13, october, 1983), unemployed)]) ? creep
   Call: (14) mem(person(emma, douglas, date(1, july, 1980), unemployed), [person(emma, douglas, date(1, july, 1980), unemployed), person(alex, douglas, date(13, october, 1983), unemployed)]) ? creep
   Exit: (14) mem(person(emma, douglas, date(1, july, 1980), unemployed), [person(emma, douglas, date(1, july, 1980), unemployed), person(alex, douglas, date(13, october, 1983), unemployed)]) ? creep
   Exit: (13) parent(person(cathy, douglas, date(11, june, 1951), unemployed), person(emma, douglas, date(1, july, 1980), unemployed)) ? creep
   Call: (13) different(person(tom, fox, date(7, may, 1950), works(bbc, 15200)), person(cathy, douglas, date(11, june, 1951), unemployed)) ? creep
   Call: (14) person(tom, fox, date(7, may, 1950), works(bbc, 15200))\==person(cathy, douglas, date(11, june, 1951), unemployed) ? creep
   Exit: (14) person(tom, fox, date(7, may, 1950), works(bbc, 15200))\==person(cathy, douglas, date(11, june, 1951), unemployed) ? creep
   Exit: (13) different(person(tom, fox, date(7, may, 1950), works(bbc, 15200)), person(cathy, douglas, date(11, june, 1951), unemployed)) ? creep
   Exit: (12) cousin(person(pat, fox, date(5, may, 1973), unemployed), person(emma, douglas, date(1, july, 1980), unemployed)) ? creep
true .

(説明)
血縁関係は架空のものである。
双子は両親が同じで互いの生年月日が同じであればよい。両親が同じというのはparent(X,Child1),parent(X,Child2)でも実現できるが、親1人ごとに出力されるので、家族が同じで、同じ子供集合に存在することを表すfamily(_,_,Children),del(Child1,Children,OtherChildren),mem(Child2,OtherChildren)を使うと出力結果が重複しなくて良い。mem(Child1,Children),mem(Child2,Children)だけだと同一人物が出力されるので、del(Child1,Children,OtherChildren)またはdifferent(Child1,Child2)を加えると良い。
従兄弟は祖父母が同じで親が異なればよい。祖父母が同じというのはXを共通の祖父母の一人と考えてparent(X,Y),parent(Y,P1),parent(X,Z),parent(Z,P2)で実現でき、親が異なるというのはdifferent(Y,Z)で実現できる。traceの実行結果ではarthur-tom-patとarthur-cathy-emmaの家族関係を発見している。
双子も従兄弟も第1引数と第2引数を入れ替えたものも出力されてしまう。回避するために生年月日で順序を付けることも考えたが、構造dateは引数が３つあり複雑になりそうなので断念した。

練習4.5 (p.105)

    acceptsの実行時のループは，たとえばそこまでの動作回数を数えることにより回避できる．
    そうすると，シュミレータはある決められた長さの道だけを探すように求められる．acceptsをそのように修正せよ．
    教科書P.104のaccepts/2のプログラムでは無限ループに陥るようなオートマトンを用意して動作確認を行うこと．
*/

accepts(S,[],_) :- final(S). % 空系列を受理
accepts(S,[X|Rest],MaxMoves) :- MaxMoves>0,trans(S,X,S1),NewMax is MaxMoves - 1,accepts(S1,Rest,NewMax). % 最初の記号を読んで受理
accepts(S,String,MaxMoves) :- MaxMoves>0,silent(S,S1),NewMax is MaxMoves - 1,accepts(S1,String,NewMax). % 空動作による受理

/*（実行例）
[trace]  ?- accepts(s1,[a],4).
   Call: (12) accepts(s1, [a], 4) ? creep
   Call: (13) 4>0 ? creep
   Exit: (13) 4>0 ? creep % MaxMoves>0が成立
   Call: (13) trans(s1, a, _61980) ? creep
   Exit: (13) trans(s1, a, s1) ? creep % 遷移trans(s1, a, s1)
   Call: (13) _63616 is 4+ -1 ? creep
   Exit: (13) 3 is 4+ -1 ? creep % NewMax=3
   Call: (13) accepts(s1, [], 3) ? creep
   Call: (14) final(s1) ? creep
   Fail: (14) final(s1) ? creep % final(s1)は不成立
   Redo: (13) accepts(s1, [], 3) ? creep
   Call: (14) 3>0 ? creep
   Exit: (14) 3>0 ? creep
   Call: (14) silent(s1, _70098) ? creep
   Exit: (14) silent(s1, s3) ? creep % 空動作silent(s1, s3)
   Call: (14) _71726 is 3+ -1 ? creep
   Exit: (14) 2 is 3+ -1 ? creep
   Call: (14) accepts(s3, [], 2) ? creep
   Call: (15) final(s3) ? creep
   Fail: (15) final(s3) ? creep
   Redo: (14) accepts(s3, [], 2) ? creep
   Call: (15) 2>0 ? creep
   Exit: (15) 2>0 ? creep
   Call: (15) silent(s3, _78208) ? creep
   Exit: (15) silent(s3, s1) ? creep % 空動作silent(s3, s1)
   Call: (15) _79836 is 2+ -1 ? creep
   Exit: (15) 1 is 2+ -1 ? creep
   Call: (15) accepts(s1, [], 1) ? creep
   Call: (16) final(s1) ? creep
   Fail: (16) final(s1) ? creep
   Redo: (15) accepts(s1, [], 1) ? creep
   Call: (16) 1>0 ? creep
   Exit: (16) 1>0 ? creep
   Call: (16) silent(s1, _86318) ? creep
   Exit: (16) silent(s1, s3) ? creep % 空動作silent(s1, s3)
   Call: (16) _87946 is 1+ -1 ? creep
   Exit: (16) 0 is 1+ -1 ? creep
   Call: (16) accepts(s3, [], 0) ? creep
   Call: (17) final(s3) ? creep
   Fail: (17) final(s3) ? creep
   Redo: (16) accepts(s3, [], 0) ? creep
   Call: (17) 0>0 ? creep
   Fail: (17) 0>0 ? creep % MaxMoves>0が不成立、動作回数オーバー
   Fail: (16) accepts(s3, [], 0) ? creep
   Fail: (15) accepts(s1, [], 1) ? creep
   Fail: (14) accepts(s3, [], 2) ? creep
   Fail: (13) accepts(s1, [], 3) ? creep
   Redo: (13) trans(s1, a, _61980) ? creep
   Fail: (13) trans(s1, a, _61980) ? creep
   Redo: (12) accepts(s1, [a], 4) ? creep
   Call: (13) 4>0 ? creep
   Exit: (13) 4>0 ? creep
   Call: (13) silent(s1, _101746) ? creep
   Exit: (13) silent(s1, s3) ? creep % 空動作silent(s1, s3)
   Call: (13) _103374 is 4+ -1 ? creep
   Exit: (13) 3 is 4+ -1 ? creep
   Call: (13) accepts(s3, [a], 3) ? creep
   Call: (14) 3>0 ? creep
   Exit: (14) 3>0 ? creep
   Call: (14) trans(s3, a, _107430) ? creep
   Exit: (14) trans(s3, a, s4) ? creep % 遷移trans(s3, a, s4)
   Call: (14) _109066 is 3+ -1 ? creep
   Exit: (14) 2 is 3+ -1 ? creep
   Call: (14) accepts(s4, [], 2) ? creep
   Call: (15) final(s4) ? creep
   Exit: (15) final(s4) ? creep
   Exit: (14) accepts(s4, [], 2) ? creep
   Exit: (13) accepts(s3, [a], 3) ? creep
   Exit: (12) accepts(s1, [a], 4) ? creep
true ;
   Redo: (14) accepts(s4, [], 2) ? creep
   Call: (15) 2>0 ? creep
   Exit: (15) 2>0 ? creep
   Call: (15) silent(s4, _119436) ? creep
   Fail: (15) silent(s4, _119436) ? creep
   Fail: (14) accepts(s4, [], 2) ? creep
   Redo: (14) trans(s3, a, _107430) ? creep
   Fail: (14) trans(s3, a, _107430) ? creep
   Redo: (13) accepts(s3, [a], 3) ? creep
   Call: (14) 3>0 ? creep
   Exit: (14) 3>0 ? creep
   Call: (14) silent(s3, _125934) ? creep
   Exit: (14) silent(s3, s1) ? creep
   Call: (14) _127562 is 3+ -1 ? creep
   Exit: (14) 2 is 3+ -1 ? creep
   Call: (14) accepts(s1, [a], 2) ? creep
   Call: (15) 2>0 ? creep
   Exit: (15) 2>0 ? creep
   Call: (15) trans(s1, a, _131618) ? creep
   Exit: (15) trans(s1, a, s1) ? creep
   Call: (15) _133254 is 2+ -1 ? creep
   Exit: (15) 1 is 2+ -1 ? creep
   Call: (15) accepts(s1, [], 1) ? creep
   Call: (16) final(s1) ? creep
   Fail: (16) final(s1) ? creep
   Redo: (15) accepts(s1, [], 1) ? creep
   Call: (16) 1>0 ? creep
   Exit: (16) 1>0 ? creep
   Call: (16) silent(s1, _139736) ? creep
   Exit: (16) silent(s1, s3) ? creep
   Call: (16) _141364 is 1+ -1 ? creep
   Exit: (16) 0 is 1+ -1 ? creep
   Call: (16) accepts(s3, [], 0) ? creep
   Call: (17) final(s3) ? creep
   Fail: (17) final(s3) ? creep
   Redo: (16) accepts(s3, [], 0) ? creep
   Call: (17) 0>0 ? creep
   Fail: (17) 0>0 ? creep
   Fail: (16) accepts(s3, [], 0) ? creep
   Fail: (15) accepts(s1, [], 1) ? creep
   Redo: (15) trans(s1, a, _131618) ? creep
   Fail: (15) trans(s1, a, _131618) ? creep
   Redo: (14) accepts(s1, [a], 2) ? creep
   Call: (15) 2>0 ? creep
   Exit: (15) 2>0 ? creep
   Call: (15) silent(s1, _153536) ? creep
   Exit: (15) silent(s1, s3) ? creep
   Call: (15) _155164 is 2+ -1 ? creep
   Exit: (15) 1 is 2+ -1 ? creep
   Call: (15) accepts(s3, [a], 1) ? creep
   Call: (16) 1>0 ? creep
   Exit: (16) 1>0 ? creep
   Call: (16) trans(s3, a, _159220) ? creep
   Exit: (16) trans(s3, a, s4) ? creep
   Call: (16) _160856 is 1+ -1 ? creep
   Exit: (16) 0 is 1+ -1 ? creep
   Call: (16) accepts(s4, [], 0) ? creep
   Call: (17) final(s4) ? creep
   Exit: (17) final(s4) ? creep
   Exit: (16) accepts(s4, [], 0) ? creep
   Exit: (15) accepts(s3, [a], 1) ? creep
   Exit: (14) accepts(s1, [a], 2) ? creep
   Exit: (13) accepts(s3, [a], 3) ? creep
   Exit: (12) accepts(s1, [a], 4) ? creep
true ;
   Redo: (16) accepts(s4, [], 0) ? creep
   Call: (17) 0>0 ? creep
   Fail: (17) 0>0 ? creep
   Fail: (16) accepts(s4, [], 0) ? creep
   Redo: (16) trans(s3, a, _159220) ? creep
   Fail: (16) trans(s3, a, _159220) ? creep
   Redo: (15) accepts(s3, [a], 1) ? creep
   Call: (16) 1>0 ? creep
   Exit: (16) 1>0 ? creep
   Call: (16) silent(s3, _177730) ? creep
   Exit: (16) silent(s3, s1) ? creep
   Call: (16) _179358 is 1+ -1 ? creep
   Exit: (16) 0 is 1+ -1 ? creep
   Call: (16) accepts(s1, [a], 0) ? creep
   Call: (17) 0>0 ? creep
   Fail: (17) 0>0 ? creep
   Redo: (16) accepts(s1, [a], 0) ? creep
   Call: (17) 0>0 ? creep
   Fail: (17) 0>0 ? creep % 動作回数オーバー、探索終了
   Fail: (16) accepts(s1, [a], 0) ? creep
   Fail: (15) accepts(s3, [a], 1) ? creep
   Fail: (14) accepts(s1, [a], 2) ? creep
   Fail: (13) accepts(s3, [a], 3) ? creep
   Fail: (12) accepts(s1, [a], 4) ? creep
false. 
(説明)
状態遷移または空動作をするときは最初に第3引数MaxMovesが１以上か確認し動作後にMaxMovesをデクリメントすればよい。上記実行例では、silent(s1,s3)→trans(s3,a,s4)とsilent(s1,s3)→silent(s3,s1)→silent(s1,s3)→trans(s3,a,s4)の２つの経路を発見している。silent(s1,s3)→silent(s3,s1)で無限ループに陥るが、動作回数が４回より多い経路は探索を打ち切っている。
*/