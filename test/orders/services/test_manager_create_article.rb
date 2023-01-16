# MD5 d062b74a43198a68a6fbe9f2df411811
# see https://github.com/nvoynov/punch
require_relative "../../test_helper"
require_relative "../dummy"
include Orders::Services
include Orders::Entities

describe ManagerCreateArticle do
  let(:service) { ManagerCreateArticle }
  let(:article) { Dummy.articles.first }
  let(:payload) { Dummy.druby_book.transform_keys(&:to_sym) }

  it {
    # must fail for faulty arguments
    assert_raises(ArgumentError) { service.() }
    assert_raises(ArgumentError) { service.(faulty: 42) }

    # must store and return new article
    @mock = Minitest::Mock.new
    @mock.expect :find, nil, [Article], **{title: article.title}
    @mock.expect :put, article, [Article]
    StoreHolder.stub :object, @mock do
      assert_equal article, service.(**payload)
    end

    # must fail when article with the same title exist
    StoreHolder.object.stub :find, article do
      assert_raises(service::Failure) { service.(**payload) }
    end
  }
end
