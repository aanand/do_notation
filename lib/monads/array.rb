class Array
  extend Monad
  
  def self.unit x
    [x]
  end
  
  def bind &f
    map(&f).inject([]){ |a,b| a+b }
  end
end
