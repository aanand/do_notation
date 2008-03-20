# converted from Mauricio Fernandez's "Warm fuzzy things for random simulations":
# http://eigenclass.org/hiki/warm-fuzzy-things-for-random-simulations
# http://eigenclass.org/hiki.rb?c=plugin;plugin=attach_download;p=warm-fuzzy-things-for-random-simulations;file_name=fuzzy-warm-simulations.rb

module PRNG 
  def next_state(s); (69069 * s + 5) % (2**32) end
end

class Simulation
  extend PRNG
  extend Monad
  
  attr_reader :f

  def initialize(&b)
    @f = b
  end
  
  def self.unit(x)
    new { |s| [x, s] }
  end
  
  def self.rand(n)
    self.new do |s|
      [s.abs % n, next_state(s)]
    end
  end

  def bind(&b)
    self.class.new do |s|
      x, s = @f.call(s)
      b.call(x).f.call(s)
    end
  end
  
  def play(s = 12345)
    @f.call(s).first
  end
end

class Distribution
  extend PRNG
  extend Monad
  
  attr_reader :a

  def initialize(a)
    @a = a
  end
  
  def self.wrap(a)
    new(a)
  end
  
  def self.unit(x)
    wrap [[x, 1.0]]
  end

  def self.rand(n) 
    p = 1.0 / n
    new((0...n).map{|i| [i, p]})
  end

  def bind(&b)
    if @a.empty?
      self.class.wrap([])
    else
      x, p = @a[0]
      self.class.wrap(mulp(p, b.call(x)) + self.class.new(@a[1..-1]).bind(&b).a)
    end
  end

  def play
    h = Hash.new{|h, k| h[k] = 0.0}
    @a.each{|x, p| h[x] += p}
    h.to_a.sort_by{|x,| x}
  end

  private
  def mulp(p, l)
    l.a.map{|x, p1| [x, p * p1]}
  end
end

class Expectation
  extend PRNG
  extend Monad
  
  attr_reader :f

  def initialize(&b)
    @f = b
  end
  
  def self.wrap(&proc)
    new(&proc)
  end

  def self.unit(x)
    wrap{ |f| f.call(x) }
  end

  def self.rand(n)
    wrap do |k|
      sum = (0..n-1).map{|x| k.call(x)}.inject{|s,x| s+x}
      1.0 * sum / n
    end
  end

  def bind(&b)
    self.class.wrap{|k| @f.call(lambda{|x| b.call(x).f.call(k)}) }
  end

  def play(x)
    @f.call(lambda{|x1| x1 == x ? 1.0 : 0.0})
  end
end
