# MD5 833bc68f1ad8eb9e69790f278bb5705e
# see https://github.com/nvoynov/punch
require_relative "../../test_helper"
include Orders::Services

describe UserQueryArticles do
  let(:service) { UserQueryArticles }
  let(:payload) { {where: @where, order: @order, page_number: @page_number, page_size: @page_size} }

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
