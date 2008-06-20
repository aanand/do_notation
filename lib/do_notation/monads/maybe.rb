require 'do_notation/monad_plus'

class Maybe < Struct.new(:value)
  include Monad
  
  def self.unit value
    self.new(value)
  end
  
  def bind &f
    if value.nil?
      self
    else
      f.call(value)
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
