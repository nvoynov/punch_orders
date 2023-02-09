require_relative "../../test_helper"
require_relative "../dummy"
include Orders::Builders

describe OrderBuilder do
  let(:articles) { Dummy.articles }
  let(:orderart) {
    articles.map{|art| {article_id: art.id, quantity: 1, price: 9.99} }
  }
  let(:subject) { OrderBuilder }
  let(:payload) {{
    user_id: Dummy.john.id,
    created_at: Time.now,
    status: 'new',
    status_at: Time.now,
    articles: orderart
  }}

  it {
    john = Dummy.john
    arid = articles.map(&:id)

    # proper payload
    @mock = Minitest::Mock.new
    @mock.expect :get, john, [User, john.id]
    @mock.expect :key?, [true,[]], [Article, *arid]
    @mock.expect :all, articles, [Article], **{id: arid}

    order = OrderBuilder.(Hash[payload], @mock)
    assert order
    assert_equal john, order.user
    assert_equal 3, order.articles.size

    # unknown user
    @mock.expect :get, nil, [User, john.id]
    e = assert_raises(RuntimeError) { OrderBuilder.(Hash[payload], @mock) }
    assert_match "unknown user", e.message

    # unknown article
    @mock.expect :get, john, [User, john.id]
    @mock.expect :key?, [false,['1', '2']], [Article, *arid]
    e = assert_raises(RuntimeError) { OrderBuilder.(Hash[payload], @mock) }
    assert_match "unknown articles", e.message
  }

end
