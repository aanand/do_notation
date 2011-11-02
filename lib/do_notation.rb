require 'parse_tree'
require 'sexp_processor'
require 'ruby2ruby'

require 'do_notation/rewriter'
require 'do_notation/monad'

module DoNotation
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

