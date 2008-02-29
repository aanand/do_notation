class Maybe < Struct.new(:value)
  extend Monad
  
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
end
