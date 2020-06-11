gap> #### TEST 1: k=1 trivial output
gap> t1 := LevelEdges([1, 2, 3], 1, [], [], [], [], []);;
gap> t2 := [[1, 1, 1, 1],
>           [1, 2, 2, 1],
>           [1, 3, 3, 1],
>           [1, 1, 1, 1],
>           [1, 2, 2, 1],
>           [1, 3, 3, 1]];;
gap> t1 = t2;
true
gap> #### TEST 2: all-fail input
gap> t3 := LevelEdges([1, 2, 3], 2, [], [fail, fail, fail], [fail, fail, fail], [], []);;
gap> t4 := ListWithIdenticalEntries(6, [fail, fail, fail, fail]);;
gap> t3 = t4;
true
gap> ### TEST 3: first and second half of radix list assignment
gap> t5 := LevelEdges([0, 0, 0], 2, [1, 1, 1, 2, 2, 2], [2, fail, 2], [2, fail, 2], [2, 2, 2], [2, 2, 2]);;
gap> t6 := [[1, 0, 0, 2], [fail, fail, fail, fail], [1, 0, 0, 2], [1, 0, 0, 2], [fail, fail, fail, fail], [1, 0, 0, 2]];;
gap> t5 = t6;
true
gap> ### TEST 4: more involved example, currently with manual radix variable
gap> b := "aaabcbcbdbcbabcd";;
gap> w := StringToStandardListOfPosInts(b);;
gap> level1 := LevelEdges(w, 1, [], [], [], [], []);;
gap> level1r := [ [ 1, 1, 1, 1 ], [ 1, 1, 1, 1 ], [ 1, 1, 1, 1 ], [ 1, 2, 2, 1 ], [ 1, 3, 3, 1 ], [ 1, 2, 2, 1 ], [ 1, 3, 3, 1 ], [ 1, 2, 2, 1 ], [ 1, 4, 4, 1 ], [ 1, 2, 2, 1 ], [ 1, 3, 3, 1 ], [ 1, 2, 2, 1 ], [ 1, 1, 1, 1 ], [ 1, 2, 2, 1 ], [ 1, 3, 3, 1 ], [ 1, 4, 4, 1 ], [ 1, 1, 1, 1 ], [ 1, 1, 1, 1 ], [ 1, 1, 1, 1 ], [ 1, 2, 2, 1 ], [ 1, 3, 3, 1 ], [ 1, 2, 2, 1 ], [ 1, 3, 3, 1 ], [ 1, 2, 2, 1 ], [ 1, 4, 4, 1 ], [ 1, 2, 2, 1 ], [ 1, 3, 3, 1 ], [ 1, 2, 2, 1 ], [ 1, 1, 1, 1 ], [ 1, 2, 2, 1 ], [ 1, 3, 3, 1 ], [ 1, 4, 4, 1 ] ];;
gap> level1 = level1r;
true
gap> radix1 := RadixSort(level1, 4);;
gap> rightk := Right(w, 2);; leftk := Left(w, 2);; rightm := Right(w, 1);; leftm := Left(w, 1);;
gap> level2 := LevelEdges(w, 2, radix1, rightk, leftk, rightm, leftm);;
gap> level2r := [ [ 1, 2, 1, 2 ], [ 1, 2, 1, 2 ], [ 1, 2, 1, 2 ], [ 2, 3, 3, 2 ], [ 3, 2, 3, 2 ], [ 2, 3, 3, 2 ], [ 3, 2, 3, 2 ], [ 2, 4, 4, 2 ], [ 4, 2, 4, 2 ], [ 2, 3, 3, 2 ], [ 3, 2, 3, 2 ], [ 2, 1, 1, 2 ], [ 1, 2, 1, 2 ], [ 2, 3, 2, 3 ], [ 3, 4, 3, 4 ], [ fail, fail, fail, fail ], [ fail, fail, fail, fail ], [ fail, fail, fail, fail ], [ fail, fail, fail, fail ], [ 1, 2, 1, 2 ], [ 2, 3, 2, 3 ], [ 2, 3, 3, 2 ], [ 2, 3, 2, 3 ], [ 2, 3, 3, 2 ], [ 2, 4, 2, 4 ], [ 2, 4, 4, 2 ], [ 2, 3, 2, 3 ], [ 2, 3, 3, 2 ], [ 2, 1, 2, 1 ], [ 2, 1, 1, 2 ], [ 2, 3, 2, 3 ], [ 3, 4, 3, 4 ] ];;
gap> level2 = level2r;
true
gap> radix2 := RadixSort(level2, 4);;
gap> rightk := Right(w, 3);; leftk := Left(w, 3);; rightm := Right(w, 2);; leftm := Left(w, 2);;
gap> level3 := LevelEdges(w, 3, radix2, rightk, leftk, rightm, leftm);;
gap> level3r := [ [ 3, 3, 1, 5 ], [ 3, 3, 1, 5 ], [ 3, 3, 1, 5 ], [ 5, 4, 4, 5 ], [ 4, 4, 4, 5 ], [ 5, 4, 4, 5 ], [ 4, 4, 4, 5 ], [ 7, 3, 4, 5 ], [ 6, 3, 4, 5 ], [ 5, 1, 1, 8 ], [ 4, 1, 1, 8 ], [ 2, 3, 1, 8 ], [ 3, 3, 1, 8 ], [ 8, 4, 2, 10 ], [ fail, fail, fail, fail ], [ fail, fail, fail, fail ], [ fail, fail, fail, fail ], [ fail, fail, fail, fail ], [ fail, fail, fail, fail ], [ fail, fail, fail, fail ], [ 3, 3, 1, 8 ], [ 3, 3, 1, 5 ], [ 3, 3, 1, 8 ], [ 3, 3, 1, 5 ], [ 5, 4, 3, 9 ], [ 5, 4, 3, 7 ], [ 5, 4, 4, 8 ], [ 5, 4, 4, 5 ], [ 5, 1, 3, 1 ], [ 5, 1, 3, 2 ], [ 5, 1, 1, 8 ], [ 8, 4, 2, 10 ] ];;
gap> level3 = level3r;
true
