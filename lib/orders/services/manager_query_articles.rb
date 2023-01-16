# MD5 64207c8e61c20310c4bbfa4c4c8ddaf0
# see https://github.com/nvoynov/punch
# frozen_string_literal: true
require_relative "service"

module Orders
  module Services

    class ManagerQueryArticles < Service

      def initialize(where: [], order: {}, page_number: 0, page_size: 25)
        @where = MustbeArray.(where)
        @order = MustbeHash.(order)
        @page_number = MustbePageNumber.(page_number)
        @page_size = MustbePageSize.(page_size)
        @page_size = MAX_PAGE_SIZE if @page_size > MAX_PAGE_SIZE
      end

      def call
        store.q(Article,
          where: @where, order: @order,
          page_number: @page_number,
          page_size: @page_size)
      end

      MAX_PAGE_SIZE = 25
    end

  end
end
