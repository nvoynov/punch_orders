# MD5 39a21c3de6f3e7deda86d9ce65473495
# see https://github.com/nvoynov/punch
# frozen_string_literal: true
require_relative "service"

module Orders
  module Services

    class UserRemoveOrder < Service
      def initialize(user_id:, order_id:)
        @user_id = MustbeUUID.(user_id)
        @order_id = MustbeUUID.(order_id)
      end

      def call
        user = store.get(User, @user_id)
        fail Failure, "Unknown user id #{@user_id}" unless user
        order = store.get(Order, @order_id)
        fail Failure, "Unknown order id #{@order_id}" unless order
        fail Failure, "Order belongs to another user" unless order.user_id == @user_id
        store.rm(Order, id: @order_id)
      end
    end

  end
end
