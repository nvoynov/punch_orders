# MD5 79842d1b5848180318e62c2f23e7e331
# see https://github.com/nvoynov/punch
require_relative "../../test_helper"
include Orders::Services

describe ManagerQueryArticles do
  let(:service) { ManagerQueryArticles }
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
