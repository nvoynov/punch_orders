require_relative "../../test_helper"
require "rack/test"
require 'rack/session'
require "./app/rack"

ENV['RACK_ENV'] = 'test'

def app
  RackFace.new
end
