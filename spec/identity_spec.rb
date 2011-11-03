require File.join(File.dirname(__FILE__), 'spec_helper')
require 'do_notation/monads/identity'

describe "Identity:" do
  specify "just works like sequential code" do
    value = Identity.run do
      x <- 1
      y <- 2

      x + y
    end

    value.should == 3
  end

  specify "doesn't do anything special with nil" do
    lambda {
      value = Identity.run do
        x <- 1
        y <- nil

        x + y
      end
    }.should raise_error(TypeError)
  end
end

