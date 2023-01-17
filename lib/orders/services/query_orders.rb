# MD5 aeec86370f9a91a5c1349d64c2875ee3
# see https://github.com/nvoynov/punch
# frozen_string_literal: true
require_relative "query"

module Orders
  module Services

    class QueryOrders < Query
      def subject
        Order
      end
    end

  end
end
