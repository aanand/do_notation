require File.join(File.dirname(__FILE__), 'spec_helper')
require 'do_notation/monads/array'
require 'do_notation/monads/maybe'

describe "MonadPlus:" do
  specify "mzero >>= f = mzero" do
    Array.bind(Array.mzero){ |x| unit(x+1) }.should == Array.mzero
    Maybe.bind(Maybe.mzero){ |x| unit(x+1) }.should == Maybe.mzero
  end

  specify "compose(v, mzero) = mzero" do
    Array.compose(Array.unit(1), Array.mzero).should == Array.mzero
    Maybe.compose(Maybe.unit(1), Maybe.mzero).should == Maybe.mzero
  end

  specify "mzero `mplus` m = m" do
    Array.mplus(Array.mzero, Array.unit(1)).should == Array.unit(1)
    Maybe.mplus(Maybe.mzero, Maybe.unit(1)).should == Maybe.unit(1)
  end

  specify "m `mplus` mzero = m" do
    Array.mplus(Array.unit(1), Array.mzero).should == Array.unit(1)
    Maybe.mplus(Maybe.unit(1), Maybe.mzero).should == Maybe.unit(1)
  end

  specify "guard() prunes the execution tree" do
    array = Array.run do
      x <- [0,1,2,3]
      y <- [0,1,2,3]
      guard(x + y == 3)

      unit([x,y])
    end

    array.should == [[0, 3], [1, 2], [2, 1], [3, 0]]
  end
end
