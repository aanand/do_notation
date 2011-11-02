class DoNotation::Rewriter
  def process exp
    # puts "exp = #{exp.inspect}"

    raise ArgumentError, "expected :iter, got #{exp[0].inspect}"                             unless exp[0] == :iter
    raise ArgumentError, "expected s(:call, nil, :proc, s(:arglist)), got #{exp[1].inspect}" unless exp[1] == s(:call, nil, :proc, s(:arglist))
    raise ArgumentError, "expected nil, got #{exp[2].inspect}"                               unless exp[2] == nil

    if exp[3].is_a?(Sexp) and exp[3][0] == :block
      iter, call, nil_val, block = exp.shift, exp.shift, exp.shift, exp.shift
      raise ArgumentError, "unexpected extra syntax: #{exp.inspect}" unless exp.empty?
      s(iter, call, nil_val, *rewrite_assignments(block[1..-1]))
    else
      exp
    end
  end

  def rewrite_assignments exp
    return [] if exp.empty?
  
    head = exp.shift
    # puts "head = #{head.inspect}"
  
    if head[0] == :call and head[1] and head[1][0] == :call and head[2] == :< and head[3][0] == :arglist and head[3][1][2] == :-@
      var_name = head[1][2]
      expression = head[3][1][1]

      # puts "var_name = #{var_name.inspect}"
      # puts "expression = #{expression.inspect}"
    
      body = rewrite_assignments(exp)
    
      if body.first.is_a? Symbol
        body = [s(*body)]
      end
    
      [s(:iter,
         s(:call, expression, :bind, s(:arglist)),
         s(:lasgn, var_name),
         *body)]
    elsif exp.empty?
      [head]
    else
      [s(:iter, s(:call, process(head)  , :bind_const), nil , 
             *rewrite_assignments(exp)) ]
    end
  end
end
