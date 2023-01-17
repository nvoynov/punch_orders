require_relative "presenter"

class PresenterRoster
  def initialize
    @roster = {}
  end

  def <<(arg)
    fail ArgumentError, "must be Presenter" unless arg < Presenter
    @roster[arg.presented] = arg
  end
  alias :add :<<

  def get(arg)
    @roster.fetch(arg.is_a?(Class) ? arg : arg.class, Presenter)
  end
  alias :call :get
end
