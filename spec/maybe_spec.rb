require File.join(File.dirname(__FILE__), 'spec_helper')
require 'do_notation/monads/maybe'

describe "Maybe:" do
  specify "one or more nils results in nil" do
    value = Maybe.run do
      x <- 1
      y <- nil

      x + y
    end

    value.should == nil
  end

  specify "all non-nil results in complete calculation" do
    value = Maybe.run do
      x <- 1
      y <- 2

      x + y
    end

    value.should == 3
  end
end
