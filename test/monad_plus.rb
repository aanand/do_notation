require File.join(File.dirname(__FILE__), 'spec_helper')
require 'do_notation/monads/array'
require 'do_notation/monads/maybe'

describe "MonadPlus:" do
  specify "mzero >>= f = mzero" do
    Array.mzero.bind{ |x| unit(x+1) }.should == Array.mzero
    Maybe.mzero.bind{ |x| unit(x+1) }.should == Maybe.mzero
  end
  
  specify "v >> mzero = mzero" do
    ([1,2,3] >> Array.mzero).should == Array.mzero
    (Maybe.unit(1) >> Maybe.mzero).should == Maybe.mzero
  end
  
  specify "mzero `mplus` m = m" do
    Array.mzero.mplus([1,2,3]).should == [1,2,3]
    Maybe.mzero.mplus(Maybe.unit(1)).should == Maybe.unit(1)
  end
  
  specify "m `mplus` mzero = m" do
    [1,2,3].mplus(Array.mzero).should == [1,2,3]
    Maybe.unit(1).mplus(Maybe.mzero).should == Maybe.unit(1)
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
