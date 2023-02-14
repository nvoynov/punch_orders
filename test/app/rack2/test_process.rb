require './app/rack2'
require 'rack'
require_relative '../../test_helper'
include Filters
require 'rack/test'
require 'bigdecimal/util'
ENV['RACK_ENV'] = 'test'

class TestProcess < Minitest::Test
  include Rack::Test::Methods

  def app
    lambda {|env|
      headers = {"content-type" => "application/json"}
      request = Rack::Request.new(env)
      # pp request
      [200, headers, [JSON.generate(request)]]
    }
  end

  def subject
    Produce
  end
  #
  # def test_env_get(url, params)
  # end
  #
  # def test_env_post(url, body)
  # end

  def headers
    {'CONTENT_TYPE' => 'application/json'}
  end

  def test_call
    body = {'title' => 'title', 'description' => '', 'price' => 9.99}
    post('/manager-create-article', JSON.generate(body), headers)
    payload = last_request.env

    payload, context = subject.(payload)
    assert_kind_of Orders::Entities::Article, payload

    # body = {'title' => 'title', 'description' => '', 'price' => 9.99}
    post('/query-articles', JSON.generate({}), headers)
    payload = last_request.env

    payload, context = subject.(payload)
    assert_kind_of Array, payload
    assert_kind_of Array, payload.first
  end
end
