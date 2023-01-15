# MD5 9b6308cabe3bc841b8b1ca7f3b939c42
# see https://github.com/nvoynov/punch
require_relative "../../test_helper"

describe MustbeHash do
  # @todo provide valid and wrong samples here
  let(:proper) { [{}, {:param => :value, foo: 'bar'}] }
  let(:faulty) { [nil, 1, "string", Object.new, []]   }

  it {
    proper.each{|arg| assert_equal arg, MustbeHash.(arg) }
    faulty.each{|arg| assert_raises(ArgumentError) { MustbeHash.(arg) }}
  }
end
