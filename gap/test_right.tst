# test file for right function
gap> Read("~/Documents/project/right_alg.g");
gap> a := "aaaabbaac";
"aaaabbaac"
gap> Right(a, 2);
[ 8, 8, 8, 8, 8, 8, 9, 9, -1 ]
gap> Right(a, 3);
[ 9, 9, 9, 9, 9, 9, -1, -1, -1 ]
gap> b := "aaabcbcbdbcbabcd";
"aaabcbcbdbcbabcd"
gap> Right(b, 2);
[ 4, 4, 4, 8, 8, 8, 8, 10, 10, 12, 12, 14, 14, 15, 16, -1 ]
gap> a := "aasdfgfdsasdfwgfdrgh";
"aasdfgfdsasdfwgfdrgh"
gap> Right(a, 4);
[ 5, 5, 9, 9, 9, 9, 13, 13, 13, 13, 14, 17, 17, 17, 19, 19, 20, -1, -1, -1 ]
gap> w := "a";
"a"
gap> Right(w, 1);
[ 1 ]
gap> Left(w, 1);
[ 1 ]
gap> Right(w, 2);
[ -1 ]
gap> Right(w, 100);
[ -1 ]
gap> w := "aab";
"aab"
gap> Left(w, 2);
[ -1, -1, 1 ]
gap> Right(w, 2);
[ 3, 3, -1 ]
gap> w := "";
""
gap> Right(w, 1);
[  ]
gap> Right(w, 0);
[  ]
gap> Right(w, 4);
[  ]
gap> w := "hellothere";
"hellothere"
gap> Left(w, 4);
[ -1, -1, -1, -1, 1, 2, 3, 5, 6, 6 ]
