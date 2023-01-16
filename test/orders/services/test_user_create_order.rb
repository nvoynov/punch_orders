# MD5 1c895a7ca4377a35a9fd0dbe5782d162
# see https://github.com/nvoynov/punch
require_relative "../../test_helper"
require_relative "../dummy"
include Orders::Services

describe UserCreateOrder do
  let(:service) { UserCreateOrder }
  let(:article) { Dummy.articles.first }
  let(:user) { Dummy.john }
  let(:order) { Dummy.john_order }
  let(:payload) { {created_by: user.id, articles: Dummy.order_articles} }

  it {
    # fails for foulty arguments
    assert_raises(ArgumentError) { service.() }
    assert_raises(ArgumentError) { service.(created_by: 1, articles: []) }

    # creates new order
    @mock = Minitest::Mock.new
    @mock.expect :get, user, [User, user.id]
    @mock.expect :get, article, [Article, article.id]
    @mock.expect :put, order, [Order]
    StoreHolder.stub :object, @mock do
      assert_equal order, service.(**payload)
    end

    # fails when user not found
    @mock.expect :get, nil, [User, user.id]
    StoreHolder.stub :object, @mock do
      assert_raises(service::Failure) { service.(**payload) }
    end

    # fails when article not found
    @mock.expect :get, user, [User, user.id]
    @mock.expect :get, nil, [Article, article.id]
    StoreHolder.stub :object, @mock do
      assert_raises(service::Failure) { service.(**payload) }
    end
  }
end
