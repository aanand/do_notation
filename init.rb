%w(monad maybe array).each do |file|
  require File.join(File.dirname(__FILE__), 'lib', file)
end
