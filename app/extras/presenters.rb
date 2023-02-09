require "runch"
require "./lib/orders"
include Orders::Entities
include Runch

module Extras
  module Presenters
    class << self

      def find(arg)
        roster.fetch(arg.is_a?(Class) ? arg : arg.class, nil) # NullPresenter?
      end
      alias :call :find

      protected

      def roster
        @roster ||=
          constants.map{|kon|
            const = const_get(kon)
            [const.klass, const]
          }.to_h
      end
    end

    class ArticlePresenter < ObjectToHash
      from Article
      property :id, :title, :description, :price
    end

    class OrderPresenter < ObjectToHash
      from Order
      property :id, :created_by, :created_at, :user_name, :status, :status_at, :total
      collection :articles, :article_id, :title, :quantity, :price, :total
    end

    # class FailurePresenter < Presenter
    #   klass StandardError
    #   properties :class, :message
    # end

  end
end
