# dRuby Orders Domain Face

require "drb/drb"
require "logger"
require "bigdecimal/util"
require "./app/druby"

# The URI for the server to connect to
uri = ARGV.shift || "druby://localhost:8787"

DRubyFace.logger = Logger.new(STDOUT,
  datetime_format: '%Y-%m-%d %H:%M:%S',
  formatter: proc{|severity, datetime, progname, msg|
    "[#{datetime}] #{severity.ljust(5)}: #{msg}\n" })

store = StoreHolder.object
john = store.find(Orders::Entities::User, name: 'John')
puts <<~EOF
  ~ Orders Domain dRuby Face started
  ~ URI #{uri}
  ~ Runch::InMemoryStorage v#{Runch::VERSION}
  ~ John's Id: #{john.id}
  Press Ctrl+c to stop the service
EOF

DRb.start_service(uri, DRubyFace)
DRb.thread.join
