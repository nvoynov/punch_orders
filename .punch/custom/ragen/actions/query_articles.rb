require_relative "../config"

class QueryArticlesAction < Action
  include LinksHelper
  action :get, "query-articles"
  origin QueryArticles

  def arguments
    @page_number = params.fetch('page_number', '0').to_i
    @page_size = params.fetch('page_size', '25').to_i
    where = params.fetch('where', [])
    order = params.fetch('order', {})
    kwargs = {
      where: where,
      order: order,
      page_number: @page_number,
      page_size: @page_size
    }
    [[], kwargs, nil]
  end

  def present(result)
    data, more = result
    [data, links(more)]
  end
end

ActionsHolder.object << QueryArticlesAction