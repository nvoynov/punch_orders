# MD5 39a21c3de6f3e7deda86d9ce65473495
# see https://github.com/nvoynov/punch
# frozen_string_literal: true
require_relative "../basics"

module Orders
  module Services
    # 
    class UserRemoveOrder < Service

      def initialize(user_id:, order_id:)
        @user_id = MustbeUuid.(user_id)
        @order_id = MustbeUuid.(order_id)
      end

      def call
        # user = storage.find(User, email: @email)
        fail "#{self.class}#call UNDER CONSTRUCTION"
      end
    end

  end
end
