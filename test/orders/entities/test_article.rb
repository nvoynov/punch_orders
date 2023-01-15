# MD5 1bbf58e336234c3354743b5ee2654e7d
# see https://github.com/nvoynov/punch
require_relative "../../test_helper"
require "bigdecimal/util"
include Orders::Entities

describe Article do
  let(:entity) { Article.new(
    title: "Title", description: "Decription",
    price: 9.99, removed_at: Time.now)
  }
  let(:faulty) { Article.new(title: "Title", description: "Decription")}

  it {
    assert entity
    assert_raises(ArgumentError) { faulty }
  }
end
