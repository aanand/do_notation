require 'sourcify'

module DoNotation
  def self.run(klass, &block)
    eval(ruby_for(klass, block), block).call
  end

  def self.ruby_for(klass, block)
    "#{klass.name}.instance_eval { #{ruby_for_block(block)} }"
  end

  def self.ruby_for_block(block)
    @cached_ruby ||= {}
    @cached_ruby[block.to_s] ||= Ruby2Ruby.new.process(DoNotation::Rewriter.new.process(block.to_sexp))
  end

  def self.pp(obj, indent='')
    return obj.inspect unless obj.is_a? Array
    return '()' if obj.empty?

    str = '(' + pp(obj.first, indent + ' ')

    if obj.length > 1
      str << ' '

      next_indent = indent + (' ' * str.length)

      str << obj[1..-1].map{ |o| pp(o, next_indent) }.join("\n#{next_indent}")
    end

    str << ')'

    str
  end
end

require 'do_notation/rewriter'
require 'do_notation/monad'

