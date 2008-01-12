require 'rubygems'
require 'parse_tree'
require 'sexp_processor'
require 'ruby2ruby'

class Monad
  class << self
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
end

class DoNotation < SexpProcessor
  def process_bmethod exp
    type = exp.shift
    
    arg_assignment = process(exp.shift)
    
    if arg_assignment.first == :dasgn_curr
      arg_name = arg_assignment[1]
      args = []
    elsif arg_assignment.first == :masgn
      arg_name = arg_assignment[1][1][1]
      args = arg_assignment[1][2..-1].collect { |e| e[1] }
    else
      raise DoNotationError, "I can't parse this block :("
    end
    
    block = process(exp.shift)
    
    assert_type block, :block
    block.shift
    
    s(:scope,
      s(:block,
        s(:args, *args),
        *rewrite_assignments(block, arg_name)))
  end
  
  def rewrite_assignments exp, arg_name
    return [] if exp.empty?
    
    head = exp.shift
    
    if head[0] == :dasgn_curr and head[2][0] == :fcall and head[2][1] == arg_name
      var_name = head[1]
      expression = head[2][2][1]
      
      body = rewrite_assignments(exp, arg_name)
      
      if body.first.is_a? Symbol
        body = [s(*body)]
      end
      
      [s(:iter,
        s(:call, process(expression), :bind),
        s(:dasgn_curr, var_name),
        *body)]
    else
      head + rewrite_assignments(exp, arg_name)
    end
  end
end

class DoNotationError < StandardError; end
