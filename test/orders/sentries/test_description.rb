# MD5 d6191c6a2974041a1833b3320ed9c696
# see https://github.com/nvoynov/punch
require_relative "../../test_helper"

describe MustbeDescription do
  # @todo provide valid and wrong samples here
  let(:proper) { ["", "string"] }
  let(:faulty) { [nil, 1, Object.new] }

  it {
    proper.each{|arg| assert_equal arg, MustbeDescription.(arg) }
    faulty.each{|arg| assert_raises(ArgumentError) { MustbeDescription.(arg) }}
  }
end
