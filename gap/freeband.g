# Its useful to work with lists of positive integers, rather than simply strings.
# Every string will be represented as a list of positive integers, the distinct
# numbers of which corresponds to distinct characters of the string.
# The ordering of the integers is exactly the ordering of their corresponding
# characters by their first appearence.
# For example, we represent the string "bbababc" as [1, 1, 2, 1, 2, 1, 3].

StringToListOfPosInts := function(string)
  local L, distinct_chars, lookup, i;

  L := Length(string);
  if L = 0 then
    return [];
  fi;

  string := List(string, IntChar);  # Converts string into a list of positive
                                    # integers corresponding to each character
  distinct_chars := 1;
  lookup         := [];
  # lookup will build a correspondence between the positive integers in string,
  # and the positive integers [1 .. n] where n is the number of distinst
  # numbers in string.

  lookup[string[1]] := 1;  # Represent the first entry in string as 1.
  string[1]         := lookup[string[1]];
  for i in [2 .. L] do
    if IsBound(lookup[string[i]]) then
      # If the string[i] entry has already been assigned a number in [1 .. n]
      # then we reassign string[i] to this number.
      string[i] := lookup[string[i]];
    else
      # If string[i] entry hasn't already been assigned a number in [1 .. n],
      # then we need to give it the lowest available one. distinct_chars keeps
      # track of this number.
      distinct_chars    := distinct_chars + 1;
      lookup[string[i]] := distinct_chars;
      string[i]         := lookup[string[i]];
    fi;
  od;

  return string;
end;

Right := function(w, k)
  local right, i, j, subword_content_size, multiplicity, length_w;

  length_w := Length(w);
  if length_w = 0 then
    return [];
  fi;

  w := StringToListOfPosInts(w);

  # In the ith iteration of the below, we start at the ith letter of w
  # and construct a subword, moving as far in to w as we can before the
  # size of the content of the subword exceeds k. When we move to i + 1
  # from i, we can delete the first entry of subword from the previous
  # iteration, and then we inherit the first piece of the next subword,
  # starting from the correct place.

  j                    := 0;
  right                := [];
  subword_content_size := 0;
  multiplicity         := List([1 .. Maximum(w)], x -> 0);

  # subword_content_size keeps track of the number of distinct characters
  # in the subword of w we are looking at in the 'sliding window'. We keep
  # track of subword_content_size by using a list, multiplicity. The i'th
  # position of multiplicity is the number of occurrences in the subword of
  # the character of w which we represent as i (via StringToListOfPosInts).
  # multiplicity has length Maximum(w), since Maximum(w) is precisely the
  # number of distinct characters in w.

  for i in [1 .. length_w] do
    if i > 1 then
      # If i > 1, we want to delete the letter corresponding to our previous
      # subword starting position of i - 1. Since we're not actually storing
      # the subword itself, this corresponds to lowering the multiplicity
      # of the character corresponding to w[i - 1] in subword by 1.

      # For when James reviews this: I felt I should keep this conditional,
      # since deleting it (as far as I can see!) would mean basically
      # replicating the below while loop and assignments of right[i] for
      # the i = 1 case. I'm not sure if duplicate code is a good idea.
      # A thought I had was to stick a dummy character onto the beginning
      # of w. The iteration where we start at w[1] would change to start
      # at w[2], and deleting the previous character would just be deleting
      # the dummy character in this case. However, again, from a readability
      # point of view this might not make sense.

      multiplicity[w[i - 1]] := multiplicity[w[i - 1]] - 1;
      if multiplicity[w[i - 1]] = 0 then
        # If we just deleted the last instance of the character corresponding
        # to w[i - 1] from the subword, then the content size of the subword
        # has decreased by 1.
        subword_content_size := subword_content_size - 1;
      fi;
    fi;
    while j < length_w and
        (multiplicity[w[j + 1]] <> 0 or subword_content_size < k) do
      j := j + 1;
      if multiplicity[w[j]] = 0 then
        # If w[j] has zero multiplicity in the subword, then by adding it
        # we increase the content size by 1.
        subword_content_size := subword_content_size + 1;
      fi;
      multiplicity[w[j]] := multiplicity[w[j]] + 1;
      # The multiplicity of w[j], having just been added to our subword, is
      # increased by 1.
    od;
    # For when James reviews this: I've kept this as a while loop, but have
    # restructurd it in a way which makes assigning right[i] a lot simpler.
    # In particular, when we reach a letter which would make the content
    # exceed size k, we just do nothing, rather than adding the letter to
    # our subword and then removing it!

    # If the loop ended with content_size_k, then either we reached the end of
    # w, or met a new letter and stopped. In either case, the k-right interval
    # starting at i is [i .. j].
    if subword_content_size = k then
      right[i] := j;
    else
      right[i] := fail;
    fi;
  od;
  return right;
end;

Left := function(w, k)
  local i, left, length_w;
  length_w := Length(w);
  w        := Reversed(w);
  left     := Reversed(Right(w, k));
  for i in [1 .. length_w] do
    if left[i] <> fail then
      left[i] := length_w - left[i] + 1;
    fi;
  od;
  return left;
end;

# It might be slightly more effective if this were replaced with an analogue of
# the Right method, but since I've still got a few ideas for tidying Right up,
# I'll wait until then to do this.

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
