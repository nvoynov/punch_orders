# MD5 aeec86370f9a91a5c1349d64c2875ee3
# see https://github.com/nvoynov/punch
# frozen_string_literal: true
require_relative "../basics"

module Orders
  module Services
    # 
    class ManagerQueryOrders < Service

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
