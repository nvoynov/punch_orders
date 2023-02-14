require 'rack'
require 'json'
require 'rack/test'
ENV['RACK_ENV'] = 'test'
require_relative "../../test_helper"

class TestParams < Minitest::Test
  include Rack::Test::Methods

  def app
    lambda {|env|
      headers = {"content-type" => "application/json"}
      request = Rack::Request.new(env)
      params = {}.tap{|para|
        para.merge! request.params if request.params.any?
        body = request.body.read
        para.merge! JSON.parse(body) unless body.empty?
      }
      [200, headers, [JSON.generate(params)]]
    }
  end

  def headers
    {'CONTENT_TYPE' => 'application/json'}
  end

  def payload
    {param: 'a', value: 'b'}
  end

  def test_get
    get('/hello', payload)
    body = JSON.parse(last_response.body, symbolize_names: true)
    assert_kind_of Hash, body
    assert_equal payload, body
  end

  def test_post
    post('/hello', JSON.generate(payload), headers)
    body = JSON.parse(last_response.body, symbolize_names: true)
    assert_kind_of Hash, body
    assert_equal payload, body
  end

end
