# MD5 d85d3502969325b9bccbad15814a43f9
# see https://github.com/nvoynov/punch
# frozen_string_literal: true
require_relative "service"

module Orders
  module Services

    class UserCreateOrder < Service

      def initialize(created_by:, articles:)
        @created_by = MustbeUUID.(created_by)
        @articles = MustbeOrderArticles.(articles)
      end

      def call
        user = store.get(User, @created_by)
        fail Failure, "User not found id: #{@created_by}" unless user

        articles = @articles.map{|art|
          var = art.transform_keys(&:to_sym)
          article = store.get(Article, var[:article_id])
          fail Failure, "Article not found id: #{var[:article_id]}" unless article
          OrderItem.new(article, var[:quantity], var[:price])
        }

        stamp = Time.now
        order = Order.new(user: user,
          created_at: stamp,
          status: "new",
          status_at: stamp,
          articles: articles)
        store.put(order)
      end
    end

  end
end
