# MD5 d13eca24ddd152a1d03aba4fd132bd4b
# see https://github.com/nvoynov/punch
require_relative "../../test_helper"
require "bigdecimal/util"
require "securerandom"
include Orders::Entities

describe Order do
  let(:articles) {[
    { "title" => "one", "description" => "one", "price" => 9.99 },
    { "title" => "two", "description" => "two", "price" => 9.99 },
  ]}

  let(:entity) {
    Order.new(
      created_by: SecureRandom.uuid,
      created_at: Time.now,
      status: "new",
      status_at: Time.now,
      articles: articles
    )
  }

  it {
    assert entity
  }
end
