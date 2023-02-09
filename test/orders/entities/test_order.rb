# MD5 d13eca24ddd152a1d03aba4fd132bd4b
# see https://github.com/nvoynov/punch
require_relative "../../test_helper"
require_relative "../dummy"
require "bigdecimal/util"
require "securerandom"
include Orders::Entities

describe Order do
  let(:user) { Dummy.john }
  let(:articles) { Dummy.articles }

  describe OrderItem do
    it {
      item = OrderItem.new(article: articles.first, quantity: 1, price: 99)
      assert_respond_to item, :article_id
    }
  end

  let(:subject) {
    Order.new(user: user,
      created_at: Time.now,
      status: "new",
      status_at: Time.now,
      articles: [
        OrderItem.new(article: articles[0], quantity: 1, price: 9.99),
        OrderItem.new(article: articles[1], quantity: 1, price: 9.99),
      ]
    )
  }

  it {
    assert subject
  }
end
