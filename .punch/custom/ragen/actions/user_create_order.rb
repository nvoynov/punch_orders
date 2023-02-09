require_relative "../config"

class UserCreateOrderAction < Action
  action :post, "user-create-order"
  origin UserCreateOrder

  def arguments
    required = %w|user_id articles|
    missed!(required)
    kwargs = {}
    user_id = params.fetch('user_id')
    kwargs.store(:user_id, user_id)
    articles = params.fetch('articles')
    # articles = coerce('order_articles', articles)
    kwargs.store(:articles, articles)
    kwargs.compact!
    [[], kwargs, nil]
  end
end

ActionsHolder.object << UserCreateOrderAction