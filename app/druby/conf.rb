require "ranch"
require "./lib/orders"
include Ranch

class DecorRoster < PresenterRoster
  extend Plugin
end

StoreHolder.plugin InMemoryStore
DecorHolder = DecorRoster.plugin
