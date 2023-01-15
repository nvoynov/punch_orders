# MD5 3ec099e1f549c365fa048355cbc13b05
# see https://github.com/nvoynov/punch
require_relative "../../test_helper"

describe MustbePageSize do
  # @todo provide valid and wrong samples here
  let(:proper) { [1, 25] }
  let(:faulty) { [nil, -1, 0, "string", Object.new] }

  it {
    proper.each{|arg| assert_equal arg, MustbePageSize.(arg) }
    faulty.each{|arg| assert_raises(ArgumentError) { MustbePageSize.(arg) }}
  }
end
