# MD5 e7e3967c9731dc3deb115e82ac0519d8
# see https://github.com/nvoynov/punch
require_relative "../../test_helper"
include Orders::Plugins

class TestStore < Minitest::Test
  def plugin
    Store.new()
  end

end
