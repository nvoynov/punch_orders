# MD5 79a2bf9505a55fb3bf1855ed4e477c35
# see https://github.com/nvoynov/punch
# frozen_string_literal: true
require_relative "../basics"

module Orders
  module Services
    # 
    class UserQueryOrders < Service

      def initialize(where:, order:, page_number:, page_size:)
        @where = MustbeArray.(where)
        @order = MustbeHash.(order)
        @page_number = MustbePageNumber.(page_number)
        @page_size = MustbePageSize.(page_size)
      end

      def call
        # user = storage.find(User, email: @email)
        fail "#{self.class}#call UNDER CONSTRUCTION"
      end
    end

  end
end
