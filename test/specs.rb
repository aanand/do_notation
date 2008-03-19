require File.join(File.dirname(__FILE__), %w(.. init))
require File.join(File.dirname(__FILE__), %w(.. lib array))

describe "Monad.run" do
  specify "should pass extra arguments into the block" do
    foo = 8000

    array = Array.run(foo) do |foo|
      x <- [1,2,3]
      y <- [10,20,30]

      unit(x+y+foo)
    end

    array.should == [8011, 8021, 8031, 8012, 8022, 8032, 8013, 8023, 8033]
    
    foo = 8000
    bar = 70000

    array = Array.run(foo, bar) do |foo, bar|
      x <- [1,2,3]
      y <- [10,20,30]

      unit(x+y+foo+bar)
    end

    array.should == [78011, 78021, 78031, 78012, 78022, 78032, 78013, 78023, 78033]
  end
  
  specify "should be nestable" do
    array = Array.run do
      x <- run do
        a <- ['A','a']
        b <- ['B','b']

        unit(a+b)
      end

      y <- run do
        a <- ['C','c']
        b <- ['D','d']

        unit(a+b)
      end

      unit(x+y)
    end
    
    array.should == ["ABCD", "ABCd", "ABcD", "ABcd",
                     "AbCD", "AbCd", "AbcD", "Abcd",
                     "aBCD", "aBCd", "aBcD", "aBcd",
                     "abCD", "abCd", "abcD", "abcd"]
  end
end
