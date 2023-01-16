# MD5 009ab3060d8c8878ea9665b904cc6e96
# see https://github.com/nvoynov/punch
# frozen_string_literal: true
require_relative "service"

module Orders
  module Services

    class ManagerRemoveArticle < Service

      def initialize(article_id:)
        @article_id = MustbeUUID.(article_id)
      end

      def call
        art = store.get(Article, @article_id)
        fail Failure, "Unknown article id #{@article_id}" unless art
        store.rm(art, id: art.id)
      end
    end

  end
end
