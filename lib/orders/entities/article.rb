# MD5 4b829e40f9fd00fc5a3bd0c347f835f6
# see https://github.com/nvoynov/punch
# frozen_string_literal: true
require_relative "entity"

module Orders
  module Entities

    class Article < Entity
      # @return [Title] Article Title
      attr_reader :title

      # @return [Description] Article Description
      attr_reader :description

      # @return [Money] Article Price
      attr_reader :price

      # @return [Timestamp] Article Removed At
      attr_reader :removed_at

      def initialize(id: nil, title:, description:, price:, removed_at: nil)
        super(id)
        @title = MustbeTitle.(title)
        @description = MustbeDescription.(description)
        @price = MustbeMoney.(price)
        @removed_at = MustbeTimestamp.(removed_at) if removed_at
      end
    end

  end
end
