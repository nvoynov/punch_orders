# MD5 e838f926dc86c515506ede19743650be
# see https://github.com/nvoynov/punch
require_relative "../../test_helper"

describe MustbeArray do
  # @todo provide valid and wrong samples here
  let(:proper) { [[], [1, "string", Object.new]] }
  let(:faulty) { [nil, 1, "string", Object.new]  }

  it {
    proper.each{|arg| assert_equal arg, MustbeArray.(arg) }
    faulty.each{|arg| assert_raises(ArgumentError) { MustbeArray.(arg) }}
  }
end
