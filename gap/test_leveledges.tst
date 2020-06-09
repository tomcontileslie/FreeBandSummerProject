#### TEST 1: k=1 trivial output
gap> t1 := LevelEdges([1, 2, 3], 1, [], [], [], [], []);;
gap> t2 := [[1, 1, 1, 1],
>           [1, 2, 2, 1],
>           [1, 3, 3, 1],
>           [1, 1, 1, 1],
>           [1, 2, 2, 1],
>           [1, 3, 3, 1]];;
gap> t1 = t2;
true

#### TEST 2: all-fail input
gap> t3 := LevelEdges([1, 2, 3], 2, [], [fail, fail, fail], [fail, fail, fail], [], []);;
gap> t4 := ListWithIdenticalEntries(6, [fail, fail, fail, fail]);;
gap> t3 = t4;
true

### TEST 3: first and second half of radix list assignment
gap> t5 := LevelEdges([0, 0, 0], 2, [1, 1, 1, 2, 2, 2], [2, fail, 2], [2, fail, 2], [2, 2, 2], [2, 2, 2]);;
gap> t6 := [[1, 0, 0, 2], [fail, fail, fail, fail], [1, 0, 0, 2], [1, 0, 0, 2], [fail, fail, fail, fail], [1, 0, 0, 2]];;
gap> t5 = t6;
true

### TEST 4: more involved example, currently with manual radix variable
gap> b := "aaabcbcbdbcbabcd";;
gap> radix := [2, 2, 2, 6, 9, 6, 9, 8,
>              11, 6, 9, 3, 2, 5, 10, fail,
>              fail, fail, fail, 1, 5, 6, 5, 6,
>              7, 8, 5, 6, 4, 3, 5, 10];;
gap> w := StringToStandardListOfPosInts(b);;
gap> rightk := Right(w, 3);; leftk := Left(w, 3);; rightm := Right(w, 2);; leftm := Left(w, 2);;
gap> t7 := LevelEdges(w, 3, radix, rightk, leftk, rightm, leftm);;
gap> t8 := [[2, 3, 1, 6], [2, 3, 1, 6], [2, 3, 1, 6], [6, 4, 4, 6], [9, 4, 4, 6], [6, 4, 4, 6], [9, 4, 4, 6], [8, 3, 4, 6], [11, 3, 4, 6], [6, 1, 1, 5], [9, 1, 1, 5], [3, 3, 1, 5], [2, 3, 1, 5], [5, 4, 2, 10], [fail, fail, fail, fail], [fail, fail, fail, fail], [fail, fail, fail, fail], [fail, fail, fail, fail], [fail, fail, fail, fail], [fail, fail, fail, fail], [2, 2, 1, 5], [2, 2, 1, 6], [2, 2, 1, 5], [2, 2, 1, 6], [6, 2, 3, 7], [6, 2, 3, 8], [6, 2, 4, 5], [6, 2, 4, 6], [6, 2, 3, 4], [6, 2, 3, 3], [6, 2, 1, 5], [5, 4, 2, 10]];;
gap> t7 = t8;
true
