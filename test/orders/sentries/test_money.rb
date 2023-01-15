# MD5 3cbf31b03b4c3fce29098f9d32fc5c50
# see https://github.com/nvoynov/punch
require_relative "../../test_helper"
require "bigdecimal/util"

describe MustbeMoney do
  # @todo provide valid and wrong samples here
  let(:proper) { [0, 1, 25.5, BigDecimal("99.99", 3)] }
  let(:faulty) { [Object.new] } # nil -> 0.0, "string" -> "0.0"

  it {
    proper.each{|arg| assert_equal arg, MustbeMoney.(arg) }
    faulty.each{|arg| assert_raises(ArgumentError) { MustbeMoney.(arg) } }
  }
end
