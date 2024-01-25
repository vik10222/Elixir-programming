defmodule EnvList do
#   _______   ______   .______          __       __       _______..___________.
#  |   ____| /  __  \  |   _  \        |  |     |  |     /       ||           |
#  |  |__   |  |  |  | |  |_)  |       |  |     |  |    |   (----``---|  |----`
#  |   __|  |  |  |  | |      /        |  |     |  |     \   \        |  |
#  |  |     |  `--'  | |  |\  \----.   |  `----.|  | .----)   |       |  |
#  |__|      \______/  | _| `._____|   |_______||__| |_______/        |__|


  #new
  def new() do [] end

  #add add(map, key, val)
  def add([], key, value) do [{key, value}] end
  def add([{k, v} | map], key, value) do
    if k == key do
      [{key, value} | map]
    else
      [{k, v}|add(map, key ,value)]
    end
  end


  #lookup
  def lookup([], key) do [] end
  def lookup([{k,v}|map], key) do
    if k == key do
      {k, v}
    else
      [{k, v}|lookup(map, key)]
    end
  end

  #remove

  def remove(_, []), do: []
  def remove(key,[]) do :nil end
  def remove(key, [{k,v}|map]) do
    if k == key do
      map
    else
      [{k,v}|remove(key,map)]
    end
  end
  def remove([{k,v}|map], key) do
    if k == key do
      map
    else
      [{k,v}|remove(key,map)]
    end
  end

end
