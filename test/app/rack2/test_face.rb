require_relative 'rack_helper'
require 'rack/session'
require './app/rack2/face2'

class TestFace < Minitest::Test
  include RackHelper

  def app
    Rack::Builder.new do
      use Auth # mock authentication
      map "/" do
        run face
      end
    end
  end

  def test_face
    env('rack.session', {})
    payload = {'title' => 'spec', 'description' => '', 'price' => 9.99}
    post('/manager-create-article', JSON.generate(payload),
         'CONTENT_TYPE' => 'application/json')
    body = JSON.parse(last_response.body)
    assert_kind_of Hash, body
    assert body['data']
    refute body['links']

    payload = {'page_number' => 0, 'page_size' => 3}
    get('/query-articles', payload)
    body = JSON.parse(last_response.body)
    assert_kind_of Hash, body
    assert body['data']
    assert body['links']
  end

end
