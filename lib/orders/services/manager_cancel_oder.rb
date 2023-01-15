# MD5 4f2aca66afd85547f4b09c97826e1f50
# see https://github.com/nvoynov/punch
# frozen_string_literal: true
require_relative "../basics"

module Orders
  module Services
    # 
    class ManagerCancelOder < Service

      def initialize(order_id:)
        @order_id = MustbeUuid.(order_id)
      end

      def call
        # user = storage.find(User, email: @email)
        fail "#{self.class}#call UNDER CONSTRUCTION"
      end
    end

  end
end
