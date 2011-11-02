require File.join(File.dirname(__FILE__), 'spec_helper')
require 'do_notation/monads/array'

describe "Array:" do
  specify "all results are calculated and concatenated" do
    array = Array.run do
      x <- ["first", "second"]
      y <- ["once", "twice"]

      ["#{x} cousin #{y} removed"]
    end

    array.should == ["first cousin once removed",
                     "first cousin twice removed",
                     "second cousin once removed",
                     "second cousin twice removed"]
  end
end
