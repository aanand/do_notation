require File.join(File.dirname(__FILE__), 'spec_helper')

describe "DoNotation.pp" do
  specify "should produce correct output" do
    array = [:a, [:b],
                 [:c, :d,
                      :e]]

    DoNotation.pp(array).should == <<CODE.strip
(:a (:b)
    (:c :d
        :e))
CODE
  end
end

