require 'do_notation/monad_plus'

class Array
  include Monad

  def self.unit x
    [x]
  end
  
  def bind &f
    map(&f).inject([]){ |a,b| a+b }
  end
  
  extend MonadPlus
  
  def self.mzero
    []
  end
  
  alias_method :mplus, :+
end
