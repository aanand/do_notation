module Monad
  module ClassMethods
    def run &block
      eval(ruby_for(block), block).call
    end

    def ruby_for block
      @cached_ruby ||= {}
      @cached_ruby[block.to_s] ||= "#{self.name}.instance_eval { #{Ruby2Ruby.new.process(Rewriter.new.process(block.to_method.to_sexp)[2])} }"
    end
  end

  def bind_const &block
    bind { |_| block.call() }
  end

  def >> n
    bind_const { n }
  end

  def self.included m
    m.extend ClassMethods
  end
end
