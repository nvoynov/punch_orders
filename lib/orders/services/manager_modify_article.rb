# MD5 40941a803818044b1ce2da6140226647
# see https://github.com/nvoynov/punch
# frozen_string_literal: true
require_relative "../basics"

module Orders
  module Services
    # 
    class ManagerModifyArticle < Service

      def initialize(article_id:, title:, description:, price:)
        @article_id = MustbeUuid.(article_id)
        @title = MustbeTitle.(title)
        @description = MustbeDescription.(description)
        @price = MustbeMoney.(price)
      end

      def call
        # user = storage.find(User, email: @email)
        fail "#{self.class}#call UNDER CONSTRUCTION"
      end
    end

  end
end
