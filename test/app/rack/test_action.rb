require_relative "rack_helper"
require "stringio"
require "json"
include RackActions

class Action
  public_class_method :new
end


class TestRackAction < Minitest::Test
  def subject
    Action
  end

  def test_face
    assert_respond_to subject, :origin
    assert_respond_to subject, :action
    assert_respond_to subject, :meth
    assert_respond_to subject, :path
  end

  def test_class_action
    dummy = Class.new(subject) do
      action :get, 'hello'
    end
    assert_equal :get, dummy.meth
    assert_equal 'hello', dummy.path
  end

  def test_params
    params = {'a' => 'a', 'b' => 'b'}
    body = StringIO.new.tap{|io| JSON.dump(params, io); io.rewind}
    mock = Minitest::Mock.new
    mock.expect :params, params
    mock.expect :get?, true
    mock.expect :post?, false
    mock.expect :put?, false
    mock.expect :patch?, false
    act = Action.new(mock)
    assert_equal params.transform_keys(&:to_sym), act.params

    mock = Minitest::Mock.new
    mock.expect :params, {}
    mock.expect :get?, false
    mock.expect :post?, true
    mock.expect :put?, false
    mock.expect :patch?, false
    mock.expect :body, body
    act = Action.new(mock)
    assert_equal params.transform_keys(&:to_sym), act.params
  end

end
