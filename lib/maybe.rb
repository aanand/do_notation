class Maybe
  extend Monad
  
  class << self
    alias_method :nothing, :new
    alias_method :just, :new
    alias_method :unit, :just
  end
  
  attr_accessor :value, :nothing
  
  def initialize *args
    if args.empty?
      @nothing = true
    else
      @value = args.shift
    end
  end
  
  def ==(m)
    m.is_a? Maybe and ((nothing and m.nothing) or (value = m.value))
  end
    
  def bind &f
    if self.nothing
      self
    else
      f.call(self.value)
    end
  end
  
  def to_s
    if @nothing
      "nothing"
    else
      "just(#{@value})"
    end
  end
end
