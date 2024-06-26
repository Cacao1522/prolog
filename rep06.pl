% rep06: 第6回 演習課題レポート
% 提出日: 2024年5月24日
% 学籍番号: 34714037
% 名前: 加藤薫
%
%
% /*ここから本当のPrologプログラムを書く*/
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
process(end_of_file,_) :- !. % 読んだ項がend_of_fileであればカットして終了
process(CurrentTerm,Term) :- (naf(CurrentTerm=Term),!; % 項がマッチしないならカット
                            write(CurrentTerm),nl), % 項がマッチするなら現在の項を出力し、出力を改行する
                            findallterm(Term). % 項がマッチしてもしなくても再びfindallterm(Term)を呼び出す

/*（ファイルfの内容）
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

（実行例）
?- findallterm(X).
apple
p(a)
3
p(t(b))
parent(pam,bob)
parent(tom,bob)
parent(p(a),t(b))
bob
p(_91138)
mem(_91146,[_91146|_91148])
mem(_91168,[_91162|_91164]):-mem(_91168,_91164)
true.

?- findallterm(p(X)).
p(a)
p(t(b))
p(_95662)
true.

?- findallterm(p(t(X))).
p(t(b))
p(_4502)
true.

?- findallterm(parent(X)).
true.

?- findallterm(parent(p(a),t(bob))).
true.

?- findallterm(mem(a,[a,b])).
mem(_26844,[_26844|_26846])
true.

[trace]  ?- findallterm(parent(X,bob)).
   Call: (12) findallterm(parent(_32888, bob)) ? creep
   Call: (13) read(_34226) ? creep
   Exit: (13) read(apple) ? creep
   Call: (13) process(apple, parent(_32888, bob)) ? creep
   Call: (14) naf(apple=parent(_32888, bob)) ? creep
   Call: (15) apple=parent(_32888, bob) ? creep
   Fail: (15) apple=parent(_32888, bob) ? creep
   Redo: (14) naf(apple=parent(_32888, bob)) ? creep
   Exit: (14) naf(apple=parent(_32888, bob)) ? creep
   Call: (14) findallterm(parent(_32888, bob)) ? creep
   Call: (15) read(_41500) ? creep
   Exit: (15) read(p(a)) ? creep
   Call: (15) process(p(a), parent(_32888, bob)) ? creep
   Call: (16) naf(p(a)=parent(_32888, bob)) ? creep
   Call: (17) p(a)=parent(_32888, bob) ? creep
   Fail: (17) p(a)=parent(_32888, bob) ? creep
   Redo: (16) naf(p(a)=parent(_32888, bob)) ? creep
   Exit: (16) naf(p(a)=parent(_32888, bob)) ? creep
   Call: (16) findallterm(parent(_32888, bob)) ? creep
   Call: (17) read(_48778) ? creep
   Exit: (17) read(3) ? creep
   Call: (17) process(3, parent(_32888, bob)) ? creep
   Call: (18) naf(3=parent(_32888, bob)) ? creep
   Call: (19) 3=parent(_32888, bob) ? creep
   Fail: (19) 3=parent(_32888, bob) ? creep
   Redo: (18) naf(3=parent(_32888, bob)) ? creep
   Exit: (18) naf(3=parent(_32888, bob)) ? creep
   Call: (18) findallterm(parent(_32888, bob)) ? creep
   Call: (19) read(_56052) ? creep
   Exit: (19) read(p(t(b))) ? creep
   Call: (19) process(p(t(b)), parent(_32888, bob)) ? creep
   Call: (20) naf(p(t(b))=parent(_32888, bob)) ? creep
   Call: (21) p(t(b))=parent(_32888, bob) ? creep
   Fail: (21) p(t(b))=parent(_32888, bob) ? creep
   Redo: (20) naf(p(t(b))=parent(_32888, bob)) ? creep
   Exit: (20) naf(p(t(b))=parent(_32888, bob)) ? creep
   Call: (20) findallterm(parent(_32888, bob)) ? creep
   Call: (21) read(_63334) ? creep
   Exit: (21) read(parent(pam, bob)) ? creep
   Call: (21) process(parent(pam, bob), parent(_58, bob)) ? creep
   Call: (22) naf(parent(pam, bob)=parent(_58, bob)) ? creep
   Call: (23) parent(pam, bob)=parent(_58, bob) ? creep
   Exit: (23) parent(pam, bob)=parent(pam, bob) ? creep
   Call: (23) fail ? creep
   Fail: (23) fail ? creep
   Fail: (22) naf(parent(pam, bob)=parent(_58, bob)) ? creep
   Redo: (21) process(parent(pam, bob), parent(_58, bob)) ? creep
   Call: (22) write(parent(pam, bob)) ? creep
parent(pam,bob)
   Exit: (22) write(parent(pam, bob)) ? creep
   Call: (22) nl ? creep

   Exit: (22) nl ? creep
   Call: (22) findallterm(parent(_58, bob)) ? creep
   Call: (23) read(_11316) ? creep
   Exit: (23) read(parent(tom, bob)) ? creep
   Call: (23) process(parent(tom, bob), parent(_58, bob)) ? creep
   Call: (24) naf(parent(tom, bob)=parent(_58, bob)) ? creep
   Call: (25) parent(tom, bob)=parent(_58, bob) ? creep
   Exit: (25) parent(tom, bob)=parent(tom, bob) ? creep
   Call: (25) fail ? creep
   Fail: (25) fail ? creep
   Fail: (24) naf(parent(tom, bob)=parent(_58, bob)) ? creep
   Redo: (23) process(parent(tom, bob), parent(_58, bob)) ? creep
   Call: (24) write(parent(tom, bob)) ? creep
parent(tom,bob)
   Exit: (24) write(parent(tom, bob)) ? creep
   Call: (24) nl ? creep

   Exit: (24) nl ? creep
   Call: (24) findallterm(parent(_58, bob)) ? creep
   Call: (25) read(_23404) ? creep
   Exit: (25) read(parent(p(a), t(b))) ? creep
   Call: (25) process(parent(p(a), t(b)), parent(_58, bob)) ? creep
   Call: (26) naf(parent(p(a), t(b))=parent(_58, bob)) ? creep
   Call: (27) parent(p(a), t(b))=parent(_58, bob) ? creep
   Fail: (27) parent(p(a), t(b))=parent(_58, bob) ? creep
   Redo: (26) naf(parent(p(a), t(b))=parent(_58, bob)) ? creep
   Exit: (26) naf(parent(p(a), t(b))=parent(_58, bob)) ? creep
   Call: (26) findallterm(parent(_58, bob)) ? creep
   Call: (27) read(_30692) ? creep
   Exit: (27) read(bob) ? creep
   Call: (27) process(bob, parent(_58, bob)) ? creep
   Call: (28) naf(bob=parent(_58, bob)) ? creep
   Call: (29) bob=parent(_58, bob) ? creep
   Fail: (29) bob=parent(_58, bob) ? creep
   Redo: (28) naf(bob=parent(_58, bob)) ? creep
   Exit: (28) naf(bob=parent(_58, bob)) ? creep
   Call: (28) findallterm(parent(_58, bob)) ? creep
   Call: (29) read(_37966) ? creep
   Exit: (29) read(p(_38776)) ? creep
   Call: (29) process(p(_38776), parent(_58, bob)) ? creep
   Call: (30) naf(p(_38776)=parent(_58, bob)) ? creep
   Call: (31) p(_38776)=parent(_58, bob) ? creep
   Fail: (31) p(_38776)=parent(_58, bob) ? creep
   Redo: (30) naf(p(_38776)=parent(_58, bob)) ? creep
   Exit: (30) naf(p(_38776)=parent(_58, bob)) ? creep
   Call: (30) findallterm(parent(_58, bob)) ? creep
   Call: (31) read(_45244) ? creep
   Exit: (31) read(mem(_46056, [_46056|_46058])) ? creep
   Call: (31) process(mem(_46056, [_46056|_46058]), parent(_58, bob)) ? creep
   Call: (32) naf(mem(_46056, [_46056|_46058])=parent(_58, bob)) ? creep
   Call: (33) mem(_46056, [_46056|_46058])=parent(_58, bob) ? creep
   Fail: (33) mem(_46056, [_46056|_46058])=parent(_58, bob) ? creep
   Redo: (32) naf(mem(_46056, [_46056|_46058])=parent(_58, bob)) ? creep
   Exit: (32) naf(mem(_46056, [_46056|_46058])=parent(_58, bob)) ? creep
   Call: (32) findallterm(parent(_58, bob)) ? creep
   Call: (33) read(_52532) ? creep
   Exit: (33) read((mem(_53350, [_53344|_53346]):-mem(_53350, _53346))) ? creep
   Call: (33) process((mem(_53350, [_53344|_53346]):-mem(_53350, _53346)), parent(_58, bob)) ? creep
   Call: (34) naf((mem(_53350, [_53344|_53346]):-mem(_53350, _53346))=parent(_58, bob)) ? creep
   Call: (35) (mem(_53350, [_53344|_53346]):-mem(_53350, _53346))=parent(_58, bob) ? creep
   Fail: (35) (mem(_53350, [_53344|_53346]):-mem(_53350, _53346))=parent(_58, bob) ? creep
   Redo: (34) naf((mem(_53350, [_53344|_53346]):-mem(_53350, _53346))=parent(_58, bob)) ? creep
   Exit: (34) naf((mem(_53350, [_53344|_53346]):-mem(_53350, _53346))=parent(_58, bob)) ? creep
   Call: (34) findallterm(parent(_58, bob)) ? creep
   Call: (35) read(_59832) ? creep
   Exit: (35) read(end_of_file) ? creep
   Call: (35) process(end_of_file, parent(_58, bob)) ? creep
   Exit: (35) process(end_of_file, parent(_58, bob)) ? creep
   Exit: (34) findallterm(parent(_58, bob)) ? creep
   Exit: (33) process((mem(_208, [_202|_204]):-mem(_208, _204)), parent(_58, bob)) ? creep
   Exit: (32) findallterm(parent(_58, bob)) ? creep
   Exit: (31) process(mem(_186, [_186|_188]), parent(_58, bob)) ? creep
   Exit: (30) findallterm(parent(_58, bob)) ? creep
   Exit: (29) process(p(_178), parent(_58, bob)) ? creep
   Exit: (28) findallterm(parent(_58, bob)) ? creep
   Exit: (27) process(bob, parent(_58, bob)) ? creep
   Exit: (26) findallterm(parent(_58, bob)) ? creep
   Exit: (25) process(parent(p(a), t(b)), parent(_58, bob)) ? creep
   Exit: (24) findallterm(parent(_58, bob)) ? creep
   Exit: (23) process(parent(tom, bob), parent(_58, bob)) ? creep
   Exit: (22) findallterm(parent(_58, bob)) ? creep
   Exit: (21) process(parent(pam, bob), parent(_58, bob)) ? creep
   Exit: (20) findallterm(parent(_58, bob)) ? creep
   Exit: (19) process(p(t(b)), parent(_58, bob)) ? creep
   Exit: (18) findallterm(parent(_58, bob)) ? creep
   Exit: (17) process(3, parent(_58, bob)) ? creep
   Exit: (16) findallterm(parent(_58, bob)) ? creep
   Exit: (15) process(p(a), parent(_58, bob)) ? creep
   Exit: (14) findallterm(parent(_58, bob)) ? creep
   Exit: (13) process(apple, parent(_58, bob)) ? creep
   Exit: (12) findallterm(parent(_58, bob)) ? creep
true.
(説明)
まずreadで項を読み、その後処理processを実行する。処理processでは読んだ項がend_of_fileであればカットして終了する。naf(CurrentTerm=Term)は項がマッチしない場合にtrueになり、カットされるため、;でつながれたwriteは実行されない。項がマッチする場合はnaf(CurrentTerm=Term)がfalseになり;でつながれたwriteが実行される。
現入力ストリームをユーザ端末からファイルfに変えるために、findalltermを実行する前にsee.を実行する。ファイルfにはアトム、数、構造、入れ子になった構造といった様々なものを用意した。実行例ではマッチングするかどうか正しく判断できている。
findalltermの引数Termに変数を入れるとその変数にend_of_fileが代入されて終了してしまうのでファイルfには変数は含まないようにした。

問題6.3（教科書p.155）

    squeeze手続きを一般化して，カンマも扱えるようにせよ．カンマ
    のすぐ前の空白はすべて削除し，各カンマのあとには1つの空白を
    入れねばならないとする．
*/
% ASCII 46==.  44==,  32==' '
squeeze :- get0(C),dorest(C).
dorest(46) :- !,put(46). % .が読まれたら.を出力して終了
dorest(44) :- !,get0(C),dorestca(C). % カンマ手続きに移行
dorest(32) :- !,get0(C),dorestsp(C). % スペース手続きに移行
dorest(Letter) :- put(Letter),squeeze. % カンマ空白以外の文字を出力

