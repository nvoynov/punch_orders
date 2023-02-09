require_relative "rack_helper"
require_relative "../../orders/dummy"

module RackActions
  public_class_method :roster
  def self.<<(actn)
    key = [actn.meth, actn.path]
    roster
    @roster[key] = actn
  end
end

class TestFace < Minitest::Test
  include Rack::Test::Methods
  
  def setup
    session = { user: UserDecorator.new(Dummy.john) }
    env('rack.session', session)
  end

  def test_authorized
    env('rack.session', {})
    get('hello')
    assert_equal 401, last_response.status
    assert_equal "unauthorized access", last_response.body
  end

  def test_404
    get '/unknown-url'
    assert_equal 404, last_response.status
  end

  def test_hello
    actn = Class.new(RackActions::Action) do
      action :get, "hello"
      def self.call(payload)
        "hello"
      end
    end
    RackActions << actn

    get('/hello')
    assert_equal 200, last_response.status
    body = JSON.parse(last_response.body)
    assert_kind_of Hash, body
    assert_equal 'hello', body['data']
  end

  # def test_known_exception
  #   actn = Class.new(Action) do
  #     action :get, "known-exception"
  #     def call
  #       fail ArgumentError, "known exception"
  #     end
  #   end
  #   actions = ActionsHolder.object
  #   actions << actn
  #
  #   get('/known-exception')
  #   assert_equal 422, last_response.status
  #   body = JSON.parse(last_response.body)
  #   assert_equal "known exception", body['error']['message']
  # end

  # @todo how to test how rack handles unknown errors?
  def test_unknown_exception
    actn = Class.new(RackActions::Action) do
      action :get, "unknown-exception"
      def self.call(payload)
        fail "unknown exception"
      end
    end
    RackActions << actn

    get('/unknown-exception')
    assert_equal 500, last_response.status
    assert_match "unknown exception", last_response.errors
  end

  def test_query
    get '/query-articles'
    # pp JSON.parse(last_response.body)
  end
end
