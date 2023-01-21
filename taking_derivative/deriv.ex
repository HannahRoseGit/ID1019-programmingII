defmodule Derivative do
    # Declaring two main literals 
    @type literal() :: {:num, number()} | {:var, atom()}

    # Declaring the expr types
    @type expr() :: {:add, expr(), expr()} | {:mul, expr(), expr()} | literal() | {:sub, expr(), expr()} | {:frac, expr(), expr()} |
                    {:div, expr(), expr()} | {:sqrt, expr()} | {:pow, expr(), expr()} | {:sin, expr()} | {:cos, expr()} | {:ln, expr()}

    @spec deriv(expr(), atom()) :: expr()

    # the derivation equations in this assignment were written based on the derivation rules in the book "Calculus - a complete course" 9th edition, 
    # by writers Robert A. Adams and Christopher Essex.

    # 1. derivative of a constant function = 0
    def deriv({:num,_},_) do {:num, 0} end

    # 2. derivation of a variable with no coefficient 
    def deriv({:var,x},x) do {:num, 1} end

    # 3. derivation of a variable by another variable 
    def deriv({:var,x},_) do {:var,x} end

    # 4. derivation general power rule 
    def deriv({:pow, e1, {:num, n}}, e1) do {:mul, {:num, n}, {:pow, e1, {:num, n-1}}} end

    # 5. derivattion of squar root
    def deriv({:sqrt, e1}, x) do {:frac, deriv(e1,x), {:mul, {:num, 2}, {:sqrt, e1}}} end

    # 6. derivattion of Ln
    def deriv({:ln, x}, x) do {:frac, {:num, 1}, x} end

    # 7. derivattion of multiplication 
    def deriv({:mul, e1, e2}, x) do {:add, {:mul, deriv(e1,x), e2}, {:mul, e1, deriv(e2,x)}} end 

    # 8. derivattion of addition 
    def deriv({:add, e1, e2}, x) do {:add, deriv(e1,x), deriv(e2,x)} end 

    # 9. derivattion of trigonometery 
    def deriv({:sin, e1}, x) do {:mul, deriv(e1,x), {:cos, e1}} end
    def deriv({:cos, e1}, x) do {:mul, {:num, -1}, {:mul, {deriv(e1,x), {:sin, e1}}}} end 

    # 10. derivation of fraction 
    def deriv({:frac, e1, e2}, x) do {:frac, {:sub, {:mul, deriv(e1,x), e2}, {:mul, deriv(e2, x), e1}}, {:pow, e2, 2}} end

    def test() do
        test = {:sin, {:mul, {:num, 2}, {:var, :x}}}
        IO.puts(str_mkr(test))
        IO.puts(str_mkr(Derivative.deriv(test,1)))   
    end

    

    # functions to make a string out of our expressions 
    def str_mkr({:num, n}) do 
        "#{n}" 
    end

    def str_mkr({:var, v}) do 
        "#{v}" 
    end

    def str_mkr({:add, e1, e2}) do
        "#{str_mkr(e1)} + #{str_mkr(e2)}"
    end

    def str_mkr({:mul, e1, e2}) do
       "( #{str_mkr(e1)} * #{str_mkr(e2)} )"
    end  

    def str_mkr({:pow, e1, e2}) do
       "#{str_mkr(e1)}^#{str_mkr(e2)}"
    end

    def str_mkr({:sin, e1}) do
        "sin( #{str_mkr(e1)} )"
    end

    def str_mkr({:cos, e1}) do
        "cos( #{str_mkr(e1)} )"
    end
    
    #simplification 
    def simp({:num, n}) do {:num, n} end 
    def simp({:var, :x}) do {:var, :x} end 

    #addition
    def simp({:add, e1, e2}) do simp_add(simp(e1), simp(e2)) end
    def simp_add(e1, {:num, 0}) do e1 end
    def simp_add({:num, 0}, e1) do e1 end  
    def simp_add({:num, n1}, {:num, n2}) do {:num, n1+n2} end
    def simp_add({:var, v}, {:var, v}) do {:mul, {:num, 2}, {:var, v}} end

    #multiplication
    def simp({:mul, e1, e2})  do simp_mul(simp(e1), simp(e2)) end
    def simp_mul(_, {:num,0}) do {:num, 0} end
    def simp_mul({:num, 0}, _) do {:num, 0} end
    def simp_mul(e1, {:num,1}) do e1 end
    def simp_mul({:num, 1}, e1) do e1 end
    #def simp_mul(simp(e1), simp(e2)) do {:mul, e1*e2} end

end

Derivative.test()
IO.puts("Please be proud of yourself")

