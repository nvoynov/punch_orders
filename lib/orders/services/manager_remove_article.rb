# MD5 009ab3060d8c8878ea9665b904cc6e96
# see https://github.com/nvoynov/punch
# frozen_string_literal: true
require_relative "../basics"

module Orders
  module Services
    # 
    class ManagerRemoveArticle < Service

      def initialize(article_id:)
        @article_id = MustbeUuid.(article_id)
      end

      def call
        # user = storage.find(User, email: @email)
        fail "#{self.class}#call UNDER CONSTRUCTION"
      end
    end

  end
end
