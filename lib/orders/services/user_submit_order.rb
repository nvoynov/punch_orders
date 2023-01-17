# MD5 debf9cbc1335367aeb8a0dd4c9c43827
# see https://github.com/nvoynov/punch
# frozen_string_literal: true
require_relative "service"

module Orders
  module Services

    class UserSubmitOrder < Service
      def initialize(user_id:, order_id:)
        @user_id = MustbeUUID.(user_id)
        @order_id = MustbeUUID.(order_id)
      end

      def call
        user = store.get(User, @user_id)
        fail Failure, "Unknown user id #{@user_id}" unless user

        order = store.get(Order, @order_id)
        fail Failure, "Unknown order id #{@order_id}" unless order
        fail Failure, "Order belongs to another user" unless order.created_by == @user_id
        arg = order.clone_with(status: "submitted", status_at: Time.now)
        store.put(arg)
      end
    end

  end
end
