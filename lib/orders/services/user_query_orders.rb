# MD5 79a2bf9505a55fb3bf1855ed4e477c35
# see https://github.com/nvoynov/punch
# frozen_string_literal: true
require_relative "service"

module Orders
  module Services

    class UserQueryOrders < Service

      def initialize(user_id:, where: [], order: {}, page_number: 0, page_size: 25)
        @user_id = MustbeUUID.(user_id)
        @where = MustbeArray.(where)
        @order = MustbeHash.(order)
        @page_number = MustbePageNumber.(page_number)
        @page_size = MustbePageSize.(page_size)
        @page_size = MAX_PAGE_SIZE if @page_size > MAX_PAGE_SIZE
      end

      def call
        user = store.get(User, @user_id)
        fail Failure, "User not found id #{@user_id}" unless user

        # Store interface might be extended by #query_user_orders
        @where.unshift([:user_id, :eq, @user_id])
        store.q(Order,
          where: @where, order: @order,
          page_number: @page_number,
          page_size: @page_size)
      end

      MAX_PAGE_SIZE = 25
    end

  end
end
