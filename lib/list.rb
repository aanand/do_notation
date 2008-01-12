class List < Monad
  class << self
    alias_method :list, :new
    alias_method :unit, :list
  end
  
  attr_accessor :array
  
  def initialize *args
    @array = args
  end

  def ==(l)
    l.is_a? List and array == l.array
  end
  
  def bind &f
    lists = @array.map{ |x| f.call(x) }
    
    List.unit(*lists.inject([]) { |acc, l| acc + l.array })
  end
  
  def to_s
    @array.inspect
  end
end
