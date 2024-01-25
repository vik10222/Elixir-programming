defmodule Tree do

  #Returning nth element:

  #for short list
  def nth_l(1, [r|_]) do r end
  def nth_l(2, [_,r|_]) do r end
  def nth_l(3, [_,_,r]) do r end
  #this only work for a list of three obviously

  def nth_t(1, {r,_,_}) do r end
  def nth_t(2, {_,r,_}) do r end
  def nth_t(3, {_,_,r}) do r end

  #neither of these are very convenient as they only work up to 3 so we shall do a iterative version for a list
  def nth_ll(1, [r|_]) do r end
  def nth_ll(n, [_|t]) do
    nth_ll(n-1,t)
  end


  #moving on to ques
  #adding
  # def add(elm, []) do [elm] end
  # def add(elm, [h|t]) do
  #   [h|add(elm,t)]
  # end

  #removing
  # def remove([]) do :error end
  # def remove([h|t]) do {:ok, h, t}
  # end

  #this is however the slower version instead one should do somthing like this
  def add(elm, {:queue, first, last}) do {:queue, first,[elm|last]} end
  def remove({:queue, [elm|rest], last}) do {:ok, elm, {:queue, rest, last}} end

  def remove({:queue, [], back}) do
    case reverse(back) do
      [] ->
        :fail
      [elem | rest] ->
        {:ok, elem, {:queue, rest, []}}
    end
  end

  def reverse(lst) do reverse(lst, []) end
  def reverse([], rev) do rev end
  def reverse([h|t], rev) do reverse(t, [h|rev]) end

  #Trees here we search for an element in a tree:
  #leaf representation: {:leaf, value}
  #branch node representation: {:node, val, left, right}
  #tree: {:node, val, {:leaf, value}, {:leaf, value}}
  #for unordered trees:
  def member(_, :nil) do :no  end
  def member(n, {:leaf, n}) do :yes end
  def member(_, {:leaf, _}) do :no end
  def member(n,{:node, n, _, _}) do :yes end
  def member(n,{:node, _, left, right}) do
    case member(n,left) do
      :yes -> :yess
      :no -> member(n,right)
    end
 end
  #for ordered trees
  def member(_, :nil) do :no end
  def member(elm, {:leaf, elm}) do :yes end
  def member(_, {:leaf, _}) do :no end
  def member(elm, {:node, elm, _, _}) do :yes end
  def member(elm, {:node, e, left, right}) do
    if elm < e do
      member(elm, left)
    else
      member(elm, right)
    end
  end

  #for an ordered pair tree- basicaly ordered by the key that are letter in alphebetical order
  t = {:node, :k, 38,
              {:node, :b, 34, :nil, :nil},
              {:node, :o, 40,  {:node, :l, 42, :nil, :nil},
                               {:node, :q, 39, :nil, :nil}
                }
              }

  #lookup function for ordered pair tree
  def lookup(_, :nil) do :no end

  def lookup(key, {:node, key, val,_ ,_}) do {:val, val} end
  def lookup(key, {:node, k, _,left, right }) do
    if key <k do
      lookup(left)
    else
      lookup(right)
    end
  end

  #modify based on key funciton
  def modify(_, _, :nil) do :nil end
  def modify(key, val, {:node, key, _ , left , right}) do {:node, key, val, left, right} end
  def modify(key, val, {:node, k, l, r}) do
    if key<k
    {:node, key, val, modify(key,val,l), r}
    else
    {:node, key, val, l, modify(key,val,r)}
  end

  #insert
  def insert(key, val, :nil) do #if we have no tree
    {:node, key, val, :nil, :nil}
  end

  def insert(key, val, {:node, k, v, left, right}) do #if we have tree
    if key<k do
      {:node, k, v, insert(key, val, left), right}
    else
      {:node, k, v, left, insert(key, val, right)}
    end
  end

  #delete
  def delete(key, {:node, key, _, left, :nil}) do left end
  def delete(key, {:node, key, _, :nil, right}) do right end
  def delete(key, {:node, key, _, left, right}) do
    {:node, :notakey, 99, left, right}
  end
  def delete(key, {:node, key, _value, left, right}) do
    {min, right_without_min} = min_value_node(right)
    {:node, min, right_without_min, left}
  end

  def delete(key, {:node, k, v, left, right}) do
    if key < k do
      {:node, k, v, delete(key, left), right}
    else
      {:node, k, v, left, delete(key, right)}
    end
  end

  # Helper function to find the in-order successor
  defp min_value_node({:node, key, :nil, :nil}), do: {key, :nil}
  defp min_value_node({:node, key, _value, left, right}) do
    if left != :nil do
      min_value_node(left)
    else
      {key, right}
    end
  end
end
