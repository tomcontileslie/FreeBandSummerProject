Right := function(w, k)
  local right, i, j, subword_content_size, multiplicity,
  alphabet_size, w_num_rep, l, i_set;
  right        := [];
  j            := 1;
  w_content    := [];
  multiplicity := [];

  subword_content_size := 0;
  alphabet_size        := 0;
  w_num_rep            := [];

  # The first thing we do is convert w from a string in to a list of positive
  # integers. Each positive integer corresponds to each distinct letter in the
  # content of w, in order of first appearence. For example, "aabac" would be
  # represented as [1, 1, 2, 1, 3]. This is accompanied by a list, multiplicity,
  # which keeps track of the number of occurences of each letter in the 'sliding
  # window'. The i'th entry in multiplicity is the number of occurences of the
  # letter corresponding to i.  For example, if we were looking at the subword
  # "aab" in the above, multiplicity would be [2, 1, 0].
  #
  # My previous approach was to keep w as a string, and create a list called
  # w_content, whose entries are the distinct letters of w in order of first
  # appearence. For example, for "aabac", we would have content = [a, b, c].
  # An inefficiency in this approach was the fact that, if I wanted to call
  # the entry in multiplicity corresponding to a particular character w[i],
  # I had to first find the position of the character in content, i, and then
  # ask for multiplicity[i]. Representing w with positive integers instead,
  # we simply call multiplicity[w[i]], and so don't have to perform a list
  # search.

  for i in [1 .. Length(w)] do
    i_set := false;
    if i > 1 then
      for l in [1 .. i - 1] do
        if w[i] = w[l] then
          # w[i] has already appeared in the word, and been assigned to j
          w_num_rep[i] := w_num_rep[l];
          i_set        := true;
          break;
        fi;
      od;
    fi;
    if not i_set then
      alphabet_size := alphabet_size + 1;
      w_num_rep[i]  := alphabet_size;
      Add(multiplicity, 0);
    fi;
  od;

  w := w_num_rep;  # Replace w with its number representation

  # In the ith iteration of the below letter of w, and construct a subword,
  # moving as far in to w as we can before the content of the subword exceeds
  # k. When we move to i + 1 from i, we can delete the first entry of subword
  # from the previous iteration, and then we have a similar subword starting
  # from the correct place.

  for i in [1 .. Length(w)] do
    if i > 1 then
      # If i > 1, we want to delete the letter corresponding to our previous
      # subword starting position of i - 1. Since we're not actually storing
      # the subword itself, this corresponds to lowering the multiplicity
      # of the character corresponding to w[i - 1] in subword by 1.

      multiplicity[w[i - 1]] := multiplicity[w[i - 1]] - 1;
      if multiplicity[w[i - 1]] = 0 then
        # If we just deleted the last instance of the character corresponding
        # to w[i - 1] from the subword, then the content size of the subword
        # has decreased by 1.
        subword_content_size := subword_content_size - 1;
      fi;
    fi;
    while j <= Length(w) and subword_content_size <= k do
      if multiplicity[w[j]] = 0 then
        # If w[j] has zero multiplicity in the subword, then by adding it
        # we increase the content size by 1.
        subword_content_size := subword_content_size + 1;
      fi;
      multiplicity[w[j]] := multiplicity[w[j]] + 1;
      # The multiplicity of w[j], having just been added to our subword, is
      # increased by 1.
      j := j + 1;
      # We move the end of our subword along by one.
    od;
    if subword_content_size = k + 1 then
      # If the loop ended with content size k + 1, this means that the last
      # character we added wasn't already in the subword, and was the one which
      # took us over our content size limit of k. Our k-right interval must have
      # ended on the letter before this character.
      right[i]               := j - 2;
      # Since we increase j by one at the end of the loop, the position in w
      # of the character which took us over the k threshold is j - 1, and so
      # the k-right interval ends at j - 2, the position before this.
      multiplicity[w[j - 1]] := 0;
      subword_content_size   := subword_content_size - 1;
      j                      := j - 1;
      # This rolls the right bound of the subword back to where it was just
      # before the character which took us over the k size threshold was met.
      # Actually, I could possibly refactor this so we 'stay' here. The first
      # thing that happens when we return to the loop is returning the j'th
      # character, so we might as well not roll it back.
    elif subword_content_size = k then
      right[i] := j - 1;
      # If the loop ended with content size k, this means we reached the end
      # of the word. I could possibly tidy up this piece too.
    elif subword_content_size < k then
      right[i] := -1;
      # If the loop ended and the content size was less than k, this means that
      # the subword from the i'th position to the end of word w contains fewer
      # than k distinct characters, and so no k-right interval starts from
      # position i. We use -1 to denote this.
    fi;
  od;
  return right;
end;

Left := function(w, k)
  local i, left;
  w    := Reversed(w);
  left := Reversed(f(w, k));
  for i in [1 .. Length(w)] do
    if left[i] <> -1 then
      left[i] := Length(w) - left[i] + 1;
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
