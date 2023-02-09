require_relative "../../test_helper"
require_relative "../../orders/dummy"
require "./app/druby"
require "logger"
require "json"

module DRubyFace
  public :logger
  public :roster
  public :respond
  public :present
  public :presenters
  public :service
  public :underscore
end

class TestFace < Minitest::Test
  def face
    DRubyFace
  end

  def test_logger
    assert face.logger
    logger = Logger.new(IO::NULL)
    face.logger = logger
    assert_equal logger, face.logger
  end

  def test_roster
    assert face.roster
    assert_kind_of Hash, face.roster
    numofserv = Orders::Services.constants.size
    assert_equal numofserv, face.roster.size
  end

  def test_respond
    r = face.respond(data: 42)
    assert_kind_of String, r
    h = JSON.parse(r, symbolize_names: true)
    assert h[:data]
    refute h[:error]
    assert_equal 42, h[:data]

    r = face.respond(error: 42)
    h = JSON.parse(r, symbolize_names: true)
    refute h[:data]
    assert h[:error]
    assert_equal 42, h[:error]

    assert_raises(RuntimeError) { face.respond(data: 42, error: 42)}
  end

  def test_present
    assert_raises(RuntimeError) { face.present(nil) }

    article = Dummy.articles.first
    r = face.present(article)
    assert r
    %i[id title description price].each { assert r[_1] }

    order = Dummy.orders.first
    r = face.present(order)
    assert r
    keys = %i[id created_by created_at user_name status status_at articles]
    keys.each{ assert r[_1] }

    r = face.present([article, order])
    assert r
    assert_kind_of Array, r
    assert_equal 2, r.size
  end

  def test_service
    services = %w[manager_create_article manager_accept_order]
    services.each { assert face.service(_1) }
  end

  # the face interface!
  def test_method_missing
    kwargs = {title: 'spec', description: 'spec', price: 9.99}
    r = face.send(:manager_create_article, *[], **kwargs)
    h = JSON.parse(r)
    assert_kind_of Hash, h

    r = face.send(:unknown)
    h = JSON.parse(r, symbolize_names: true)
    assert_kind_of Hash, h
    assert h[:error]
  end
end
