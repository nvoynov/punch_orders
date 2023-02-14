require './app/rack2'
require 'rack'
require_relative '../../test_helper'
require_relative '../../orders/dummy'
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
    Present
  end

  def headers
    {'CONTENT_TYPE' => 'application/json'}
  end

  def test_call
    body = {'title' => 'title', 'description' => '', 'price' => 9.99}
    post('/manager-create-article', JSON.generate(body), headers)
    payload = last_request.env

    article = Dummy.articles.first
    result = JSON.parse(subject.(article, last_request))
    assert_kind_of Hash, result
    assert result['data']

    result = subject.([Dummy.articles, false], last_request)
    result = JSON.parse(result)
    assert_kind_of Hash, result
    assert result['data']
    assert result['links']
  end
end
