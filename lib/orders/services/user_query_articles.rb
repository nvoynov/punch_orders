# MD5 b9883eda484abe84776c83c92860bba1
# see https://github.com/nvoynov/punch
# frozen_string_literal: true
require_relative "service"
require_relative "manager_query_articles"

module Orders
  module Services

    # This service does the same job as ManagerQueryArticles
    #   But maybe it will be changes in future
    class UserQueryArticles < Service

      def initialize(where:, order:, page_number:, page_size:)
        @where = MustbeArray.(where)
        @order = MustbeHash.(order)
        @page_number = MustbePageNumber.(page_number)
        @page_size = MustbePageSize.(page_size)
      end

      def call
        ManagerQueryArticles.(where: @where, order: @order, page_number: @page_number, page_size: @page_size)
      end
    end

  end
end
