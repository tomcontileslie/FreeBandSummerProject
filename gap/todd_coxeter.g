# This function takes a coset index and a word, and moves the coset index
# through the word.




ToddCoxeter := function(A, R)
  local tau, new_coset, push_relation, process_coincidences,
  coincidences, i, j, k, active_cosets, table, char, pair, n,
  word, coset;

  tau := function(coset, word)
    local char;
    Print("Calling tau. coset: ", coset, "  word: ", word, "\n");
    if not IsList(word) then
      # We want to be able to ask for things like tau(1, 1), without needing
      # to type tau(1, [1]).
      word := [word];
    fi;
    if Length(word) = 0 then
      # Applying the empty word to a coset does nothing.
      return coset;
    fi;
    for char in word do
      # We find where the first character of word takes coset, if this is even
      # defined yet. If it is not defined (i.e. zero), then we return zero,
      # indicating that the word's action on coset is not yet entirely defined.
      # If the first character's action on coset is defined, then we apply the
      # same process again, with the word from the second character on playing
      # the 'new role' of word, and the image of coset under the original word's
      # first character as the new coset. And repeat.
      coset := table[coset][char];
      if coset = 0 then
        return 0;
      fi;
    od;
    # If it's defined, then return where coset ultimately ends up.
    return coset;
  end;

  new_coset := function(coset, char)
    Print("Calling new_coset \n");
    if tau(coset, char) = 0 then
      Print("The action of ", char, " on ", coset, " is undefined. Defining ");
      Print("it to be ", k, "\n");
      table[coset][char] := k;
      Add(active_cosets, k);
      Add(table, ListWithIdenticalEntries(Length(A), 0));
      k := k + 1;
    fi;
    # If the action of generator char on coset is not defined, then this defines
    # it to be the lowest available number k, adds a new row to the table
    # corresponding to this number, and increments k by one.
  end;

  push_relation := function(coset, u, v)
    local u_1, v_1, a, b;
    u_1 := [];
    v_1 := [];
    a   := [];
    b   := [];
    if Length(u) > 0 then
      u_1 := u{[1 .. Length(u) - 1]};
      a   := u[Length(u)];
    fi;
    if Length(v) > 0 then
      v_1 := v{[1 .. Length(v) - 1]};
      b   := v[Length(v)];
    fi;
    # The above splits u and v into their final characters, and first pieces. If
    # u or v is empty, then their corresponding pieces are empty.

    # TODO: Could this be improved by storing the taus as local variables?
    if (tau(coset, u) = 0 and tau(coset, v) <> 0 and tau(coset, u_1) <> 0) then
      # The action of u on coset is undefined, yet the action of u_1 is. This
      # means that the very last letter of u is 'letting the side down'. Since
      # u = u_1 a, it is the action of a on the action of u_1 on coset which
      # is not defined. Since the action of v on coset is defined, and this
      # is equal to the action of u on coset, we conclude that the action of
      # a on the action of u_1 on coset is equal to the action of v on coset.
      # In other words, table[tau(coset, u_1)][a] := tau(coset, v).
      table[tau(coset, u_1)][a] := tau(coset, v);
      Print("Pushing the relation updated the table \n");
    elif (tau(coset, v) = 0 and tau(coset, u) <> 0
          and tau(coset, v_1) <> 0) then
      # This is the exact dual of the above scenario with u <-> v, u_1 <-> v_1
      # and a <-> b.
      table[tau(coset, v_1)][b] := tau(coset, u);
      Print("Pushing the relation updated the table \n");
    elif (tau(coset, u) <> 0 and tau(coset, v) <> 0
        and tau(coset, u) <> tau(coset, v)) then
      # In this case, the actions of u and v on coset are both defined, yet not
      # equal. However, since u = v is one of our relations, u and v should have
      # equal actions on every coset, and so we need these cosets representing the
      # actions of u and v to be equal. We add this equality to our list of
      # coincidences to be processed.
      Add(coincidences, [tau(coset, u), tau(coset, v)]);
      Print("Pushing the relation added a coincidence \n");
    fi;
    # TODO: Add a suitable comment here, I think saying something like 'if none
    # of the above conditions are met, then we've learnt nothing new from applying
    # this relation to this coset.

    # TODO: What if the actions of u and v on coset are undefined, but so are
    # the actions of u_1 and v_1 on coset? What do we do then? Ought we to
    # consider these cases? Perhaps this will be clear to me after I read the
    # rest of the code, though.

    # TODO: Isn't it computationally wasteful to be computing the actions of
    # u and u_1 separetely? To apply u to coset, we simply apply u_1 and then
    # apply a, so we could save some computation here. The same applies to v
    # and v_1.
  end;

  process_coincidences := function()
    local coset, pair;
    if Length(coincidences) = 0 then
      return;
    fi;
    while Length(coincidences) <> 0 do
      i := Minimum(coincidences[1]);
      j := Maximum(coincidences[1]);
      if i = j then
        break;
      fi;
      # i and j are the cosets of the coincidence we are processing. If i = j
      # already, then there is nothing to do.

      for char in A do
        if tau(j, char) <> 0 then
          if tau(i, char) = 0 then
            # Here, the action of generator char on j is defined, and on i is not
            # defined. Since we are here 'making' i = j, char should have the
            # same action on both i and j. We therefore define the action of
            # char on i to be the action of char on j.
            table[i][char] := tau(j, char);
          elif tau(i, char) <> 0 then
            # Here, the action of char on both i and j is defined. Since i and j
            # are here being 'made' equal, the actions of char on i and j should
            # be equal too. So, we add [tau(i, char), tau(j, char)] as another
            # coincidence.
            Add(coincidences, [tau(i, char), tau(j, char)]);
          fi;
        fi;
      od;
      # The effect of the above is basically making the rows of i and j in the
      # table equal. Now, we need to work through the table and replace every
      # instance of j (the larger of the two) with i.
      for coset in active_cosets do
        for char in A do
          if tau(coset, char) = j then
            # If the action of generator char on coset is j, then we replace
            # it with i.
            # Recall that tau(coset, char) is exactly table[coset][char].
            table[coset][char] := i;
          fi;
        od;
      od;
      # We have now replaced j -> i, and added all the new coincidences we
      # got by considering the actions of generators on i and j. However,
      # there may still be some references to j in the list of coincidences
      # waiting to be processed. We must change these to i.
      for pair in coincidences do
        if pair[1] = j then
          pair[1] := i;
        elif pair[2] = j then
          pair[2] := i;
        fi;
      od;
      # To finish processing the coincidence, we delete j from our list of
      # active cosets. We then delete the coincidence from our list.
      Remove(active_cosets, Position(active_cosets, j));
      # TODO: This could perhaps be improved by having a separete list
      # keep track of the indices of cosets in the list active_cosets.
      Remove(coincidences, 1);
    od;
  end;


  k             := 2;
  active_cosets := [1];
  table         := [[]];
  coincidences  := [];
  for char in A do
    table[1][char] := 0;
  od;
  n := 0;
  repeat
    n := n + 1;
    Print("Current coset (n): ", n, "\n");
    if n in active_cosets then
      # Only do anything if the current coset is active.
      for char in A do
        new_coset(n, char);
        for coset in active_cosets do
          for pair in R do
            Print("Pushing relation ", pair, " on ", n, "\n");
            push_relation(coset, pair[1], pair[2]);
          od;
        od;
      od;
    fi;
    Print("Processing coincidences \n");
    process_coincidences();
    Print("\n \n");
  until n = k;  # When we have reached the end of our active cosets, stop.
  for pair in R do
    if Length(pair[1]) = 0 or Length(pair[2]) = 0 then
      return Length(active_cosets);
    fi;
  od;
  return Length(active_cosets) - 1;
end;

