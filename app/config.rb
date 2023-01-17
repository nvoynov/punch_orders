require_relative "gadgets"

module PresentersHolder
  extend self
  
  def roster
    @roster ||= PresenterRoster.new
  end
end
