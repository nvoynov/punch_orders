require "minitest/autorun"
require "rack/test"
require "json"

ENV['RACK_ENV'] = 'test'

class SmokingTest < Minitest::Test
  include Rack::Test::Methods

  def app
    proc{|env|
      headers = {"content-type" => "application/json"}
      req = Rack::Request.new(env)
      # pp req
      [200, headers, [
        JSON.dump(
          "params" => req.params,
          "body1" => req.body.tap(&:rewind).read,
          "body2" => req.body.tap(&:rewind).read
        )
      ]]
    }
  end

  def test_dummy
    get('/dummy')
    body = JSON.parse(last_response.body)
    assert_equal Hash.new, body['params']
    assert_equal '', body['body1']
    assert_equal '', body['body2']

    get('/dummy', {'a' => 'a', 'b' => 'b'})
    body = JSON.parse(last_response.body)
    assert_equal Hash['a' => 'a', 'b' => 'b'], body['params']
    assert_equal '', body['body1']
    assert_equal '', body['body2']

    # weird behavior params and body are equal
    post('/dummy', {'a' => 'a', 'b' => 'b'})
    body = JSON.parse(last_response.body)
    assert_equal Hash['a' => 'a', 'b' => 'b'], body['params']
    assert_equal 'a=a&b=b', body['body1']
    assert_equal 'a=a&b=b', body['body2']

    # interesting
    headers = {'CONTENT_TYPE' => 'application/json'}
    payload = {'a' => 'a', 'b' => 'b'}
    post('/dummy', payload.to_json, **headers)
    body = JSON.parse(last_response.body)
    assert_equal Hash.new, body['params']
    assert_equal payload, JSON.parse(body['body1'])
    assert_equal payload, JSON.parse(body['body2'])
  end
end
