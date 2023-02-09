require_relative "conf"
require_relative "../extras"

# Every service interface is just a few keyword arguments.
# Having incoming messages as hashes, action proxy will
#   just turn that hash into keywords

module Actions
  # Message handler
  #
  # @example
  #   class CreateArticleAction < Action
  #     handle 'create.article'
  #     origin CreateArticle
  #
  #     # override it when you need some special
  #     def arguments
  #       kwargs = {}
  #       order_id = @payload['order_id']
  #       kwargs.store(:order_id, order_id)
  #       [[], kwargs, nil]
  #     end
  #   end
  #
  class Action < ProxyCall
    class << self
      def handle(arg)
        fail ":arg must be String" unless arg.is_a?(String)
        @action = arg
      end

      def action
        @action
      end
    end

    def initialize(payload)
      fail ":payload must be Hash" unless payload.is_a?(Hash)
      @payload = payload
    end

    def arguments
      kwargs = @payload.transform_keys{|k| k.to_sym}
      [[], kwargs, nil]
    end
  end

  class << self
    def find(arg)
      roster.fetch(arg, nil)
    end
    alias :call :find

    protected

    def roster
      @roster ||= begin
        rejectfu = proc{|arg| arg.to_s =~ /(Query|Service)/}
        services = Orders::Services
        consts = services.constants.reject(&rejectfu)
        consts.map{|kon|
          origin = services.const_get(kon)
          handle = dotcase(kon.to_s)
          [handle,
            Class.new(Action) do
              handle handle
              origin origin
            end
          ]
        }.to_h
      end
    end

    def dotcase(str)
      str
        .split('::').last
        .gsub(/([A-Z]+)([A-Z][a-z])/,'\1.\2')
        .gsub(/([a-z\d])([A-Z])/,'\1.\2')
        .downcase
    end
  end
end
