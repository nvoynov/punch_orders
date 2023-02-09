require_relative "basics"
# when you need replace some holders from domain
# require_relative "./lib/domain/config"
# StoreHolder.plugin Ranch::InMemoryStore

# when yu need logger
# require "logger"
# Logger.extend(Plugin)
# LoggerHolder = Logger.plugin

class Presenters
  extend Plugin

  def initialize
    @store = {}
  end

  def put(arg)
    fail ArgumentError, "must be Presenter" unless arg < Presenter
    @store[arg.presented] = arg
  end
  alias :add :put
  alias :<< :put

  def get(arg)
    klass = arg.is_a?(Class) ? arg : arg.class
    fu = proc{|key, _| arg.is_a?(key) }
    @store.find(&fu)&.last || Presenter
  end
  alias :call :get
end

class Actions
  extend Plugin

  def initialize
    @store = {}
  end

  def put(arg)
    fail ArgumentError, "must be Action" unless arg < Action
    @store[arg.action] = arg
  end
  alias :add :put
  alias :<< :put

  def get(key)
    fu = proc{|k,v| k == key }
    @store.find(&fu)&.last
  end
  alias :call :get
end

ActionsHolder = Actions.plugin
PresentersHolder = Presenters.plugin