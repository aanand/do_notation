class Maybe < Struct.new(:value)
  extend Monad
  
  class << self
    alias_method :unit, :new
  end
  
  def bind &f
    if value.nil?
      self
    else
      f.call(value)
    end
  end
end
