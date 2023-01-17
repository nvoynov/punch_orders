require 'drb/drb'
require "irb"

uri = ARGV.shift || "druby://localhost:8787"
DRb.start_service

orders = DRbObject.new_with_uri(uri)
IRB.conf[:USE_COLORIZE] = false
IRB.start(__FILE__)
