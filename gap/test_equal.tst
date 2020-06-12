gap> Read("freeband.g");;
gap> Read("looptest.g");;

# Small tests
gap> EqualInFreeBand([1, 2, 1, 2, 2, 2, 3, 2, 3], [1, 2, 3]);
true
gap> EqualInFreeBand([1, 2, 1, 2, 2, 2, 3, 2, 3, 2], [1, 2, 3]);
false
gap> EqualInFreeBand([], []);
true
gap> EqualInFreeBand([1, 2, 3], []);
false
gap> EqualInFreeBand([1, 2, 3, 3, 2, 1], [1, 3]);
false
gap> EqualInFreeBand([1, 1, 1, 1], [2, 2, 2, 2]);
false
gap> EqualInFreeBand([2, 2, 2, 2, 2, 2], [2, 2, 2, 2]);
true

# Random word with itself, three ways
gap> t := RandomWordOverAlphabet(100, 1000);;
gap> EqualInFreeBand(t, t);
true
gap> t := RandomWordOverAlphabet(100, 1000);;
gap> EqualInFreeBand(t, Concatenation(t, t{[999, 1000]}));
true
gap> t := RandomWordOverAlphabet(100, 1000);;
gap> EqualInFreeBand(t, Concatenation(t, t));
true

# Radom words with elongation method
# Uniformly random
gap> t := RandomWordOverAlphabet(10, 100);;
gap> u := ElongateWordInFreeBand(t, 10);;
gap> EqualInFreeBand(t, u);
true
gap> v := ElongateWordInFreeBand(t, 10);;
gap> EqualInFreeBand(u, v);
true
gap> t := RandomWordOverAlphabet(5, 20);;
gap> u := ElongateWordInFreeBand(t, 30);;
gap> EqualInFreeBand(t, u);
true
gap> v := ElongateWordInFreeBand(t, 30);;
gap> EqualInFreeBand(u, v);
true
