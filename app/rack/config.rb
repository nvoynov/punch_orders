require_relative "../extras"
require "./lib/orders"
require "runch"
include Orders::Services
include Runch

StoreHolder.plugin InMemoryStore
# require "./db/postgresql/postgresql"
# PostgreSql.extend(Plugin)
# StoreHolder.plugin PostgreSql
