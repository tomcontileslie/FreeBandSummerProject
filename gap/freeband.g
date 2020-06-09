# Its useful to work with lists of positive integers, rather than simply strings.
# Every string will be represented as a list of positive integers, the distinct
# numbers of which corresponds to distinct characters of the string.
# The ordering of the integers is exactly the ordering of their corresponding
# characters by their first appearence.
# For example, we represent the string "bbababc" as [1, 1, 2, 1, 2, 1, 3].

ListOfPosIntsToStandardListOfPosInts := function(list)
  local L, distinct_chars, lookup, i;
  if not IsList(list) then
    ErrorNoReturn("expected a list as the argument");
  fi;
  for i in list do
    if not IsPosInt(i) then
      ErrorNoReturn("expected a list of positive integers as the argument");
    fi;
  od;
  L := Length(list);
  if L = 0 then
    return [];
  fi;

  distinct_chars := 1;
  lookup         := [];
  # lookup will build a correspondence between the positive integers in string,
  # and the positive integers [1 .. n] where n is the number of distinst
  # numbers in string.

  lookup[list[1]] := 1;  # Represent the first entry in string as 1.
  list[1]         := lookup[list[1]];
  for i in [2 .. L] do
    if IsBound(lookup[list[i]]) then
      # If the string[i] entry has already been assigned a number in [1 .. n]
      # then we reassign string[i] to this number.
      list[i] := lookup[list[i]];
    else
      # If string[i] entry hasn't already been assigned a number in [1 .. n],
      # then we need to give it the lowest available one. distinct_chars keeps
      # track of this number.
      distinct_chars  := distinct_chars + 1;
      lookup[list[i]] := distinct_chars;
      list[i]         := lookup[list[i]];
    fi;
  od;

  return list;
end;

StringToStandardListOfPosInts := function(string)
  if not IsString(string) then
    ErrorNoReturn("expected a string as the argument, found ", string);
  elif Length(string) = 0 then
    return [];
  fi;
  return ListOfPosIntsToStandardListOfPosInts(List(string, IntChar));
  # If we get a list of positive integers from string using IntChar, then we
  # can just use the ListOfPosIntsToStandardListOfPosInts method on that.
end;

Right := function(w, k)
  local max_char, right, i, j, subword_content_size,
  multiplicity, length_w;
  # We need to check that w is of the form we agreed. I think in the meeting
  # on Monday we agreed that we will use the list of positive integers
  # representation.
  if not IsList(w) then
    ErrorNoReturn("expected a list as first argument");
  elif not IsPosInt(k) then
    ErrorNoReturn("expected a positive integer as second argument");
  fi;
  max_char := 0;
  for i in w do
    if not IsPosInt(i) then
      ErrorNoReturn("expected first argument to be a list of positive integers");
    fi;
    if i > max_char + 1 then
      ErrorNoReturn("expected first argument w to be a list of positive ",
                    "integers which contains at least one instance of each ",
                    "integer in [1 .. Maximum(w)], and whose entries are ",
                    "ordered in order of first appearence.");
      # For when James reviews this: I hope this error message makes at least
      # some sense!
    elif i > max_char then
      max_char := max_char + 1;
    fi;
  od;
  length_w := Length(w);
  if length_w = 0 then
    return [];
  fi;

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
  local max_char, i, left, length_w;
  if not IsList(w) then
    ErrorNoReturn("expected a list as first argument");
  elif not IsPosInt(k) then
    ErrorNoReturn("expected a positive integer as second argument");
  fi;
  max_char := 0;
  for i in w do
    if not IsPosInt(i) then
      ErrorNoReturn("expected first argument to be a list of positive integers");
    fi;
    if i > max_char + 1 then
      ErrorNoReturn("expected first argument w to be a list of positive ",
                    "integers which contains at least one instance of each ",
                    "integer in [1 .. Maximum(w)], and whose entries are ",
                    "ordered in order of first appearence.");
    elif i > max_char then
      max_char := max_char + 1;
    fi;
  od;

  length_w := Length(w);
  w        := ListOfPosIntsToStandardListOfPosInts(Reversed(w));
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

LevelEdges := function(w, k radixr, radixl, rightk, leftk, rightm, leftm)
  local n, outr, outl, i;
  # Takes an input word and a level (size of content), and returns
  # two lists of 4-tuples: a right list and a left list. Right first.
  #
  # Assumes that the outputs of other functions are passed as input:
  # rightk = Right(w, k)
  # leftk  = Left(w, k)
  # rightm = Right(w, k-1)
  # leftm  = Left(w, k-1)
  # radixr = radix called on LevelEdges from level k-1, right list
  # radixl = radix called on LevelEdges from level k-1, left list
  #
  # if this is too difficult then we can call functions inside this one
  # rather than passing input. This risks calculating some things twice.

  n    := Length(w);

  outr := [];
  outl := [];

  if k = 1 then
    # in this case, regardless of the length of each node, the 4-tuples
    # have the empty word (1) as outer coordinates and the single character
    # w[i] as inner coordinates.
    for i in [1 .. n] do
      Add(outr, [1, w[i], w[i], 1]);
      Add(outl, [1, w[i], w[i], 1]);
    od;
  else
    for i in [1 .. n] do
      if rightk[i] <> fail then
        Add(outr, [radixr[i], w[rightm[i] + 1],
                   w[leftm[rightk[i]] - 1], radixl[rightk[i]]]);
      else
        Add(outr, fail);
      fi;

      if leftk[i] <> fail then
        Add(outl, [radixr[leftk[i]], w[rightm[leftk[i] + 1],
                   w[leftm[i] - 1], radixl[i]]);
      else
        Add(outl, fail);
      fi;
    od;
  fi;
  return [outr, outl];

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
