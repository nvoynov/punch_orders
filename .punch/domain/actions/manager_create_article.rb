require_relative "../config"

class ManagerCreateArticleAction < Action
  action :post, "manager-create-article"
  origin ManagerCreateArticle

  def arguments
    required = %w|title description price|
    missed!(required)
    kwargs = {}
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

ActionsHolder.object << ManagerCreateArticleAction