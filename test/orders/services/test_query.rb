require_relative "../../test_helper"
# include Orders::Services

describe 'Query' do
  let(:dummy) {
    Class.new(Orders::Services::Query) do
      def subject
        Object
      end
    end
  }

  it {
    # empty result
    StoreHolder.object.stub :q, [], [Object] do
      data, more = dummy.()
      assert_equal [], data
      assert_equal false, more
    end

    # less than page_size
    StoreHolder.object.stub :q, [1], [Object] do
      data, more = dummy.(page_number: 0, page_size: 2)
      assert_equal 1, data.size
      assert_equal false, more
    end

    # exactly page_size
    StoreHolder.object.stub :q, [1, 2], [Object] do
      data, more = dummy.(page_number: 0, page_size: 2)
      assert_equal 2, data.size
      assert_equal false, more
    end

    # more than page_size
    StoreHolder.object.stub :q, [1, 2, 3], [Object] do
      data, more = dummy.(page_number: 0, page_size: 2)
      assert_equal 2, data.size
      assert_equal true, more
    end
  }
end
