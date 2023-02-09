require_relative "../test_helper"
require "bigdecimal/util"
include Orders::Entities

# This source provides a few entity samples
module Dummy
  extend self

  def john
    @john ||= User.new(name: 'John')
  end

  def jane
    @jane ||= User.new(name: 'Jane')
  end

  def druby_book
    punch_article('dRuby', 'dRuby Book')
  end

  def redis_book
    punch_article('Redis', 'Redis Book')
  end

  def mongo_book
    punch_article('Mongo', 'Mongo Book')
  end

  def order_articles
    [
      { "article_id" => articles.first.id, 'quantity' => 1, "price" => 9.99 },
    ]
  end

  def articles
    @articles ||= [
      Article.new(**druby_book.transform_keys(&:to_sym)),
      Article.new(**redis_book.transform_keys(&:to_sym)),
      Article.new(**mongo_book.transform_keys(&:to_sym)),
    ]
    @articles.dup
  end

  def john_order
    @john_order ||= punch_order(john)
  end

  def jane_order
    @jane_order ||= punch_order(jane)
  end

  def orders
    @orders ||= [john_order, jane_order]
  end

  protected

  def punch_article(title = 'sample', descr = 'sample', price = 9.99)
    { 'title' => title, 'description' => descr, 'price' => price }
  end

  def punch_order(user, status = 'new')
    arts = articles.map{|art|
      OrderItem.new(article: art, quantity: 1, price: art.price)
    }
    Order.new(
      user: user,
      created_at: Time.now,
      status: status,
      status_at: Time.now,
      articles: arts
    )
  end
end
