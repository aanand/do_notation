require File.join(File.dirname(__FILE__), 'spec_helper')

describe "Rewriter" do
  it "leaves uninteresting blocks alone" do
    block = proc { x + y }
    process(block.to_sexp).should == block.to_sexp
  end

  it "rewrites the <- operator" do
    in_block  = proc do
      x <- 1
      y
    end

    out_block = proc do
      1.bind do |x|
        y
      end
    end

    process(in_block.to_method.to_sexp)[2].should == out_block.to_sexp
  end

  it "rewrites multiple <- operators" do
    in_block  = proc do
      x <- 1
      y <- 2
      z
    end

    out_block = proc do
      1.bind do |x|
        2.bind do |y|
          z
        end
      end
    end

    process(in_block.to_method.to_sexp)[2].should == out_block.to_sexp
  end

  def process(sexp)
    DoNotation::Rewriter.new.process(sexp).to_a
  end
end
