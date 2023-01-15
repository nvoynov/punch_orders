# MD5 37e242629d6269ecff09060575c0ff62
# see https://github.com/nvoynov/punch
# frozen_string_literal: true
require_relative "../basics"

module Orders
  module Services
    # 
    class ManagerAcceptOder < Service

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
