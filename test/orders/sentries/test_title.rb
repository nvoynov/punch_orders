# MD5 43894bff4f19908ed277047c9efde59d
# see https://github.com/nvoynov/punch
require_relative "../../test_helper"

describe MustbeTitle do
  # @todo provide valid and wrong samples here
  let(:proper) { ["abc", "string"] }
  let(:faulty) { [nil, 1, "", "ab", Object.new] }

  it {
    proper.each{|arg| assert_equal arg, MustbeTitle.(arg) }
    faulty.each{|arg| assert_raises(ArgumentError) { MustbeTitle.(arg) }}
  }
end
