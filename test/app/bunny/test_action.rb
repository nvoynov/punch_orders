require_relative "../../test_helper"
require "./app/bunny"

class TestBunnyAction < Minitest::Test
  def subject
    Actions::Action
  end

  def test_class_methods
    assert_respond_to subject, :handle
    assert_respond_to subject, :origin
    assert_respond_to subject, :action
  end

  def test_dummy
    origin = Class.new() do
      def self.call(param:, value:)
        "param: #{param}, value: #{value}"
      end
    end
    action = Class.new(subject) do
      handle 'dummy'
      origin origin
    end

    assert_equal 'param: a, value: 42', action.(param: 'a', value: 42)
  end
end
