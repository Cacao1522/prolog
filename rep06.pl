% rep06: 第6回 演習課題レポート
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

naf(P) :- P,!,fail.
naf(_).
/*
問題6.2 (教科書p.153)

    fを項のファイルとする．
        findallterm(Term)
    が，f中の項でTermとマッチする全てのものを端末に表示するように
    手続きfindalltermを定義せよ．
    Termがその過程で値の具体化を受けないようにせよ
    （具体化を受けると，ファイル中の後に出現する項と項とのマッチ
      が阻止されてしまう）．
*/
findallterm(Term) :- read(CurrentTerm),process(CurrentTerm,Term).
process(end_of_file,_) :- !.
process(CurrentTerm,Term) :- (naf(CurrentTerm=Term),!;write(CurrentTerm),nl),findallterm(Term).

/*（実行例）


(説明)


問題6.3（教科書p.155）

    squeeze手続きを一般化して，カンマも扱えるようにせよ．カンマ
    のすぐ前の空白はすべて削除し，各カンマのあとには1つの空白を
    入れねばならないとする．
*/

accepts(S,[],_) :- final(S).
accepts(S,[X|Rest],MaxMoves) :- MaxMoves>0,trans(S,X,S1),NewMax is MaxMoves - 1,accepts(S1,Rest).
accepts(S,String,MaxMoves) :- MaxMoves>0,silent(S,S1),NewMax is MaxMoves - 1,accepts(S1,String,NewMax).

/*（実行例）


(説明)
flat([],[]).
flat(X,[X]).
を先にするとflat(Head,FlatHead),flat(Tail,FlatTail)がすぐに事実を満たしてしまい、出力が大量になる。flatの第1引数が[Head|Tail]に分割できる間、先頭Headのリストが外れるまで再帰的に呼び出される。その後リストTailの先頭のリストを同様の手順で外していく。


*/