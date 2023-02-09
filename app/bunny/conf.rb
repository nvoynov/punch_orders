require "./lib/orders"
require "runch"
require "logger"
include Runch

StoreHolder.plugin InMemoryStore
# require "./db/postgresql/postgresql"
# PostgreSql.extend(Plugin)
# StoreHolder.plugin PostgreSql

Logger.extend(Plugin)
LoggerHolder = Logger.plugin
