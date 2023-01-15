# MD5 0c3f17919751db1bf83653884e282b5b
# see https://github.com/nvoynov/punch
require_relative "../../test_helper"
include Orders::Services

describe UserSubmitOrder do
  let(:service) { UserSubmitOrder }
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
