require "runch"
require "runch/sequel_pg_store"
require "./lib/orders"
include Orders::Entities
include Runch

module Builders

  class << self
    def find(klass)
      roster.fetch(klass, nil) # NullMapper?
    end
    alias :call :find

    protected
    def roster
      @roster ||= constants.map{|kon|
        const = const_get(kon)
        [const.klass, const]
      }.to_h
    end
  end

  class ArticleBuilder < SequelPgBuilder
    into Article
    from :articles
    property :id, :title, :price
  end

  class OrderBuilder < SequelPgBuilder
    into Order
    from :orders
    property :id, :customer_id, :created_at
    collection :articles, :article_id, :quantity, :price

    def call(payload, store)
      customer = store.get(Customer, payload.delete(:customer_id))
      payload[:customer] = customer

      parts = payload[:articles].map{|a| a.transform_keys(&:to_sym)}

      articles = parts.map{|a| a[:article_id]}
        .then{|ids| store.all(Article, id: ids) }
        .map{|art| [art.id, art] }.to_h

      # @todo what to do when article not found?
      orderart = parts.map{|art|
        kwargs = art.slice(:quantity, :price)
        kwargs.store(:article, articles[art[:article_id]])
        OrderAr.new(**kwargs)
      }
      payload[:articles] = orderart
      payload = payload.slice(:id, :customer, :created_at, :articles)
      Order.new(**payload)
    end
  end
end
