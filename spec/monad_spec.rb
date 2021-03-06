require File.join(File.dirname(__FILE__), 'spec_helper')

require 'do_notation/monads/array'
require 'do_notation/monads/maybe'

describe "Monad.run" do
  specify "should have lexical scope" do
    foo = "cousin"
    bar = "removed"

    array = Array.run do
      x <- ["first", "second"]
      y <- ["once", "twice"]

      ["#{x} #{foo} #{y} #{bar}"]
    end

    array.should == ["first cousin once removed",
                     "first cousin twice removed",
                     "second cousin once removed",
                     "second cousin twice removed"]
  end

  it "can be run on the same block multiple times, using different monads" do
    block = proc do
      x <- unit(1)
      y <- unit(2)
      unit(x+y)
    end

    [Identity, Maybe, Array].each do |monad|
      monad.run(&block).should == monad.unit(3)
    end
  end

  specify "should be nestable" do
    array = Array.run do
      x <- run do
        a <- ['A','a']
        b <- ['B','b']

        [a+b]
      end

      y <- run do
        c <- ['C','c']
        d <- ['D','d']

        [c+d]
      end

      [x+y]
    end

    array.should == ["ABCD", "ABCd", "ABcD", "ABcd",
                     "AbCD", "AbCd", "AbcD", "Abcd",
                     "aBCD", "aBCd", "aBcD", "aBcd",
                     "abCD", "abCd", "abcD", "abcd"]
  end
end

describe 'compose' do
  specify "should compose two values, discarding the first" do
    Array.compose([1], [2]).should == [2]
  end
end

