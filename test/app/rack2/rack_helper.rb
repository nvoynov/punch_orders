require './app/rack2'
require 'rack'
require 'rack/test'
require_relative '../../test_helper'

module RackHelper
  include Rack::Test::Methods

  def headers
    {"content-type" => "application/json"}
  end

  def app
    lambda {|env| [200, headers, [JSON.generate(42)]]}
  end

  def getenv(url, params)
    get(url, params)
    last_request.env
  end

  def putenv(url, params)
    post(url, JSON.generate(params), headers)
    last_request.env
  end

end

# class TestRack < Minitest::Test
#   include RackHelper
#
#   def test_one
#     getenv('/hello', {world: 'world'})
#     putenv('/hello', {world: 'world'})
#   end
# end
