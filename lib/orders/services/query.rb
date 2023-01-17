# frozen_string_literal: true
require_relative "service"

module Orders
  module Services

    # General Query interface
    #
    # @example
    #   class QueryArticles < Query
    #     def subject
    #       Article
    #     end
    #   end
    #
    class Query < Service
      MAX_PAGE_SIZE = 25

      def initialize(where: [], order: {}, page_number: 0, page_size: MAX_PAGE_SIZE)
        @where = MustbeArray.(where)
        @order = MustbeHash.(order)
        @page_number = MustbePageNumber.(page_number)
        @page_size = MustbePageSize.(page_size)
        @page_size = MAX_PAGE_SIZE if @page_size > MAX_PAGE_SIZE
      end

      # @return [Array[data, more]] more == true if there is next page
      def call
        # adopt to Store.q(.., limit:, size:)
        limit = @page_size + 1 # ask for one more
        offset = @page_number * (limit - 1)

        data = store.q(subject,
          where: @where, order: @order,
          limit: limit, offset: offset)

        size = data.size
        more = size > limit - 1
        data.pop if more # remove extra one
        [data, more]
      end

      def subject
        fail "#{self.class}#subject must be overrided"
      end
    end

  end
end
