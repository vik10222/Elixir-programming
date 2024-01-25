defmodule EnvTree do
#   _______   ______   .______         .___________..______       _______  _______
#  |   ____| /  __  \  |   _  \        |           ||   _  \     |   ____||   ____|
#  |  |__   |  |  |  | |  |_)  |       `---|  |----`|  |_)  |    |  |__   |  |__
#  |   __|  |  |  |  | |      /            |  |     |      /     |   __|  |   __|
#  |  |     |  `--'  | |  |\  \----.       |  |     |  |\  \----.|  |____ |  |____
#  |__|      \______/  | _| `._____|       |__|     | _| `._____||_______||_______|




  def new(), do: :nil

  #lookup function for ordered pair tree
  def lookup(_, nil) do :no end
  def lookup(nil,_) do end
  def lookup(key, {:node, key, val,_ ,_}) do {:val, val} end
  def lookup(key, {:node, k, _,left, right }) do
    if key <k do
      lookup(key, left)
    else
      lookup(key, right)
    end
  end

  #modify based on key funciton
  def modify(_, _, nil) do nil end
  def modify(key, val, {:node, key, _ , left , right}) do {:node, key, val, left, right} end
  def modify(key, val, {:node, k, v, l, r}) do
    if key<k do
      {:node, k, v, modify(key,val,l), r}
    else
      {:node, k, v, l, modify(key,val,r)}
    end
  end

  #add
  def add(key, val, nil) do #if we have no tree
    {:node, key, val, nil, nil}
  end

  def add(nil, _, _) do #if we have no tree

  end
  def add(key, val, {:node, k, v, left, right}) do #if we have tree
    if key<k do
      {:node, k, v, add(key, val, left), right}
    else
      {:node, k, v, left, add(key, val, right)}
    end
  end

  #remove
  def remove(nil, _) do  end
  def remove(key, {:node, key, _, left, nil}) do left end
  def remove(key, {:node, key, _, nil, right}) do right end
  def remove(key, {:node, key, _value, left, right}) do
    {min, right_without_min} = min_value_node(right)
    {:node, min, right_without_min, left}
  end

  def remove(key, {:node, k, v, left, right}) do
    if key < k do
      {:node, k, v, remove(key, left), right}
    else
      {:node, k, v, left, remove(key, right)}
    end
  end

  # Helper function to find the in-order successor
  defp min_value_node({:node, key, nil, nil}), do: {key, nil}
  defp min_value_node({:node, key, _value, left, right}) do
    if left != nil do
      min_value_node(left)
    else
      {key, right}
    end
  end




end
