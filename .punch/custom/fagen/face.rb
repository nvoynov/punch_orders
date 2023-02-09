require_relative "config"
require_relative "actions"
require_relative "presenters"

require "forwardable"

class Face
  extend Forwardable
  def_delegator :LoggerHolder, :object, :logger
  def_delegator :ActionsHolder, :object, :actions
  def_delegator :PresentersHolder, :object, :presenters

  def handle(request)
    action = Actions.(request)
    unless action
      # handle unknown action
    end
    present(action.(request))
  rescue => e
    logger.error e
    present(e)
  end

  def present(obj)
    # JSON.dump(presenters.(obj).(obj))
    presenters.(obj).(obj)
  end
end