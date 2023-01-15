# MD5 bcfcd093255b49b2a9e8b8921a5148c0
# see https://github.com/nvoynov/punch
require_relative "../../test_helper"
include Orders::Services

describe ManagerRemoveArticle do
  let(:service) { ManagerRemoveArticle }
  let(:payload) { {article_id: @article_id} }

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
