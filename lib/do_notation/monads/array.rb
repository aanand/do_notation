require 'do_notation'
require 'do_notation/monad_plus'

class Array
  extend Monad

  def self.unit x
    [x]
  end

  def self.bind value, &f
    value.map(&f).inject([], &:+)
  end

  extend MonadPlus

  def self.mzero
    []
  end

  def self.mplus(a, b)
    a + b
  end
end
