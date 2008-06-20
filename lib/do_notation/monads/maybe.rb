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
end
