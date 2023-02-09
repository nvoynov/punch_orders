require_relative "../config"

class ManagerModifyArticleAction < Action
  action :post, "manager-modify-article"
  origin ManagerModifyArticle

  def arguments
    required = %w|article_id title description price|
    missed!(required)
    kwargs = {}
    article_id = params.fetch('article_id')
    kwarg.store(:article_id, article_id)
    title = params.fetch('title')
    # title = coerce('title', title)
    kwarg.store(:title, title)
    description = params.fetch('description')
    # description = coerce('description', description)
    kwarg.store(:description, description)
    price = params.fetch('price')
    # price = coerce('money', price)
    kwarg.store(:price, price)
    kwargs.compact!
    [[], kwargs, nil]
  end
end

ActionsHolder.object << ManagerModifyArticleAction