require File.join(File.dirname(__FILE__), 'spec_helper')
require 'do_notation/monads/array'
require 'do_notation/monads/maybe'

describe "MonadPlus:" do
  [Maybe, Array].each do |monad|
    describe monad do
      specify "mzero >>= f = mzero" do
        monad.bind(monad.mzero){ |x| unit(x+1) }.should == monad.mzero
      end

      specify "v >> mzero = mzero" do
        monad.compose(monad.unit(1), monad.mzero).should == monad.mzero
      end

      specify "mzero `mplus` m = m" do
        monad.mplus(monad.mzero, monad.unit(1)).should == monad.unit(1)
      end

      specify "m `mplus` mzero = m" do
        monad.mplus(monad.unit(1), monad.mzero).should == monad.unit(1)
      end
    end
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
