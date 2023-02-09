require "bunny"
require "ranch"
require "bigdecimal/util"
require "./app/bunny"

logger = Logger.new(STDOUT,
  datetime_format: '%Y-%m-%d %H:%M:%S',
  formatter: proc{|severity, datetime, progname, msg|
    "[#{datetime}] #{severity.ljust(5)}: #{msg}\n" })

LoggerHolder.object = logger

# @todo read connection settings from ENV| ARGV
conn = Bunny.new
conn.start
face = BunnyFace.new(conn)

logger.info "~ Orders Message Server"
logger.info "~ Runch::InMemoryStorage v#{Runch::VERSION}"
logger.info "Press Ctrl+c to stop the service"

loop { sleep 5 }
