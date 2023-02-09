require_relative "../../test_helper"
require "./app/bunny"

class TestBunnyFace < Minitest::Test
  def subject
    BunnyFace
  end

  # run the server, publish and consume messages, or build a Mock?
  def test_request_response_cycle
  end
end
