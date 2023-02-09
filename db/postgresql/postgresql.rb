require "runch"
require_relative "mappers"
require_relative "builders"

class PostgreSql < Runch::SequelPgStore
  mappers Mappers
  builders Builders
end
