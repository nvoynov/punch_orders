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
  let(:orderart) {[
    { "article" => articles.first, "quantity" => 1, "price" => 9.99 },
    { "article" => articles.last,  "quantity" => 1, "price" => 9.99 },
  ]}

  let(:entity) {
    Order.new(user: user,
      created_at: Time.now,
      status: "new",
      status_at: Time.now,
      articles: orderart
    )
  }

  it {
    assert entity
  }
end
