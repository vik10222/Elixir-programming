defmodule AppendList do
  def append([],y) do y end
  def append([h|t],y) do
  z = append(t,y)
  IO.inspect(z)
  [h|z]

  end

  def tailr([],y) do y end
  def tailr([h|t], y) do
    w =tailr(t,[h|y])
    IO.inspect(w)
  end

  def odd([]) do [] end
  def odd([h|t]) do
    if rem(h, 2) == 1 do
      [h|odd(t)]
    else
      odd(t)
    end
  end

  def even([]) do [] end
  def even([h|t]) do
    if rem(h,2) == 0 do
      [h|even(t)]
    else
      even(t)
    end
  end

  def even_n_odd([]) do {[],[]} end
  def even_n_odd([h|t]) do
    {e, o} = even_n_odd(t)
    if rem(h,2) == 1 do
      {e, [h|o]}
    else
      {[h|e], o}
    end
   end



  def rev(l) do rev(l, []) end
  def rev([], res) do res end
  def rev([h | t], res) do
    rev(t, [h | res])
  end




  def run do
    a = [1, 2]
    b = [3, 4]
    # c = append(a, b)
    c = tailr(a, b)
    IO.inspect(c)
  end


end
