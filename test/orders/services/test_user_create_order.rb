# MD5 1c895a7ca4377a35a9fd0dbe5782d162
# see https://github.com/nvoynov/punch
require_relative "../../test_helper"
include Orders::Services

describe UserCreateOrder do
  let(:service) { UserCreateOrder }
  let(:payload) { {created_by: @created_by, articles: @articles} }

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
