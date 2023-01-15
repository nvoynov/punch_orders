# MD5 201bf350c78ff48aa6eb5ff58fa7518b
# see https://github.com/nvoynov/punch
require_relative "../../test_helper"
require "securerandom"

describe MustbeUUID do
  # @todo provide valid and wrong samples here
  let(:proper) { [SecureRandom.uuid] }
  let(:faulty) { [nil, 1, "", "3242424aefg-gaggg243", Object.new] }

  it {
    proper.each{|arg| assert_equal arg, MustbeUUID.(arg) }
    faulty.each{|arg| assert_raises(ArgumentError) { MustbeUUID.(arg) }}
  }
end
