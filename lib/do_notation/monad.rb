module Monad
  module ClassMethods
    def run &block
      DoNotation.run(self, &block)
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
