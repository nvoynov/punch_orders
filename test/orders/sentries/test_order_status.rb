# MD5 72030d5f02fb6f37710e19b015fe4872
# see https://github.com/nvoynov/punch
require_relative "../../test_helper"

describe MustbeOrderStatus do
  # @todo provide valid and wrong samples here
  let(:proper) { %w|new submitted accepted canceled| }
  let(:faulty) { [nil, 1, "", "faulty", Object.new]  }

  it {
    proper.each{|arg| assert_equal arg, MustbeOrderStatus.(arg) }
    faulty.each{|arg| assert_raises(ArgumentError) { MustbeOrderStatus.(arg) }}
  }
end
