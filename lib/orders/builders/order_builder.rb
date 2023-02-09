# frozen_string_literal: true

require_relative "../entities"

module Orders
  module Builders

    class OrderBuilder
      def self.call(payload, store)
        new().(payload, store)
      end

      def call(payload, store)
        user_id = payload.delete(:user_id)
        user = store.get(User, user_id)
        fail "unknown user #{user_id}" unless user
        payload[:user] = user

        parts = payload[:articles].map{|a| a.transform_keys(&:to_sym)}
        artid = parts.map{|a| a[:article_id]}
        _, e = store.key?(Article, *artid)
        fail "unknown articles #{e.join(', ')}" if e.any?

        articles = store
          .all(Article, id: artid)
          .map{|a| [a.id, a]}.to_h

        orderart = parts.map{|art|
          kwargs = art.slice(:quantity, :price)
          kwargs.store(:article, articles[art[:article_id]])
          OrderItem.new(**kwargs)
        }
        payload[:articles] = orderart
        payload = payload.slice(*%i[user created_at status status_at articles])
        Order.new(**payload)
      end
    end

  end
end
