require_relative "../config"

class ManagerCancelOrderAction < Action
  action :post, "manager-cancel-order"
  origin ManagerCancelOrder

  def arguments
    required = %w|order_id|
    missed!(required)
    kwargs = {}
    order_id = params.fetch('order_id')
    kwarg.store(:order_id, order_id)
    kwargs.compact!
    [[], kwargs, nil]
  end
end

ActionsHolder.object << ManagerCancelOrderAction