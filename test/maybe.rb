require File.join(File.dirname(__FILE__), %w(.. init))
require File.join(File.dirname(__FILE__), %w(.. lib maybe))

describe "Maybe:" do
  specify "one or more nils results in nil" do
    maybe = Maybe.run do
      x <- unit(1)
      y <- unit(nil)
  
      unit(x+y)
    end

    maybe.value.should == nil
  end

  specify "all non-nil results in complete calculation" do
    maybe = Maybe.run do
      x <- unit(1)
      y <- unit(2)
  
      unit(x+y)
    end
    
    maybe.value.should == 3
  end
end
