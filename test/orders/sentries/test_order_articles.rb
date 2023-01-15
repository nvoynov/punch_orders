# MD5 7ddd8cb19080b6b7712a0870d1c049ab
# see https://github.com/nvoynov/punch
require_relative "../../test_helper"

describe MustbeOrderArticles do
  # @todo provide valid and wrong samples here
  let(:proper) {[
    { "id" => "", "title" => "", "description" => "", "price" => 9.99 },
    { "title" => "", "description" => "", "price" => 9.99 },
  ]}
  let(:faulty) {[
    nil, 1, "string", Object.new,
    [{ "id" => "", "title" => "", "description" => ""}]
  ]}

  it {
    assert_equal proper, MustbeOrderArticles.(proper)
    faulty.each{|arg| assert_raises(ArgumentError) { MustbeOrderArticles.(arg) }}
  }
end
