ToddCoxeter := function(N, R)
  local tau, new_coset, push_relation, process_coincidences,
  coincidences, i, j, k, active_cosets, table, char, pair, n,
  word, coset, A;

  tau := function(coset, word)
    local char;
    # Print("Calling tau. coset: ", coset, "  word: ", word, "\n");
    if not IsList(word) then
      word := [word];
    fi;
    if Length(word) = 0 then
      return coset;
    fi;
    for char in word do
      coset := table[coset][char];
      if coset = 0 then
        return 0;
      fi;
    od;
    return coset;
  end;

  new_coset := function(coset, char)
    # Print("Calling new_coset \n");
    if tau(coset, char) = 0 then
      # Print("The action of ", char, " on ", coset, " is undefined. Defining ");
      # Print("it to be ", k, "\n");
      table[coset][char] := k;
      active_cosets[k]   := true;
      Add(table, ListWithIdenticalEntries(Length(A), 0));
      k := k + 1;
    fi;
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
    if (tau(coset, u) = 0 and tau(coset, v) <> 0 and tau(coset, u_1) <> 0) then
      words, table[tau(coset, u_1)][a] := tau(coset, v).
      table[tau(coset, u_1)][a]        := tau(coset, v);
      # Print("Pushing the relation updated the table \n");
    elif (tau(coset, v) = 0 and tau(coset, u) <> 0
          and tau(coset, v_1) <> 0) then
      table[tau(coset, v_1)][b] := tau(coset, u);
      # Print("Pushing the relation updated the table \n");
    elif (tau(coset, u) <> 0 and tau(coset, v) <> 0
        and tau(coset, u) <> tau(coset, v)) then
      Add(coincidences, [tau(coset, u), tau(coset, v)]);
      # Print("Pushing the relation added a coincidence \n");
    fi;
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
      for char in A do
        if tau(j, char) <> 0 then
          if tau(i, char) = 0 then
            table[i][char] := tau(j, char);
          elif tau(i, char) <> 0 then
            Add(coincidences, [tau(i, char), tau(j, char)]);
          fi;
        fi;
      od;
      for coset in ListBlist([1 .. k - 1], active_cosets) do
        for char in A do
          if tau(coset, char) = j then
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
      Remove(coincidences, 1);
    od;
  end;

  A             := [1 .. N];
  k             := 2;
  active_cosets := [true];
  table         := [[]];
  coincidences  := [];
  for char in A do
    table[1][char] := 0;
  od;
  n := 0;
  repeat
    n := n + 1;
    # Print("Current coset (n): ", n, "\n");
    if active_cosets[n] then
      for char in A do
        new_coset(n, char);
        for coset in ListBlist([1 .. k - 1], active_cosets) do
          for pair in R do
            # Print("Pushing relation ", pair, " on ", n, "\n");
            push_relation(coset, pair[1], pair[2]);
          od;
        od;
      od;
    fi;
    # Print("Processing coincidences \n");
    process_coincidences();
    # Print("\n \n");
  until n = k - 1;  # When we have reached the end of our active cosets, stop.
  for pair in R do
    if Length(pair[1]) = 0 or Length(pair[2]) = 0 then
      return Length(ListBlist([1 .. k - 1], active_cosets));
    fi;
  od;
  return Length(ListBlist([1 .. k - 1], active_cosets)) - 1;
end;

