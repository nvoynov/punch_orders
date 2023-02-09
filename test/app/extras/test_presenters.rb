require_relative "../../test_helper"
require_relative "../../orders/dummy"
require "./app/extras"

describe Extras::Presenters do
  let(:subject) { Extras::Presenters }
  let(:article) { Dummy.articles.first }
  let(:order) { Dummy.orders.first }

  it {
    assert subject.find(article)
    assert subject.find(order)
    refute subject.find(42)
    # require 'json'
    # puts JSON.pretty_generate(subject.(article).(article))
    # puts JSON.pretty_generate(subject.(order).(order))
  }
end
