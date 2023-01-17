# MD5 64207c8e61c20310c4bbfa4c4c8ddaf0
# see https://github.com/nvoynov/punch
# frozen_string_literal: true
require_relative "query"

module Orders
  module Services

    class QueryArticles < Query
      def subject
        Article
      end
    end

  end
end
