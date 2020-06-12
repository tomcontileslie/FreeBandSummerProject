LoadPackage("semigroups");
Read("freeband.g");

ListWords := function(gens, len)
  local n, words, prev, check, j, i, k;
  n     := gens ^ len;
  words := [ListWithIdenticalEntries(len, 1)];
  for i in [2 .. n] do

    prev := ShallowCopy(words[i - 1]);

    check := true;
    j     := len;
    while check do
      if prev[j] = gens then
        j := j - 1;
      else
        check := false;
      fi;
    od;

    prev[j] := prev[j] + 1;

    if j < len then
      for k in [j + 1 .. len] do
        prev[k] := 1;
      od;
    fi;

    Add(words, prev);
  od;

  return words;

end;

TestAllWords := function(gens, len)
  local S, words, n, og_test, fb_test, i, j;
  S     := FreeBand(gens);
  words := ListWords(gens, len);
  n     := Length(words);
  for i in [1 .. n] do
    for j in [i .. n] do
      og_test := EvaluateWord(GeneratorsOfSemigroup(S), words[i]) =
                 EvaluateWord(GeneratorsOfSemigroup(S), words[j]);
      fb_test := EqualInFreeBand(words[i], words[j]);
      if og_test <> fb_test then
        Print("Error on ", words[i], words[j]);
      fi;
    od;
  od;
  return true;
end;

# Generate a random list of length "len" whose entries
# are numbers in the range [1 .. "gens"]
RandomWordOverAlphabet := function(gens, len)
  return List([1 .. len], x -> Random(1, gens));
end;

# Given a word "word", repeatedly choose a random substring
# and then duplicates the substring in the word. This is repeated
# a total "repeats" number of times. The resulting string
# is equivalent to the original one in the free band.
# Currently chooses substring to extend by only uniformly at random
ElongateWordInFreeBand := function(word, repeats)
  local l, r, t, i, result;
  result := ShallowCopy(word);
  for i in [1 .. repeats] do
    l := Random(1, Length(result));
    r := Random(1, Length(result));
    if l > r then
      t := l;
      l := r;
      r := t;
    fi;
    result := Concatenation(result{[1 .. r]}, result{[l .. r]},
                            result{[r + 1 .. Length(result)]});
  od;
  return result;
end;
