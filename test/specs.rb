require File.join(File.dirname(__FILE__), %w(.. init))

describe "Maybe:" do
  specify "one or more `nothing's results in `nothing'" do
    maybe = Maybe.run do |m|
      x =m just(1)
      y =m nothing
  
      unit(x+y)
    end

    maybe.should == Maybe.nothing
  end

  specify "all `just' results in `just'" do
    maybe = Maybe.run do |m|
      x =m just(1)
      y =m just(2)
  
      unit(x+y)
    end
    
    maybe.should == Maybe.just(3)
  end
end

describe "List:" do
  specify "all results are calculated and concatenated" do
    list = List.run do |m|
      x =m list(1,2,3)
      y =m list(10,20,30)

      unit(x+y)
    end

    list.should == List.list(11, 21, 31, 12, 22, 32, 13, 23, 33)
  end
end

describe "Monad.run" do
  specify "should pass extra arguments into the block" do
    foo = 100

    list = List.run(foo) do |m, foo|
      x =m list(1,2,3)
      y =m list(10,20,30)

      unit(x+y+foo)
    end

    list.should == List.list(111, 121, 131, 112, 122, 132, 113, 123, 133)
  end
end
