require File.join(File.dirname(__FILE__), '..', 'init')
require 'monads/array'

describe "Array:" do
  specify "all results are calculated and concatenated" do
    array = Array.run do
      x <- ["first", "second"]
      y <- ["once", "twice"]
  
      unit("#{x} cousin #{y} removed")
    end

    array.should == ["first cousin once removed",
                     "first cousin twice removed",
                     "second cousin once removed",
                     "second cousin twice removed"]
  end
end
