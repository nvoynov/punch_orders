# MD5 d85d3502969325b9bccbad15814a43f9
# see https://github.com/nvoynov/punch
# frozen_string_literal: true
require_relative "service"

module Orders
  module Services

    class UserCreateOrder < Service

      def initialize(user_id:, articles:)
        @user_id = MustbeUUID.(user_id)
        @articles = MustbeOrderArticles.(articles)
      end

      def call
        timestamp = Time.now
        payload = {
          user_id: @user_id,
          created_at: timestamp,
          status: 'new',
          status_at: timestamp,
          articles: @articles
        }
        order = OrderBuilder.(payload, store)
        store.put(order)
      end
    end

  end
end
