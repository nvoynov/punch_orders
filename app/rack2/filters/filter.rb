module Filters

  # Basic Filter
  class Filter
    class << self
      def call(payload, context = nil)
        new().call(payload)
      end

      def to_proc
        method(:call)
      end
    end

    def call(payload, context)
      fail "#{self.class}#call(payload) must be overridden"
    end
  end
end
