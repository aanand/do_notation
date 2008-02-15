class Maybe
  extend Monad
  
  class << self
    alias_method :unit, :new
  end
  
  attr_accessor :value
  
  def initialize value
    @value = value
  end
  
  def bind &f
    if value.nil?
      self
    else
      f.call(value)
    end
  end
end
