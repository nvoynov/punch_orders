require './app/rack2'
require_relative '../../test_helper'
include Filters

class TestAuthorize < Minitest::Test
  def subject
    Authorize
  end

  def test_call
    user = Minitest::Mock.new
    user.expect :name, 'Bob'
    user.expect :user?, true
    user.expect :manager?, true
    payload = { 'rack.session' => {user: user} }
    assert subject.(payload)

    user = Minitest::Mock.new
    user.expect :name, 'Bob'
    user.expect :user?, false
    user.expect :manager?, false
    payload = { 'rack.session' => {user: user} }
    assert_raises(UnauthorizedAccess401) { subject.(payload) }
  end
end
