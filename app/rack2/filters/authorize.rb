require_relative 'filter'

module Filters
  UnauthorizedAccess401 = Class.new(StandardError)

  # get action and parameters
  class Authorize < Filter
    class << self
      def call(payload, context = nil)
        # print ">> payload: "; pp payload
        authorize!(payload, context)
        [payload, context]
      end

      def authorize!(payload, context)
        user = payload['rack.session'][:user]
        auth = user.user? || user.manager?
        fail UnauthorizedAccess401, user.name unless auth
      end
    end

  end
end
