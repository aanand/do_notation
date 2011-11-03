require 'do_notation/monad_plus'

class Maybe
  include Monad

  def self.unit value
    value
  end

  def self.bind value, &f
    if value.nil?
      nil
    else
      f.call(value)
    end
  end

  extend MonadPlus

  def self.mzero
    unit(nil)
  end

  def self.mplus a, b
    if b.nil?
      a
    else
      b
    end
  end
end
