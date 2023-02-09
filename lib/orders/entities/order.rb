# MD5 170d398d9e1bb9bcbfa949fd47d321fd
# see https://github.com/nvoynov/punch
# frozen_string_literal: true
require_relative "entity"
require "forwardable"

module Orders
  module Entities

    MustbeArticle = Sentry.new(:article, "must be Article"
    ) {|v| v.is_a?(Article)}

    MustbeUser = Sentry.new(:user, "must be User"
    ) {|v| v.is_a?(User)}

    # OrderItem Value, NOT Entity, does not have Id!
    class OrderItem
      extend Forwardable
      def_delegator :@article, :id, :article_id
      def_delegators :@article, :title, :description

      # attr_reader :article
      attr_reader :quantity
      attr_reader :price

      def initialize(article:, quantity:, price:)
        @article = MustbeArticle.(article)
        @quantity = MustbeQuantity.(quantity)
        @price = MustbeMoney.(price)
      end

      def total
        @total ||= price.to_d * quantity.to_d
      end
    end

    class Order < Entity
      extend Forwardable
      def_delegator :@user, :id, :created_by
      def_delegator :@user, :name, :user_name

      # @return [User] Order Created By
      attr_reader :user

      # @return [Timestamp] Order Created At
      attr_reader :created_at

      # @return [Order_status] Order Status
      attr_reader :status

      # @return [Timestamp] Order Status Changed At
      attr_reader :status_at

      # @return [Order_articles] Order Articles
      attr_reader :articles

      def initialize(id: nil, user:, created_at:, status:, status_at:, articles:)
        super(id)
        @user = MustbeUser.(user)
        @created_at = MustbeTimestamp.(created_at)
        @status = MustbeOrderStatus.(status)
        @status_at = MustbeTimestamp.(status_at)
        @articles = articles # MustbeOrderArticles.(articles)
      end

      def total
        @total ||= @articles.map(&:total).sum
      end

      def accepted?
        @status == 'accepted'
      end

      def canceled?
        @status == 'canceled'
      end
    end

  end
end
