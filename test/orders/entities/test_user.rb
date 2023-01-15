# MD5 929f73c548ee9a2fb73127772e516631
# see https://github.com/nvoynov/punch
require_relative "../../test_helper"
include Orders::Entities

describe User do
  let(:entity) { User.new(name: "Dummy") }

  it {
    assert entity
  }
end
