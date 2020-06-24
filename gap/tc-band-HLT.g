ToddCoxeterBand := function(N, R)
  local new_coset, tauf, canon, push_relation, process_coincidences,
  A, F, G, k, active_cosets, table, coincidences, words, n, word,
  pair, char, coset;

  new_coset := function(coset, char)
    local new_word, pos;
    # new_coset for bands is smart. If the word created, once reduced,
    # is already somewhere else in the list, then it just sets
    # table[coset][char] to be that coset.
    if table[coset][char] = 0 then
      new_word := canon(Concatenation(words[coset], [char]));
      pos      := Position(words, new_word);

      if pos = fail then
        # in this case the word is genuinely new and we make a new coset
        table[coset][char] := k;
        active_cosets[k]   := true;
        Add(table, ListWithIdenticalEntries(Length(A), 0));
        Add(words, new_word);
        k := k + 1;

      else
        # word already exists
        table[coset][char] := pos;

      fi;
    fi;
  end;

  tauf := function(coset, word)
    local char;
    # forced tau. This creates new cosets as necessary.
    if Length(word) = 0 then
      return coset;
    fi;
    for char in word do
      if table[coset][char] = 0 then
        # if the product is undefined, define it, and start coset back up
        # at the newly defined value (k-1).
        new_coset(coset, char);
      fi;
      coset := table[coset][char];
    od;
    return coset;
  end;

  canon := function(word)
    # expresses a word in free band-canonical form.
    if IsEmpty(word) then
      return [];
    fi;
    return SEMIGROUPS.FreeBandElmToWord(EvaluateWord(G, word));
  end;

  push_relation := function(coset, u, v)
    local ut, vt;
    ut := tauf(coset, u);
    vt := tauf(coset, v);
    if ut <> vt then
      Add(coincidences, [ut, vt]);
    fi;
  end;

  process_coincidences := function()
    local i, j, char, coset, pair;
    if Length(coincidences) = 0 then
      return;
    fi;
    while Length(coincidences) <> 0 do
      i := Minimum(coincidences[1]);
      j := Maximum(coincidences[1]);
      if i <> j then
        for char in A do
          if table[j][char] <> 0 then
            if table[i][char] = 0 then
              table[i][char] := table[j][char];
            elif table[i][char] <> 0 then
              Add(coincidences, [table[i][char], table[j][char]]);
            fi;
          fi;
        od;
        for coset in ListBlist([1 .. k - 1], active_cosets) do
          for char in A do
            if table[coset][char] = j then
              table[coset][char] := i;
            fi;
          od;
        od;
        for pair in coincidences do
          if pair[1] = j then
            pair[1] := i;
          fi;
          if pair[2] = j then
            pair[2] := i;
          fi;
        od;
        active_cosets[j] := false;
      fi;
      Remove(coincidences, 1);
      # Unbind(parents[j]);
      # Unbind(edges[j]);
    od;
  end;

  A             := [1 .. N];
  F             := FreeBand(N);
  G             := GeneratorsOfSemigroup(F);
  k             := 2;
  active_cosets := [true];
  table         := [[]];
  coincidences  := [];
  words         := [[]];
  for char in A do
    table[1][char] := 0;
  od;
  n := 0;
  repeat

    n  := n + 1;

    # only do anything if the current coset is active
    if active_cosets[n] then

      # populate the current line of the table with new cosets if need be
      for char in A do
        new_coset(n, char);
      od;

      # push the coset n through every explicit relation
      for pair in R do
        push_relation(n, pair[1], pair[2]);
      od;

      # push the coset through every known implicit relation
      for word in ListBlist(words, active_cosets) do
        pair := [canon(Concatenation(word, word)), word];
        push_relation(n, canon(pair[1]), canon(pair[2]));
      od;

    fi;

    process_coincidences();

  until n = k - 1;

  for pair in R do
    if Length(pair[1]) = 0 or Length(pair[2]) = 0 then
      # then one of these must be a monoid presentation.
      return Length(ListBlist([1 .. k - 1], active_cosets));
    fi;
  od;

  # if no relations have the empty word then this is not a monoid presentation.
  return Length(ListBlist([1 .. k - 1], active_cosets)) - 1;
end;

# this function just helps generate sets of relations
poprules2 := function(max, sample_pair)
  local out, trans, i, j;
  out   := [];
  trans := function(n)
    if n = 1 then
      return i;
    fi;
    if n = 2 then
      return j;
    fi;
  end;
  for i in [1 .. max] do
    for j in [1 .. max] do
      Add(out, [List(sample_pair[1], x -> trans(x)),
                List(sample_pair[2], x -> trans(x))]);
    od;
  od;
  return out;
end;
