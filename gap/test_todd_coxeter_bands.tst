# Tests for the Todd-Coxeter for bands method, created using the generators
# of the free band on 3 letters in libsemigroups_cppyy

gap> R := [[[2, 1], [1, 2]]];;
gap> ToddCoxeterBand(3, R);
28
gap> R := [[[2, 1], [1, 2]], [[1, 2, 3], [1, 3, 2]]];;
gap> ToddCoxeterBand(3, R);
18
gap> R := [[[1], [2]]];;
gap> ToddCoxeterBand(3, R);
6
gap> R := [[[1, 2], [2, 3]]];;
gap> ToddCoxeterBand(3, R);
16
gap> R := [[[1, 2], [2, 3]], [[2, 1], [3]]];;
gap> ToddCoxeterBand(3, R);
3
gap> R := [[[2, 1, 2, 3], [1, 2, 1]]];;
gap> ToddCoxeterBand(3, R);
19
gap> R := [[[1, 2, 1], [1]], [[2, 1, 2], [1]]];;
gap> ToddCoxeterBand(3, R);
16
gap> R := [[[1, 2, 3], [1, 2]], [[2, 3, 2], [3]]];;
gap> ToddCoxeterBand(3, R);
9
gap> R := [[[1, 2], [1]]];;
gap> ToddCoxeterBand(3, R);
36
