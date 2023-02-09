require_relative "basics"
require_relative "config"

class HashPresenter < Presenter
  present Hash
  def call
    @object.transform_keys(&:to_s)
  end
end

class FailurePresenter < Presenter
  present StandardError
  properties :class, :message
end

presenters = PresentersHolder.object
presenters << FailurePresenter
presenters << HashPresenter