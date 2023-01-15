# MD5 1da5ddd579a39bf302822823fc974eca
# see https://github.com/nvoynov/punch
# frozen_string_literal: true
require_relative "../basics"

module Orders
  module Services
    # 
    class ManagerCreateArticle < Service

      def initialize(title:, description:, price:)
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
