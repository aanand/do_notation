module Monad
  module ClassMethods
    def run &block
      DoNotation.run(self, &block)
    end

    def bind_const value, &block
      bind(value) { block.call }
    end

    def compose a, b
      bind_const(a) { b }
    end
  end

  def self.included m
    m.extend ClassMethods
  end
end
