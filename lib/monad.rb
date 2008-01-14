require 'rubygems'
require 'parse_tree'
require 'sexp_processor'
require 'ruby2ruby'

module Monad
  def run *args, &block
    sexp = transform_sexp(block)
    ruby = generate_ruby(sexp)
    eval(ruby).call(*args)
  end
  
  def transform_sexp block
    DoNotation.new.process(block.to_method.to_sexp)
  end
  
  # gnarly text munging copied & pasted from ruby2ruby source
  def generate_ruby sexp
    ruby = Ruby2Ruby.new.process(sexp)
    ruby.sub!(/\A(def \S+)\(([^\)]*)\)/, '\1 |\2|')     # move args
    ruby.sub!(/\Adef[^\n\|]+/, 'proc { ')               # strip def name
    ruby.sub!(/end\Z/, '}')                             # strip end
    ruby.gsub!(/\s+$/, '')                              # trailing WS bugs me
    ruby
  end
end

class DoNotation < SexpProcessor
  def process_bmethod exp
    type = exp.shift
    
    if arg_assignment = process(exp.shift)
      if arg_assignment.first == :dasgn or arg_assignment.first == :dasgn_curr
        args = [arg_assignment[1]]
      elsif arg_assignment.first == :masgn
        args = arg_assignment[1][1..-1].collect { |e| e[1] }
      else
        raise DoNotationError, "I can't parse this block :("
      end
    else
      args = []
    end
    
    block = process(exp.shift)
    
    assert_type block, :block
    block.shift
    
    s(:scope,
      s(:block,
        s(:args, *args),
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
