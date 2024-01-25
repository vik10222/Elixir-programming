defmodule Deriv do
  @type literal() :: {:num, number()}
  | {:var, atom()}

  @type expr() :: {:add, expr(), expr()}
  | {:mul, expr(), expr()}
  | {:exp, expr(), literal()}
  | literal()

  def deriv({:num, _}, _) do {:num, 0} end
  def deriv({:var, v}, v) do {:num, 1} end
  def deriv({:var, _}, _) do {:num, 0} end
  def deriv({:add, e1, e2}, v) do
    {:add, deriv(e1,v), deriv(e2,v)}
  end
  def deriv({:mul, e1, e2}, v) do
    {:add,
    {:mul, deriv(e1,v), e2},
    {:mul, e1, deriv(e2,v)}  }
  end
  def deriv({:exp, e1, {:num, n}}, v) do
    {:mul,
    {:mul, {:num, n}, {:exp, e1, {:num, n-1}}},
    deriv(e1,v)
  }
  end


  def calc({:num, n}, _, _) do {:num, n} end
  def calc({:var, v}, v, n) do {:num, n} end
  def calc({:var, v}, _, _) do {:var, v} end
  def calc({:add, e1, e2}, v, n) do
    {:add, calc(e1, v, n), calc(e2, v, n)}
  end

  def calc({:mul, e1, e2}, v, n) do
    {:mul, calc(e1, v, n), calc(e2, v, n)}
  end

  def calc({:exp, e, {:num, n}}, v, c) do
    {:exp, calc(e, v, c), {:num, n}}
  end

  def simplify({:num, n}) do {:num, n} end
  def simplify({:var, v}) do {:var, v} end
  def simplify({:add, e1, e2}) do simplify_add(simplify(e1), simplify(e2)) end
  def simplify({:mul, e1, e2}) do simplify_mul(simplify(e1), simplify(e2)) end
  def simplify({:exp, e1, e2}) do simplify_exp(simplify(e1), simplify(e2)) end

  def simplify_add({:num, 0}, e2) do e2 end
  def simplify_add(e1, {:num, 0}) do e1 end
  def simplify_add({:num, n1}, {:num, n2}) do {:num, n1+n2} end
  def simplify_add(e1, e2) do {:add, e1, e2} end

  def simplify_mul({:num, 0}, _) do {:num, 0} end
  def simplify_mul(_, {:num, 0}) do {:num, 0} end
  def simplify_mul({:num, 1}, e2) do e2 end
  def simplify_mul(e1, {:num, 1}) do e1 end
  def simplify_mul({:num, n1}, {:num, n2}) do {:num, n1*n2} end
  def simplify_mul({:mul, {:num, n1}, {:mul, {:num, n2}, e2}}) do
    {:mul, {:num, n1 * n2}, e2}
  end

  def simplify_mul({:num, n1}, {:mul, e1, {:num, n2}}) do
    {:mul, {:num, n1 * n2}, e1}
  end

  def simplify_mul({:mul, {:num, n2}, e2}, {:num, n1}) do
    {:mul, {:num, n1 * n2}, e2}
  end

  def simplify_mul({:mul, e1, {:num, n2}}, {:num, n1}) do
    {:mul, {:num, n1 * n2}, e1}
  end
  def simplify_mul(e1, e2) do {:mul, e1, e2} end

  def simplify_exp(_, {:num, 0}) do {:num, 1} end
  def simplify_exp(e1, {:num, 1}) do e1 end
  def simplify_exp({:num, 0}, _) do {:num, 0} end
  def simplify_exp({:num, 1}, _) do {:num, 1} end
  def simplify_exp({:num, n1}, {:num, n2}) do {:num, :math.pow(n1, n2)} end
  def simplify_exp(e1, e2) do {:exp, e1, e2} end

  def pprint({:num,n}) do "#{n}"end
  def pprint({:var,v}) do "#{v}" end
  def pprint({:add,e1, e2}) do "(#{pprint(e1)}+#{pprint(e2)})" end
  def pprint({:mul,e1, e2}) do "(#{pprint(e1)}*#{pprint(e2)})" end
  def pprint({:exp,e1, e2}) do "(#{pprint(e1)}^(#{pprint(e2)}))" end


  def test1() do
    e = {:add, {:mul, {:num, 2}, {:var, :x}}, {:num, 4}}
    d=deriv(e, :x)
    c = calc(d, :x, 5)
    s=simplify(c)
    #pprint(s)
    IO.write("expression:#{pprint(e)}\n")
    IO.write("derivative:#{pprint(d)}\n")
    IO.write("calculated:#{pprint(c)}\n")
    IO.write("answer:#{pprint(s)}\n")

  end

  def test2() do
    e = {:add, {:mul, {:num, 2}, {:mul, {:var, :x}, {:var, :x}}}, {:add, {:mul, {:num, 4}, {:var, :x}}, {:num, 5}}}
    d = deriv(e, :x)
    s= simplify(d)

    pprint(s)
  end

  def test3() do
    e = {:add, {:mul, {:num, 2}, {:exp, {:var, :x}, {:num, 2}}}, {:add, {:mul, {:num, 4}, {:var, :x}}, {:num, 5}}}
    d = deriv(e, :x)
    c = calc(d, :x, 4)
    s= simplify(c)
    IO.write("expression:#{pprint(e)}\n")
    IO.write("derivative:#{pprint(d)}\n")
    IO.write("calculated:#{pprint(c)}\n")
    IO.write("answer:#{pprint(s)}\n")
    pprint(s)
  end



end
