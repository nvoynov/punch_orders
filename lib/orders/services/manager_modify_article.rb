# MD5 40941a803818044b1ce2da6140226647
# see https://github.com/nvoynov/punch
# frozen_string_literal: true
require_relative "service"

module Orders
  module Services
    #
    class ManagerModifyArticle < Service

      def initialize(article_id:, title: nil, description: nil, price: nil)
        @article_id = MustbeUUID.(article_id)
        @title = MustbeTitle.(title) if title
        @description = MustbeDescription.(description) if description
        @price = MustbeMoney.(price) if price
        @changeset = { title: @title, description: @description, price: @price }
        @changeset.compact!
        msg = "must be provided at least one of the keys (:title, :description, :price)"
        fail Failure, msg unless @changeset.any?
      end

      def call
        art = store.get(Article, @article_id)
        fail Failure, "Unknown article id #{@article_id}" unless art
        store.put(art.clone_with(**@changeset))
      end
    end

  end
end
