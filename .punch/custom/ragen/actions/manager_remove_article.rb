require_relative "../config"

class ManagerRemoveArticleAction < Action
  action :post, "manager-remove-article"
  origin ManagerRemoveArticle

  def arguments
    required = %w|article_id|
    missed!(required)
    kwargs = {}
    article_id = params.fetch('article_id')
    kwargs.store(:article_id, article_id)
    kwargs.compact!
    [[], kwargs, nil]
  end
end

ActionsHolder.object << ManagerRemoveArticleAction