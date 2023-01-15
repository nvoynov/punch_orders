# MD5 d85d3502969325b9bccbad15814a43f9
# see https://github.com/nvoynov/punch
# frozen_string_literal: true
require_relative "../basics"

module Orders
  module Services
    # 
    class UserCreateOrder < Service

      def initialize(created_by:, articles:)
        @created_by = MustbeUuid.(created_by)
        @articles = MustbeOrderArticles.(articles)
      end

      def call
        # user = storage.find(User, email: @email)
        fail "#{self.class}#call UNDER CONSTRUCTION"
      end
    end

  end
end