dorestca(46) :- !,put(46). % .が読まれたら.を出力して終了
dorestca(44) :- !,get0(C),dorestca(C). % カンマ手続きをループ
dorestca(32) :- !,get0(C),dorestca(C). % カンマ手続きをループ
dorestca(Letter) :- put(44),put(32),put(Letter),squeeze. % カンマ、空白、カンマ空白以外の文字を出力

dorestsp(46) :- !,put(46). % .が読まれたら.を出力して終了
dorestsp(44) :- !,get0(C),dorestca(C). % カンマ手続きに移行
dorestsp(32) :- !,get0(C),dorestsp(C). % スペース手続きをループ
dorestsp(Letter) :- put(32),put(Letter),squeeze. % 空白、カンマ空白以外の文字を出力

/*（実行例）
?- squeeze.
|: Tom  ,Ann, Pat ,, Jim  and    Bob are  student ,.
Tom, Ann, Pat, Jim and Bob are students.
true.

?- squeeze.
|: a,,,b.
a, b.
true.

?- squeeze.
|: a , ,b.
a, b.
true.

?- squeeze.
|: ,,,..
.
true.

(説明)
空白の後にカンマがあったら空白を出力する前にカンマを出力しなければならないため、空白をを読んだ時点では空白を出力することはできない。そのため、空白やカンマを読んだ時点では出力せず、カンマと空白以外の文字を初めて読んだタイミングでカンマ、空白の出力をまとめて行うことにした。空白やカンマが読まれたら空白とカンマ以外の文字を待つ必要があるため別の手続きに移行する必要があり、空白やカンマの連続の中で、空白のみが含まれていたら空白１つを出力し、カンマが含まれていたらカンマ、空白を出力するので、その２パターンでさらに処理を分ける必要がある。空白とカンマ以外の文字を読み込む目標はないため、読み込みの目標はgetを使わず、すべてget0を使う。

*/