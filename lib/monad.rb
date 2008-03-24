require 'ruby2ruby'

module Monad
  def run &block
    eval(ruby_for(block), block).call
  end
  
  def ruby_for block
    @cached_ruby ||= {}
    @cached_ruby[block.to_s] ||= "#{self.name}.instance_eval { #{generate_ruby(transform_sexp(block))} }"
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
