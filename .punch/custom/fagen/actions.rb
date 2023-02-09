require_relative "basics"
require_relative "config"

class SomeAction < Action
  handle :get, '/hello'
  origin SomeDomainService

  def arguments
    # override it
  end
end

ActionsHolder.object << SomeAction