module Monad
  module ClassMethods
    def run &block
      DoNotation.run(self, &block)
    end

    def bind_const value, &block
      bind(value) { block.call }
    end
  end

  def >> n
    self.class.bind_const(self) { n }
  end

  def self.included m
    m.extend ClassMethods
  end
end
