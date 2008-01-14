require File.join(File.dirname(__FILE__), %w(.. init))

describe "Maybe:" do
  specify "one or more `nothing's results in `nothing'" do
    maybe = Maybe.run do
      x <- just(1)
      y <- nothing
  
      unit(x+y)
    end

    maybe.should == Maybe.nothing
  end

  specify "all `just' results in `just'" do
    maybe = Maybe.run do
      x <- just(1)
      y <- just(2)
  
      unit(x+y)
    end
    
    maybe.should == Maybe.just(3)
  end
end

describe "Array:" do
  specify "all results are calculated and concatenated" do
    array = Array.run do
      x <- [1,2,3]
      y <- [10,20,30]

      unit(x+y)
    end

    array.should == [11, 21, 31, 12, 22, 32, 13, 23, 33]
  end
end

describe "Monad.run" do
  specify "should pass extra arguments into the block" do
    foo = 100

    array = Array.run(foo) do |foo|
      x <- [1,2,3]
      y <- [10,20,30]

      unit(x+y+foo)
    end

    array.should == [111, 121, 131, 112, 122, 132, 113, 123, 133]
  end
  
  specify "should be nestable" do
    array = Array.run do
      x <- Array.run do
        a <- ['A','a']
        b <- ['B','b']

        unit(a+b)
      end

      y <- Array.run do
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
