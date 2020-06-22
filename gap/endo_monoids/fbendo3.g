# write an endo as a list showing where each generator gets mapped
# as a product of generators, e.g.

n     := 3;
fb    := FreeBand(n);
elts  := Elements(fb);
eltsf := List(elts, x -> Factorization(fb, x));
fbgs  := GeneratorsOfSemigroup(fb);

# this doesn't generate all endos but about 1/4 of them
# for which we now have a small number of generators.
eltsf_old := [[1],
              [2],
              [3],
              [1, 2],
              [1, 2, 1],
              [1, 2, 1, 3],
              [1, 2, 1, 3, 1],
              [1, 2, 1, 3, 1, 2],
              [1, 2, 1, 3, 1, 2, 1],
              [1, 2, 1, 3, 1, 2, 3],
              [1, 2, 1, 3, 1, 2, 3, 2],
              [1, 2, 1, 3, 2],
              [1, 2, 1, 3, 2, 1],
              [1, 2, 1, 3, 2, 1, 2],
              [1, 2, 1, 3, 2, 3],
              [1, 2, 1, 3, 2, 3, 1],
              [1, 2, 1, 3, 2, 3, 1, 3],
              [1, 2, 3],
              [1, 2, 3, 1],
              [1, 2, 3, 1, 2],
              [1, 2, 3, 1, 2, 1],
              [1, 2, 3, 1, 3],
              [1, 2, 3, 1, 3, 2],
              [1, 2, 3, 1, 3, 2, 3],
              [1, 2, 3, 2],
              [1, 2, 3, 2, 1],
              [1, 2, 3, 2, 1, 2],
              [1, 2, 3, 2, 1, 3],
              [1, 2, 3, 2, 1, 3, 1]];

# CONSIDERATIONS TO REMOVE SOME REDUNDANCY FROM THE TUPLE ITER
# - for a tuple [u, v, w], we can do:
#           [gen, gen, gen] [u, v, w] [gen, gen, gen]
#   to get it into a form where the first element is (not
#   strictly) shorter than the second, same for third, and
#   also s.t. the first element is in standard form.
# - we don't need repeats: we can just pre-map by e.g. [1, 2, 2].
# - we don't need endos generates in eltsf_old since we now have
#   a set of generators for them.

# this will give us the standard form
# WARNING this is dependent on another file
Read("../freeband.g");

tuple_iter := [];
for i in eltsf do
  if ListOfPosIntsToStandardListOfPosInts(i) = i then
    for j in eltsf do
      if Length(j) >= Length(i) and j <> i then
        for k in eltsf do
          if Length(k) >= Length(j) and k <> j and k <> i then
            if not (j in eltsf_old and k in eltsf_old) then
              Add(tuple_iter, [i, j, k]);
            fi;
          fi;
        od;
      fi;
    od;
  fi;
od;

# WARNING: this may have neglected some corner cases where i is
# one of the longest words, and where there are repeats.
# Can probably add the remaining cases manually
#
#
#
# don't actually need this
PositionInElts := function(fb, elts, eltsf, fbgs, list)
  return Position(elts, EvaluateWord(fbgs, list));
end;

ApplyEndoListToElement := function(fb, eltsf, fbgs, tuple, elem)
  local expandgens;
  expandgens := List(elem, x -> tuple[x]);
  return Factorization(fb, EvaluateWord(fbgs, Flat(expandgens)));
end;

EndoListToEndoTransformation := function(fb, eltsf, fbgs, tuple)
  local trans, elem;
  trans := [];
  for elem in eltsf do
    Add(trans, Position(eltsf,
                        ApplyEndoListToElement(fb, eltsf, fbgs, tuple, elem)));
  od;
  return Transformation(trans);
end;

EndoTransformationToEndoList := function(fb, eltsf, fbgs, trans)
  return [eltsf[1 ^ trans],
          eltsf[54 ^ trans],
          eltsf[107 ^ trans]];
end;

AllTransformationsOfEndoMonoid := function(fb, eltsf, fbgs, tuple_iter)
  local gensofm, counter, marks, n, tuple;
  gensofm := [];
  counter := 0;
  marks   := ListWithIdenticalEntries(100, false);
  n       := Length(tuple_iter);

  for tuple in tuple_iter do
    counter := counter + 1;
    if not marks[Int(100 * counter / n) + 1] then
      marks[Int(100 * counter / n) + 1] := true;
      Print(Int(100 * counter / n), "%\n");
    fi;
    Add(gensofm, EndoListToEndoTransformation(fb, eltsf, fbgs, tuple));
  od;

  return gensofm;
end;

AllOrderTwoProducts := function(generators)
  local n, out, i, j;
  n       := Length(generators);
  out     := [];
  for i in [1 .. n] do
    if IsInt(i / 1000) then
      Print(Float(i / n), " of done\n");
    fi;

    for j in [i .. n] do
      Add(out, generators[i] * generators[j]);
    od;
  od;
  return out;
end;

AllOrderTwoProductsFromTo := function(generators, from, to)
  local n, out, i, j;
  n       := Length(generators);
  out     := [];
  for i in [from .. to] do
    if IsInt(i / 1000) then
      Print(Float(i / n), " of done\n");
    fi;

    for j in [i .. n] do
      Add(out, generators[i] * generators[j]);
    od;
  od;
  return out;
end;

UpdateSemigroup := function(T, gens)
  while not IsEmpty(gens) do
    gens := Filtered(gens, x -> not x in T);
    gens := Shuffle(gens);
    Sort(gens, {x, y} -> RankOfTransformation(x, 159) >
                         RankOfTransformation(y, 159));
    if not IsEmpty(gens) then
      T := ClosureMonoid(T, gens[1]);
    fi;
    Print("The number of generators left is ", Length(gens), "\n");
    GASMAN("collect");
  od;
end;
