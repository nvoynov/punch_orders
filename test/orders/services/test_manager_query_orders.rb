# MD5 de3d7bec9075a51b06f17f106bbcbbc9
# see https://github.com/nvoynov/punch
require_relative "../../test_helper"
include Orders::Services

describe ManagerQueryOrders do
  let(:service) { ManagerQueryOrders }
  let(:faulty) {[
    { where: {} },
    { order: [] },
    { page_number: -1},
    { page_size: 0 },
  ]}

  it { # it must fail for faulty arguments
    faulty.each{|args| assert_raises(ArgumentError) { service.(**args) } }
  }
end
