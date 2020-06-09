LoadPackage("semigroups");

D := Digraph([[2, 3], [5], [4, 5], [], []]);

# STRUCTURE OF DIGRAPH
#
#           5     4
#          / \   /
#         /   \ /
#        2     3
#         \   /
#          \ /
#           1
#

S1 := Semigroup(Transformation([1, 1, 1]),
                Transformation([1, 2, 3]),
                Transformation([1, 3, 2]));
S2 := MagmaWithZeroAdjoined(SymmetricGroup(3));
S3 := FullTransformationMonoid(4);
S4 := RightZeroSemigroup(4);
S5 := FullTransformationMonoid(3);

# FROM 5 TO 3

map53f := function(trans)
  local temp, out;
  # A clever way of embedding T3 in T4, fixing the point 1 rather than 4.
  temp := ShallowCopy(ListTransformation(trans)) + 1;
  out  := [1];
  Append(out, temp);
  return Transformation(out);
end;

map53 := MappingByFunction(S5, S3, map53f);

# FROM 3 TO 1

cong31  := SemigroupCongruence(S3, [[Transformation([1, 2, 4, 3]),
                                     Transformation([1, 3, 2, 4])]]);
# this congruence separates T_4 into three sets:
# A_4;
# S_4 \ A_4;
# all transformations with size of image < 4.

cong311 := CongruenceClassOfElement(cong31, Transformation([1, 2, 3, 1]));
cong312 := CongruenceClassOfElement(cong31, IdentityTransformation);
cong313 := CongruenceClassOfElement(cong31, Transformation([2, 3, 4, 1]));

map31f := function(trans)
  if trans in cong311 then
    return Transformation([1, 1, 1]);
  elif trans in cong312 then
    return Transformation([1, 2, 3]);
  elif trans in cong313 then
    return Transformation([1, 3, 2]);
  else
    return fail;
  fi;
end;

map31 := MappingByFunction(S3, S1, map31f);

# FROM 5 TO 2

map52f := function(trans)
  if Length(ImageSetOfTransformation(trans, 3)) < 3 then
    return MultiplicativeZero(S2);
  else
    return PermutationOfImage(trans) ^ UnderlyingInjectionZeroMagma(S2);
  fi;
end;

map52 := MappingByFunction(S5, S2, map52f);

# FROM 2 TO 1

map21f := function(magelem)
  local perm;
  perm := magelem ^ InverseGeneralMapping(UnderlyingInjectionZeroMagma(S2));
  if perm = fail then
    return Transformation([1, 1, 1]);
  elif perm in AlternatingGroup(3) then
    return Transformation([1, 2, 3]);
  else
    return Transformation([1, 3, 2]);
  fi;
end;

map21 := MappingByFunction(S2, S1, map21f);

# FROM 4 TO 3

map43 := IdentityMapping(S3);

# PUT IT ALL TOGETHER

S := [S1, S2, S3, S4, S5];

H := [[map21, map31], [map52], [map43, map53], [], []];

sl := StrongSemilatticeOfSemigroups(D, S, H);
