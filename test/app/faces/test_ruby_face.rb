require_relative "../../test_helper"
include Faces

module Ruby
  public :respond, :secure_call
end

class TestRubyFace < Minitest::Test
  def face
    Ruby
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
    proper = proc{|args| secure_call { {'data' => 42} } }
    faulty = proc{|args| secure_call { fail ArgumentError, "42" } }
    unrescued = proc{|args| secure_call { fail "42" } }
    face.define_singleton_method(:proper, &proper)
    face.define_singleton_method(:faulty, &faulty)
    face.define_singleton_method(:unrescued, &unrescued)
    #
    # a = face.proper(42)
    # pp a
    # assert_equal 42, a['data']
    #
    # b = face.faulty(42)
    # assert_equal "42", b['error']
    #
    # assert_raises(RuntimeError) { face.unrescued(42) }
  end
end
