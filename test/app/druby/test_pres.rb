require_relative "../../test_helper"
require_relative "../../orders/dummy"
require "./app/druby/pres"

describe 'Presenters' do
  let(:subject) { DecorHolder.object }
  let(:article) { Dummy.articles.first }
  let(:order) { Dummy.orders.first }

  it {
    subject.(article).(article)
    subject.(order).(order)
  }
end
