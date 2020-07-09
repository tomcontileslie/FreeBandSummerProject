# Read("freeband.g");

BandPrefix := function(word, distinct)
  local lookup, distinctf, L, out, i;
  # returns a tuple with reduced prefix and last to appear first.
  # TODO: DANGER: Not well foolproofed, depends on very sensible input.
  lookup          := [];
  lookup[word[1]] := 1;
  distinctf       := 1;  # distinct found
  L               := Length(word);
  for i in [2 .. L] do
    if not IsBound(lookup[word[i]]) then
      distinctf := distinctf + 1;
      if distinctf = distinct then
        out := SL_Canon(word{[1 .. i - 1]});
        Add(out, word[i]);
        return out;
      fi;
      lookup[word[i]] := distinct;
    fi;
  od;
end;

BandChop := function(pref, suff)
  local n1, n2, n, i;
  # cancels as much as possible.
  n1 := Length(pref);
  n2 := Length(suff);
  n  := Minimum(n1, n2);
  for i in [0 .. n - 1] do
    if pref{[n1 - n + i + 1 .. n1]} = suff{[1 .. n - i]} then
      # if we're at the end (all of suff chopped) then stop
      if n - i = n2 then
        return pref;
      fi;

      # otherwise, attempt to chop more
      return BandChop(pref, suff{[n - i + 1 .. n2]});
    fi;
  od;
  # no chops possible, return
  return Concatenation(pref, suff);
end;

SL_Canon := function(word)
  local L, lookup, distinct, l1, l2, pref, suff, i, char;
  # Shortlex canon. Experimental for now. Returns shortlex least rep.
  L := Length(word);
  if L = 0 then
    return [];
  elif L = 1 then
    return word;
  fi;

  # first we need size of the alph. Re-use stuff from ListOfPos...
  lookup          := [];
  lookup[word[1]] := 1;
  distinct        := 1;

  for i in [2 .. L] do
    if not IsBound(lookup[word[i]]) then
      distinct        := distinct + 1;
      lookup[word[i]] := distinct;
    fi;
  od;

  if distinct = 1 then
    # only one letter. Delete copies.
    return [word[1]];
  fi;

  if distinct = 2 then
    # then only the first and last letters matter. Need to know what letters
    # are in.
    if word[1] <> word[L] then
      return [word[1], word[L]];
    fi;
    # otherwise the first and last are same. Need to know middle.
    l1 := word[1];
    for char in word do
      if char <> l1 then
        l2 := char;
        return [l1, l2, l1];
      fi;
    od;
  fi;

  # If we've made it this far then the content is at least of size 3.
  # Need to find prefix and suffix.
  pref := BandPrefix(word, distinct);
  suff := Reversed(BandPrefix(Reversed(word), distinct));

  # now cancel as much as possible.
  return BandChop(pref, suff);
end;

ToddCoxeterBand := function(N, R)
  local new_coset, tauf, canon, push_relation, process_coincidences,
  A, F, G, k, active_cosets, table, coincidences, words, n, word,
  pair, char, coset, i, tau;

  new_coset := function(coset, char)
    local new_word, target, cosetm, charm, pword;
    # new_coset for bands is smart. If the word created, once reduced,
    # is already somewhere else in the list, then it just sets
    # table[coset][char] to be that coset.
    # TODO change the above comment.
    if table[coset][char] = 0 then
      new_word := canon(Concatenation(words[coset], [char]));
      target   := tau(1, new_word);

      if target = 0 then
        # in this case following new_word from empty word does not lead us the
        # full way and we need to define more cosets.
        # Need to follow word again to see how far we got before undefined.
        cosetm := 1;
        pword  := [];  # partial word, add letters to it each time
        for charm in new_word do
          # extend partial word
          Add(pword, charm);
          if table[cosetm][charm] = 0 then
            # edge is undefined, define a new one.
            table[cosetm][charm] := k;
            active_cosets[k]     := true;
            Add(table, ListWithIdenticalEntries(Length(A), 0));
            Add(words, canon(pword));
            # we need to re-canonicalise pword at the moment because canon does
            # not always output the shortlex-least word.
            k := k + 1;
          fi;
          cosetm := table[cosetm][charm];
        od;

        # now we've defined all the intermediate words, get the original
        # request to point in the right place.
        table[coset][char] := k - 1;  # k had been incremented 1 too many

      else
        # in this case following new_word led us somewhere and we should
        # point there
        table[coset][char] := target;
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

  tau := function(coset, word)
    local char;
    # non-forced tau, checks whether you can get the whole way.
    if Length(word) = 0 then
      return coset;
    fi;
    for char in word do
      if table[coset][char] = 0 then
        return 0;
      fi;
      coset := table[coset][char];
    od;
    return coset;
  end;

  canon := function(word)
    # TODO: this calls a function defined further up as a replacement for the
    # previous version of canon.
    # expresses a word in free band-canonical form.
    return SL_Canon(word);
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
    # changed to depth-first.
    local i, j, char, coset, pair, current, counter;
    if Length(coincidences) = 0 then
      return;
    fi;
    while Length(coincidences) <> 0 do
      # current := Length(coincidences);
      current := 1;
      i       := Minimum(coincidences[current]);
      j       := Maximum(coincidences[current]);
      if i = j then
      fi;
      counter := 0;
      if i <> j then
        for char in A do
          if table[j][char] <> 0 then
            if table[i][char] = 0 then
              table[i][char] := table[j][char];
            elif table[i][char] <> 0 then
              counter := counter + 1;
              Add(coincidences, [table[i][char], table[j][char]]);
            fi;
          fi;
        od;
        # for coset in ListBlist([1 .. k - 1], active_cosets) do
        for coset in [1 .. k - 1] do
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
      Remove(coincidences, current);
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

      # push the current coset through every known implicit relation
      for word in words do
        pair := [Concatenation(word, word), word];
        push_relation(n, pair[1], pair[2]);  # word is already canonical
      od;

      # push every previous coset through the current implicit relation
      word := words[n];
      pair := [Concatenation(word, word), word];
      for i in ListBlist([1 .. n - 1], active_cosets{[1 .. n - 1]}) do
        push_relation(i, pair[1], pair[2]);
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
