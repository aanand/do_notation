# Haskell-style monad do-notation for Ruby
#
# By Aanand Prasad (aanand.prasad@gmail.com)
#
# A first attempt, nervous and shaky. It is liable
# to drop its cigarette in fear if you look it
# too closely in the eye.
#
# Its biggest failing, and I don't see a way
# out, is that you don't get lexical scope. ParseTree
# is wonderful, but it can't work miracles.
#
# You can work around it, though, by passing in
# stuff from the outside as arguments to `run',
# and specifying those arguments on the block
# you pass in as well.
#
# Examples at the bottom.

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

class Maybe < Monad
  class << self
    alias_method :nothing, :new
    alias_method :just, :new
    alias_method :unit, :just
  end
  
  attr_accessor :value, :nothing
  
  def initialize *args
    if args.empty?
      @nothing = true
    else
      @value = args.shift
    end
  end
    
  def bind &f
    if self.nothing
      self
    else
      f.call(self.value)
    end
  end
  
  def to_s
    if @nothing
      "nothing"
    else
      "just(#{@value})"
    end
  end
end

class List < Monad
  class << self
    alias_method :list, :new
    alias_method :unit, :list
  end
  
  attr_accessor :array
  
  def initialize *args
    @array = args
  end
  
  def bind &f
    lists = @array.map{ |x| f.call(x) }
    
    List.unit(*lists.inject([]) { |acc, l| acc + l.array })
  end
  
  def to_s
    @array.inspect
  end
end

# evaluates to nothing
maybe = Maybe.run do |m|
  x =m just(1)
  y =m nothing
  
  unit(x+y)
end

puts maybe

# evaluates to just(3)
maybe = Maybe.run do |m|
  x =m just(1)
  y =m just(2)
  
  unit(x+y)
end

puts maybe

# evaluates to [11, 21, 31, 12, 22, 32, 13, 23, 33]
list = List.run do |m|
  x =m list(1,2,3)
  y =m list(10,20,30)

  unit(x+y)
end

puts list

# evaluates to [111, 121, 131, 112, 122, 132, 113, 123, 133]
foo = 100

list = List.run(foo) do |m, foo|
  x =m list(1,2,3)
  y =m list(10,20,30)

  unit(x+y+foo)
end

puts list
