# MD5 ec0a8cb02a4695bccf8423dbb5fe3592
# see https://github.com/nvoynov/punch
require_relative "../../test_helper"
include Orders::Services

describe ManagerModifyArticle do
  let(:service) { ManagerModifyArticle }
  let(:payload) { {article_id: @article_id, title: @title, description: @description, price: @price} }

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
