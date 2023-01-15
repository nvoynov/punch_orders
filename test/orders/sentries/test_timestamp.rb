# MD5 0da354657e28efad3ac17c5c88dc7fee
# see https://github.com/nvoynov/punch
require_relative "../../test_helper"

describe MustbeTimestamp do
  # @todo provide valid and wrong samples here
  let(:proper) { [Time.now] }
  let(:faulty) { [nil, 1, "string", Object.new] }

  it {
    proper.each{|arg| assert_equal arg, MustbeTimestamp.(arg) }
    faulty.each{|arg| assert_raises(ArgumentError) { MustbeTimestamp.(arg) }}
  }
end
