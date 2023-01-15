# MD5 105c60197a3c480393d4d2b21bcc45f1
# see https://github.com/nvoynov/punch
require_relative "../../test_helper"

describe MustbePageNumber do
  # @todo provide valid and wrong samples here
  let(:proper) { [0, 1, 25] }
  let(:faulty) { [nil, -1, "", "string", Object.new] }

  it {
    proper.each{|arg| assert_equal arg, MustbePageNumber.(arg) }
    faulty.each{|arg| assert_raises(ArgumentError) { MustbePageNumber.(arg) }}
  }
end
