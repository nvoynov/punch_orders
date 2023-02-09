# MD5 1c895a7ca4377a35a9fd0dbe5782d162
# see https://github.com/nvoynov/punch
require_relative "../../test_helper"
require_relative "../dummy"
include Orders::Services

# what to test here, when OrderBuilder actually does the job?
# arguments checks, RuntimeError?
describe UserCreateOrder do
  let(:articles) { Dummy.articles }
  let(:orderart) {
    articles.map{|art|
      {'article_id' => art.id, 'quantity' => 1, 'price' => 9.99}
    }
  }
  let(:subject) { UserCreateOrder }
  let(:payload) { {user_id: Dummy.john.id, articles: orderart} }
  let(:order) { Dummy.john_order }

  it {
    # fails for foulty arguments
    assert_raises(ArgumentError) { subject.() }
    assert_raises(ArgumentError) { subject.(user_id: 1, articles: []) }

    john = Dummy.john
    arid = articles.map(&:id)

    # proper payload
    @mock = Minitest::Mock.new
    @mock.expect :get, john, [User, john.id]
    @mock.expect :key?, [true,[]], [Article, *arid]
    @mock.expect :all, articles, [Article], **{id: arid}
    @mock.expect :put, order, [Order]
    StoreHolder.stub :object, @mock do
      assert_equal order, subject.(**Hash[payload])
    end

    # fails when user not found
    @mock.expect :get, nil, [User, john.id]
    StoreHolder.stub :object, @mock do
      assert_raises(RuntimeError) { subject.(**Hash[payload]) }
    end

    # fails when article not found
    @mock.expect :get, john, [User, john.id]
    @mock.expect :key?, [false,['1', '2']], [Article, *arid]
    StoreHolder.stub :object, @mock do
      assert_raises(RuntimeError) { subject.(**Hash[payload]) }
    end
  }
end
