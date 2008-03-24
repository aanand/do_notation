require 'parse_tree'
require 'sexp_processor'

class DoNotation < SexpProcessor
  def process_bmethod exp
    type = exp.shift
    
    exp.shift # throw away arguments
    
    block = process(exp.shift)
    
    assert_type block, :block
    block.shift
    
    s(:scope,
      s(:block,
        s(:args),
        *rewrite_assignments(block)))
  end
  
  def rewrite_assignments exp
    return [] if exp.empty?
    
    head = exp.shift
    
    if head.first == :call and head[1].first == :vcall and head[2] == :< and head[3].first == :array and head[3][1].last == :-@
      var_name = head[1][1]
      expression = head[3][1][1]
      
      body = rewrite_assignments(exp)
      
      if body.first.is_a? Symbol
        body = [s(*body)]
      end
      
      [s(:iter,
         s(:call, process(expression), :bind),
         s(:dasgn_curr, var_name),
         *body)]
    else
      head + rewrite_assignments(exp)
    end
  end
  
  def self.pp(obj, indent='')
    return obj.inspect unless obj.is_a? Array
    return '()' if obj.empty?

    str = '(' + pp(obj.first, indent + ' ')

    if obj.length > 1
      str << ' '

      next_indent = indent + (' ' * str.length)

      str << obj[1..-1].map{ |o| pp(o, next_indent) }.join("\n#{next_indent}")
    end

    str << ')'

    str
  end
end

class DoNotationError < StandardError; end
