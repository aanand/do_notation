require File.join(File.dirname(__FILE__), %w(.. init))
require 'monads/array'

describe "Monad.run" do
  specify "should pass extra arguments into the block" do
    foo = "cousin"
    bar = "removed"

    expected_result = ["first cousin once removed",
                       "first cousin twice removed",
                       "second cousin once removed",
                       "second cousin twice removed"]

    # explicitly test the 1-argument case, because
    # it generates a subtly different parse tree

    array = Array.run(foo) do |foo|
      x <- ["first", "second"]
      y <- ["once", "twice"]

      unit("#{x} #{foo} #{y} removed")
    end

    array.should == expected_result
    
    array = Array.run(foo, bar) do |foo, bar|
      x <- ["first", "second"]
      y <- ["once", "twice"]

      unit("#{x} #{foo} #{y} #{bar}")
    end

    array.should == expected_result
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