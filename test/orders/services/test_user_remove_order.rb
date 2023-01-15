# MD5 46ab62b8d6d96a65a35a827b57e1e77a
# see https://github.com/nvoynov/punch
require_relative "../../test_helper"
include Orders::Services

describe UserRemoveOrder do
  let(:service) { UserRemoveOrder }
  let(:payload) { {user_id: @user_id, order_id: @order_id} }

  it {
    # there are no plugins implemented at the moment
    # so its behaviour should be stubbded and mocked
    #
    # PluginHolder.object.stub :get, dummy do
    #   assert_equal dummy, service.(**payload)
    # end
    #
    # @mock = Minitest::Mock.new
    # @mock.expect :get, dummy, [User], **payload
    # @mock.expect :put, dummy, [User]
    # PluginHolder.stub :object, @mock do
    #   assert_equal dummy, service.(**payload)
    # end
  }
end
