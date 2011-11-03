require 'do_notation/monad_plus'

class Array
  include Monad

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

  alias_method :mplus, :+
end
