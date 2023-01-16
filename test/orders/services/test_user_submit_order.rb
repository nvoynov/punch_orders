# MD5 0c3f17919751db1bf83653884e282b5b
# see https://github.com/nvoynov/punch
require_relative "../../test_helper"
require_relative "../dummy"
include Orders::Services

describe UserSubmitOrder do
  let(:service) { UserSubmitOrder }
  let(:user) { Dummy.john }
  let(:order) { Dummy.john_order }
  let(:payload) { {user_id: user.id, order_id: order.id} }

  it {
    # fails for faulty arguments
    assert_raises(ArgumentError) { service.() }
    assert_raises(ArgumentError) { service.(faulty: 42) }

    # removes order
    @mock = Minitest::Mock.new
    @mock.expect :get, user, [User, user.id]
    @mock.expect :get, order, [Order, order.id]
    @mock.expect :put, order, [Order]
    StoreHolder.stub :object, @mock do
      assert_equal order, service.(**payload)
    end

    # fails when user not found
    @mock.expect :get, nil, [User, user.id]
    StoreHolder.stub :object, @mock do
      assert_raises(service::Failure) { service.(**payload) }
    end

    # fails when order not found
    @mock.expect :get, user, [User, user.id]
    @mock.expect :get, nil, [Order, order.id]
    StoreHolder.stub :object, @mock do
      assert_raises(service::Failure) { service.(**payload) }
    end

    # fails when order belongs to another user
    jane_order = Dummy.jane_order
    @mock.expect :get, user, [User, user.id]
    @mock.expect :get, jane_order, [Order, String]
    StoreHolder.stub :object, @mock do
      assert_raises(service::Failure) { service.(**payload) }
    end
  }
end
