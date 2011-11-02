require File.join(File.dirname(__FILE__), 'spec_helper')

describe "Rewriter" do
  it "leaves uninteresting blocks alone" do
    in_block  = proc { x + y }
    out_block = proc { x + y }

    process(in_block.to_sexp).should == out_block.to_sexp
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

    # puts DoNotation.pp(in_block.to_sexp)
    # puts DoNotation.pp(out_block.to_sexp)

    process(in_block.to_sexp).should == out_block.to_sexp
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

    # puts DoNotation.pp(in_block.to_sexp)
    # puts DoNotation.pp(out_block.to_sexp)

    process(in_block.to_sexp).should == out_block.to_sexp
  end

  def process(sexp)
    DoNotation::Rewriter.new.process(sexp)
  end
end
