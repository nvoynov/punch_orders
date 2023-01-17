# MD5 4f2aca66afd85547f4b09c97826e1f50
# see https://github.com/nvoynov/punch
# frozen_string_literal: true
require_relative "service"

module Orders
  module Services

    class ManagerCancelOrder < Service

      def initialize(order_id:)
        @order_id = MustbeUUID.(order_id)
      end

      def call
        order = store.get(Order, @order_id)
        fail Failure, "Order not found id: #{@order_id}" unless order
        return order if order.canceled?

        arg = order.clone_with(status: 'canceled', status_at: Time.now)
        store.put(arg)
      end
    end

  end
end
