require_relative "../../test_helper"
require "./app/bunny"

module Actions
  public_class_method :roster
end

class TestBunnyActions < Minitest::Test
  def subject
    Actions
  end

  def test_roster
    r = subject.roster
    assert_kind_of Hash, r
  end

  def test_find
    %w[user.create.order manager.create.article].each{|actn|
      r = subject.find(actn)
      assert r
      assert r < Actions::Action
    }
    refute subject.('query.articles')
    refute subject.('query.orders')
  end
end
