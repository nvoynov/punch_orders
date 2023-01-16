# MD5 ec0a8cb02a4695bccf8423dbb5fe3592
# see https://github.com/nvoynov/punch
require_relative "../../test_helper"
require_relative "../dummy"
include Orders::Services
include Orders::Entities

describe ManagerModifyArticle do
  let(:service) { ManagerModifyArticle }
  let(:article) { Dummy.articles.first }
  let(:payload) {
    Dummy.druby_book
      .transform_keys(&:to_sym)
      .merge(article_id: article.id)
  }

  it {
    # must fail for faulty arguments
    assert_raises(ArgumentError) { service.() }
    assert_raises(ArgumentError) { service.(faulty: 42) }

    # it must modify
    @mock = Minitest::Mock.new
    @mock.expect :get, article, [Article, article.id]
    @mock.expect :put, article, [Article]
    StoreHolder.stub :object, @mock do
      assert_equal article, service.(**payload)
    end

    # it must fail when not found
    StoreHolder.object.stub :get, nil do
      assert_raises(service::Failure) { service.(**payload) }
    end
  }
end
