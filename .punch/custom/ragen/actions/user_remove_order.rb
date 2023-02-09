require_relative "../config"

class UserRemoveOrderAction < Action
  action :post, "user-remove-order"
  origin UserRemoveOrder

  def arguments
    required = %w|user_id order_id|
    missed!(required)
    kwargs = {}
    user_id = params.fetch('user_id')
    kwargs.store(:user_id, user_id)
    order_id = params.fetch('order_id')
    kwargs.store(:order_id, order_id)
    kwargs.compact!
    [[], kwargs, nil]
  end
end

ActionsHolder.object << UserRemoveOrderAction