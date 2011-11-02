require File.join(File.dirname(__FILE__), 'spec_helper')
require 'do_notation/monads/simulations'

EPSILON = 0.001

RSpec::Matchers.define :approximate_floats do |expected|
  match do |actual|
    all_approximate?(actual, expected)
  end

  def all_approximate?(actual, expected)
    case actual
    when Array
      actual.zip(expected).all? { |pair| all_approximate?(pair.first, pair.last) }
    when Float
      (expected - actual).abs < EPSILON
    else
      expected == actual
    end
  end
end

roll_3d6 = proc do
  d1 <- rand(6)
  d2 <- rand(6)
  d3 <- rand(6)

  unit(1+d1 + 1+d2 + 1+d3)
end

roll_3d6_b = proc do
  d1 <- rand(6)
  d2 <- rand(6)
  d3 <- rand(6)

  if [d1, d2, d3].include?(5)
    run do
      d4 <- rand(6)
      unit(1+d1 + 1+d2 + 1+d3 + 1+d4)
    end
  else
    unit(1+d1 + 1+d2 + 1+d3)
  end
end

describe "Simulation" do
  specify "generates correct answers" do
    Simulation.run(&roll_3d6).play.should   == 9
    Simulation.run(&roll_3d6_b).play.should == 9
  end
end

describe "Distribution" do
  specify "generates correct answers" do
    Distribution.run(&roll_3d6).play.should approximate_floats([[3, 0.005], [4, 0.014], [5, 0.028], [6, 0.046], [7, 0.069], [8, 0.097], [9, 0.116], [10, 0.125], [11, 0.125], [12, 0.116], [13, 0.097], [14, 0.069], [15, 0.046], [16, 0.028], [17, 0.014], [18, 0.005]])
    Distribution.run(&roll_3d6_b).play.should approximate_floats([[3, 0.005], [4, 0.014], [5, 0.028], [6, 0.046], [7, 0.069], [8, 0.083], [9, 0.09], [10, 0.09], [11, 0.083], [12, 0.069], [13, 0.063], [14, 0.06], [15, 0.058], [16, 0.056], [17, 0.053], [18, 0.046], [19, 0.035], [20, 0.024], [21, 0.015], [22, 0.008], [23, 0.003], [24, 0.001]])
  end
end

describe "Expectation" do
  specify "generates correct answers" do
    (1..21).collect { |x| Expectation.run(&roll_3d6).play(x) }.should approximate_floats([0.0, 0.0, 0.005, 0.014, 0.028, 0.046, 0.069, 0.097, 0.116, 0.125, 0.125, 0.116, 0.097, 0.069, 0.046, 0.028, 0.014, 0.005, 0.0, 0.0, 0.0])
    (1..21).collect { |x| Expectation.run(&roll_3d6_b).play(x) }.should approximate_floats([0.0, 0.0, 0.005, 0.014, 0.028, 0.046, 0.069, 0.083, 0.09, 0.09, 0.083, 0.069, 0.063, 0.06, 0.058, 0.056, 0.053, 0.046, 0.035, 0.024, 0.015])
  end
end
