require 'do_notation/monad_plus'

class Maybe < Struct.new(:value)
  include Monad

  def self.unit value
    self.new(value)
  end

  def self.bind maybe, &f
    if maybe.value.nil?
      maybe
    else
      f.call(maybe.value)
    end
  end

  extend MonadPlus

  def self.mzero
    unit(nil)
  end

  def mplus m
    if value.nil?
      m
    else
      self
    end
  end
end
