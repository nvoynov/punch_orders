# MD5 37e242629d6269ecff09060575c0ff62
# see https://github.com/nvoynov/punch
# frozen_string_literal: true
require_relative "service"

module Orders
  module Services

    class ManagerAcceptOrder < Service

      def initialize(order_id:)
        @order_id = MustbeUUID.(order_id)
      end

      def call
        order = store.get(Order, @order_id)
        fail Failure, "Order not found id: #{@order_id}" unless order
        return order if order.accepted?

        arg = order.clone_with(status: 'accepted', status_at: Time.now)
        store.put(arg)
      end
    end

  end
end
