# write an endo as a list showing where each generator gets mapped
# as a product of generators, e.g.

n     := 3;
fb    := FreeBand(n);
elts  := Elements(fb);
eltsf := List(elts, x -> Factorization(fb, x));
fbgs  := GeneratorsOfSemigroup(fb);

# I think this generates the full thing
eltsf_alt := [[1],
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

AllTransformationsOfEndoMonoid3 := function(fb, eltsf, fbgs, eltsf_alt)
  local gensofm, counter, tuple, i, j, k;
  gensofm := [];
  counter := 0;
  for i in eltsf_alt do
    counter := counter + 1;
    Print("\nOn ", counter, "/29\n");
    for j in eltsf_alt do
      Print("x");
      for k in eltsf_alt do
        tuple := [i, j, k];
        Add(gensofm, EndoListToEndoTransformation(fb, eltsf, fbgs, tuple));
      od;
    od;
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
