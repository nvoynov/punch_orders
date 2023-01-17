# dRuby Orders Domain Face

require "drb/drb"
require "logger"
require "ranch"
require "./lib/orders"
require "./app/faces"

# The URI for the server to connect to
uri = ARGV.shift || "druby://localhost:8787"

logger = Logger.new(STDOUT,
  datetime_format: '%Y-%m-%d %H:%M:%S',
  formatter: proc{|severity, datetime, progname, msg|
      "[#{datetime}] #{severity.ljust(5)}: #{msg}\n"
})

StoreHolder.plugin Ranch::InMemoryStore
require "./app/seed"
Faces::Ruby.logger = logger
puts <<~EOF
  ~ Orders Domain dRuby Face started
  ~ URI #{uri}
  ~ Runch::InMemoryStorage v#{Ranch::VERSION}
  Press Ctrl+c to stop the service
EOF

DRb.start_service(uri, Faces::Ruby)
DRb.thread.join
