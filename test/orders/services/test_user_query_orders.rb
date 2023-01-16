# MD5 5da2ce1b5cbb161a717b6ff64f0cff00
# see https://github.com/nvoynov/punch
require_relative "../../test_helper"
require_relative "../dummy"
include Orders::Services

describe UserQueryOrders do
  let(:service) { UserQueryOrders }
  let(:user) { Dummy.john }
  let(:payload) { { user_id: user.id} }
  let(:faulty) {[
    { where: {} },
    { order: [] },
    { page_number: -1},
    { page_size: 0 },
  ]}

  it {
    # fails for faulty arguments
    faulty.each{|args| assert_raises(ArgumentError) { service.(**args) } }

    # returns user orders
    kwarg = {
      where: [[:user_id, :eq, user.id]],
      order: {},
      page_number: 0,
      page_size: 25
    }
    @mock = Minitest::Mock.new
    @mock.expect :get, user, [User, user.id]
    @mock.expect :q, [], [Order], **kwarg
    StoreHolder.stub :object, @mock do
      assert_equal [], service.(**payload)
    end

    # fails for unknown user
    @mock.expect :get, nil, [User, user.id]
    StoreHolder.stub :object, @mock do
      assert_raises(service::Failure) { service.(**payload) }
    end
  }
end
