# MD5 170d398d9e1bb9bcbfa949fd47d321fd
# see https://github.com/nvoynov/punch
# frozen_string_literal: true
require_relative "../basics"

module Orders
  module Entities
    #
    class Order < Entity
      # @return [Uuid] Order Created By
      attr_reader :created_by

      # @return [Timestamp] Order Created At
      attr_reader :created_at

      # @return [Order_status] Order Status
      attr_reader :status

      # @return [Timestamp] Order Status Changed At
      attr_reader :status_at

      # @return [Order_articles] Order Articles
      attr_reader :articles

      def initialize(id: nil, created_by:, created_at:, status:, status_at:, articles:)
        super(id)
        @created_by = MustbeUUID.(created_by)
        @created_at = MustbeTimestamp.(created_at)
        @status = MustbeOrderStatus.(status)
        @status_at = MustbeTimestamp.(status_at)
        @articles = MustbeOrderArticles.(articles)
      end
    end

  end
end
