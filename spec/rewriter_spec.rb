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
      bind 1 do |x|
        y
      end
    end

    process(in_block.to_sexp).should == out_block.to_sexp
  end

  it "rewrites multiple <- operators" do
    in_block  = proc do
      x <- 1
      y <- 2
      z
    end

    out_block = proc do
      bind 1 do |x|
        bind 2 do |y|
          z
        end
      end
    end

    process(in_block.to_sexp).should == out_block.to_sexp
  end

  it "rewrites statements without a <- to use bind_const" do
    in_block  = proc do
      x <- 1
      do_something
      y <- 2
      z
    end

    out_block = proc do
      bind 1 do |x|
        bind_const(do_something) do
          bind 2 do |y|
            z
          end
        end
      end
    end

    process(in_block.to_sexp).should == out_block.to_sexp
  end

  def process(sexp)
    DoNotation::Rewriter.new.process(sexp)
  end
end
