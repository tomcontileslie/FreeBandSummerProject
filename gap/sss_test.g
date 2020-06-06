LoadPackage("semigroups");

D := Digraph([ [2, 3], [4, 5], [5], [ ], [ ] ]);

S1 := fail;
S2 := fail;
S3 := fail;
S4 := fail;
S5 := FullTransformationMonoid(3);

# the map from 5 to 3 embeds T_3 in T_4 by adding a constant 4.

map53 :=  function(trans)
  return Transformation(Add(ListTransformation(trans), 4));
  # WARNING does not currently work because the list is immutable
end;
