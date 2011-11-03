module Identity
  include Monad

  class << self
    def unit(obj)
      obj
    end

    def bind(obj, &fn)
      fn.call(obj)
    end
  end
end

