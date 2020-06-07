Right := function()
end;

LevelEdges := function(string, level, index)
  local i, j, rights, lefts, ltag, rtag, out;
  # expects a string, then an integer (less than size of content of string),
  # then a pair [i,j] of indices which should contain the same number of
  # different characters as the level.
  i := index[1];
  j := index[2];

  # for now let's make an array for the Right function.
  # TODO actually link this up to the Right function later.
  # provisional choice of "undefined" entry is -1.
  # we shouldn't have to worry about dealing with undefined inputs because
  # the existence of an interval with level characters implies the existence
  # of subintervals with level-1 characters.
  rights := [2, 4, 5, 6, 6, 7, -1];
  lefts  := [-1, -1, 1, 1, 1, 4, 6];
  # don't know if fail is usually used as a placeholder?

  if level = 1 then
    # all strings at this level have only the empty string below, which we
    # will represent as 1.
    # this case expects that index=[i,i] for some i.
    out := [1, string[i], string[i], 1];
  else
    # TODO we'll have to call RadixSort somewhere here
    # for now let's assume calling it gave us two numbers for left
    # and right: ltag and rtag.
    ltag := 7;
    rtag := 10;
    out  := [ltag, string[rights[i] + 1], string[lefts[j] - 1], rtag];
    # also note that rights[i] should never be at the end of the string
    # and lefts[j] should never be 1 by the same logic. This is because
    # otherwise, our string at the current level would contain the same
    # amount of different characters as its substring which is constructed
    # to have one less character.
  fi;
  return out;

end;

# Given a list A of lists of size 4, each entry of the form
# [i, a, b, j] where 1 <= a, b <= n and 1 <= i, j <= k
# where n is the length of A and k is the size of alphabet,
# output result a list of integers between 1 and n,  such that
# two entries in A are the same if and only if the
# corresponding entries in result are the same.
RadixSort := function(A, k)
  local B, result, count_sort, i, n, c;

  count_sort := function(A, i, radix)
    local B, C, a, j;
    B := ListWithIdenticalEntries(Length(A), 0);
    C := ListWithIdenticalEntries(radix, 0);
    for a in A do
      C[a[1][i]] := C[a[1][i]] + 1;
    od;
    for j in [2 .. radix] do
      C[j] := C[j] + C[j - 1];
    od;
    for a in Reversed(A) do
      B[C[a[1][i]]] := a;
      C[a[1][i]]    := C[a[1][i]] - 1;
    od;
    return B;
  end;

  n := Length(A);

  B := [];
  for i in [1 .. n] do
    Add(B, [A[i], i]);
  od;

  for i in [1 .. 4] do
    if i = 1 or i = 4 then
      B := count_sort(B, i, n);
    else
      B := count_sort(B, i, k);
    fi;
  od;

  result := ListWithIdenticalEntries(n, 0);
  c      := 1;
  for i in [2 .. n] do
    if B[i][1] <> B[i - 1][1] then
      c := c + 1;
    fi;
    result[B[i][2]] := c;
  od;
  result[B[1][2]] := 1;

  return result;
end;
