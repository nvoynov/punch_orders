# MD5 d062b74a43198a68a6fbe9f2df411811
# see https://github.com/nvoynov/punch
require_relative "../../test_helper"
include Orders::Services

describe ManagerCreateArticle do
  let(:service) { ManagerCreateArticle }
  let(:payload) { {title: @title, description: @description, price: @price} }

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
