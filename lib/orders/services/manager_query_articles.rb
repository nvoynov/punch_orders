# MD5 64207c8e61c20310c4bbfa4c4c8ddaf0
# see https://github.com/nvoynov/punch
# frozen_string_literal: true
require_relative "../basics"

module Orders
  module Services
    # 
    class ManagerQueryArticles < Service

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
