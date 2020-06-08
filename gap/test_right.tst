# test file for right function
gap> a := "aaaabbaac";
"aaaabbaac"
gap> a := StringToStandardListOfPosInts(a);
[ 1, 1, 1, 1, 2, 2, 1, 1, 3 ]
gap> Right(a, 2);
[ 8, 8, 8, 8, 8, 8, 9, 9, fail ]
gap> Right(a, 3);
[ 9, 9, 9, 9, 9, 9, fail, fail, fail ]
gap> b := "aaabcbcbdbcbabcd";
"aaabcbcbdbcbabcd"
gap> b := StringToStandardListOfPosInts(b);
[ 1, 1, 1, 2, 3, 2, 3, 2, 4, 2, 3, 2, 1, 2, 3, 4 ]
gap> Right(b, 2);
[ 4, 4, 4, 8, 8, 8, 8, 10, 10, 12, 12, 14, 14, 15, 16, fail ]
gap>  a := "aasdfgfdsasdfwgfd";
"aasdfgfdsasdfwgfd"
gap> a := StringToStandardListOfPosInts(a);
[ 1, 1, 2, 3, 4, 5, 4, 3, 2, 1, 2, 3, 4, 6, 5, 4, 3 ]
gap> Right(a, 4);
[ 5, 5, 9, 9, 9, 9, 13, 13, 13, 13, 14, 17, 17, 17, fail, fail, fail ]
gap> w := "a";
"a"
gap> w := StringToStandardListOfPosInts(w);
[ 1 ]
gap> Right(w, 1);
[ 1 ]
gap> Left(w, 1);
[ 1 ]
gap> Right(w, 2);
[ fail ]
gap> Right(w, 100);
[ fail ]
gap> w := "aab";
"aab"
gap> w := StringToStandardListOfPosInts(w);
[ 1, 1, 2 ]
gap> Left(w, 2);
[ fail, fail, 1 ]
gap> Right(w, 2);
[ 3, 3, fail ]
gap> w := "";
""
gap> w := StringToStandardListOfPosInts(w);
[  ]
gap> Right(w, 1);
[  ]
gap> Right(w, 4);
[  ]
gap> w := "hellothere";
"hellothere"
gap> w := StringToStandardListOfPosInts(w);
[ 1, 2, 3, 3, 4, 5, 1, 2, 6, 2 ]
gap> Left(w, 4);
[ fail, fail, fail, fail, 1, 2, 3, 5, 6, 6 ]
