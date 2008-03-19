require File.join(File.dirname(__FILE__), %w(.. init))
require File.join(File.dirname(__FILE__), %w(.. lib array))

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
