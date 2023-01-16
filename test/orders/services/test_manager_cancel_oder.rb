# MD5 dd94a8d10199f6167381d16d69d4b4fc
# see https://github.com/nvoynov/punch
require_relative "../../test_helper"
require_relative "../dummy"
include Orders::Services

describe ManagerCancelOder do
  let(:service) { ManagerCancelOder }
  let(:order)   { Dummy.john_order }
  let(:payload) { {order_id: order.id} }

  it {
    # fails for faulty arguments
    assert_raises(ArgumentError) { service.() }
    assert_raises(ArgumentError) { service.(faulty: 42) }

    # accepts order
    @mock = Minitest::Mock.new
    @mock.expect :get, order, [Order, order.id]
    @mock.expect :put, order, [Order]
    StoreHolder.stub :object, @mock do
      assert_equal order, service.(**payload)
    end

    # fails for unknown order
    @mock.expect :get, nil, [Order, order.id]
    StoreHolder.stub :object, @mock do
      assert_raises(service::Failure) { service.(**payload) }
    end
  }
end
