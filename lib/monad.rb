require 'rubygems'
require 'ruby2ruby'

require File.join(File.dirname(__FILE__), 'do_notation')

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
