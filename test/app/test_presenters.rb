require_relative "../test_helper"
require_relative "../orders/dummy"
require "./app/presenters"

describe 'Presenters' do
  let(:subject) { PresentersHolder.roster }
  let(:article) { Dummy.articles.first }
  let(:order) { Dummy.orders.first }

  it {
    subject.(article).(article)
    subject.(order).(order)
  }
end
