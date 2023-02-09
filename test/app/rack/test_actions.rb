require_relative "rack_helper"
require "bigdecimal/util"
require "stringio"

module RackActions
  public_class_method :roster
end

class TestRackActions < Minitest::Test
  def subject
    RackActions
  end

  def test_roster
    r = subject.roster
    assert_kind_of Hash, r
  end

  def test_find
    %w[user-create-order /user-create-order].each{|path|
      r = subject.find('post', path)
      assert r
      assert r < subject::Action
    }

    %w[query-articles /query-articles].each{|path|
      r = subject.find('get', path)
      assert r
      assert r < subject::Query
    }

    refute subject.find('get', 'unknown')
    refute subject.find('post', 'unknown')
  end

  def test_exec
    payload = {'title' => 'test_action', 'description' => '', 'price' => 9.99}

    action = subject.find('post', 'manager-create-article')
    @mock = Minitest::Mock.new
    @mock.expect :get?, false
    @mock.expect :post?, true
    @mock.expect :params, {}
    @mock.expect :body, StringIO.new.tap{|io| JSON.dump(payload, io); io.rewind}
    art = action.(@mock)
    assert art
    assert_kind_of Orders::Entities::Article, art
    assert_equal 'test_action', art.title
  end
end
