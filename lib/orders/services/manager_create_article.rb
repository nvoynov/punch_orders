# MD5 1da5ddd579a39bf302822823fc974eca
# see https://github.com/nvoynov/punch
# frozen_string_literal: true
require_relative "service"

module Orders
  module Services

    class ManagerCreateArticle < Service

      def initialize(title:, description:, price:)
        @title = MustbeTitle.(title, :title)
        @price = MustbeMoney.(price, :price)
        @description = MustbeDescription.(description, :description)
      end

      def call
        art = store.find(Article, title: @title)
        fail Failure, "article with the same title already exist" if art
        art = Article.new(title: @title, description: @description,
          price: @price.to_d, removed_at: nil)
        store.put(art)
      end
    end

  end
end
