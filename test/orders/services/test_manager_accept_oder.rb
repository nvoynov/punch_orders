# MD5 76008d31427ca89835f2f861758aec9a
# see https://github.com/nvoynov/punch
require_relative "../../test_helper"
include Orders::Services

describe ManagerAcceptOder do
  let(:service) { ManagerAcceptOder }
  let(:payload) { {order_id: @order_id} }

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
