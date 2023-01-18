require_relative "../../test_helper"
require_relative "../../orders/dummy"
require "./app/druby"

module Face
  public :respond, :secure_call
end

class TestRubyFace < Minitest::Test
  def face
    Face
  end

  def test_response
    a = face.respond(data: 42)
    assert a.frozen?
    assert a['data']
    refute a['error']
    assert_equal 42, a['data']

    b = face.respond(error: 42)
    assert b.frozen?
    refute b['data']
    assert b['error']
    assert_equal 42, b['error']

    assert_raises(RuntimeError) { face.respond(data: 42, error: 42)}
  end

  def test_secure_call
    sample = { "data" => { "type" => "nilclass" } }
    assert_equal sample, face.secure_call {}

    sample = { "data" => { "type" => "integer"} }
    assert_equal sample, face.secure_call { 42 }
    assert_equal sample, face.secure_call { [42] }

    sample = { "data" => { "type" => "integer"}, "meta" => 42}
    assert_equal sample, face.secure_call { [42, 42] }

    sample = { "data" => { "type" => "integer"}, "meta" => 42}
    assert_equal sample, face.secure_call { [42, 42, 42] }

    hsh = face.secure_call { fail ArgumentError, "42" }
    assert hsh.fetch('error')

    assert_raises(RuntimeError) {
      face.secure_call { fail "unknown exception" }
    }

    face.secure_call { [Dummy.articles, false] }
    face.query_articles

  end
end
