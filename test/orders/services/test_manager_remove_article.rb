# MD5 bcfcd093255b49b2a9e8b8921a5148c0
# see https://github.com/nvoynov/punch
require_relative "../../test_helper"
require_relative "../dummy"
include Orders::Services

describe ManagerRemoveArticle do
  let(:service) { ManagerRemoveArticle }
  let(:article) { Dummy.articles.first }
  let(:payload) { { article_id: article.id } }

  it {
    # must fail for faulty arguments
    assert_raises(ArgumentError) { service.() }
    assert_raises(ArgumentError) { service.(faulty: 42) }

    # it must modify
    @mock = Minitest::Mock.new
    @mock.expect :get, article, [Article, article.id]
    @mock.expect :rm, 1, [Article], **{id: article.id}
    StoreHolder.stub :object, @mock do
      assert_equal 1, service.(**payload)
    end

    # it must fail when not found
    StoreHolder.object.stub :get, nil do
      assert_raises(service::Failure) { service.(**payload) }
    end
  }
end
