require "rack"
require 'rack/session'
require "./app/rack"

# https://stackoverflow.com/questions/2239240/use-rackcommonlogger-in-sinatra
# class MyLoggerMiddleware
#   def initialize(app, logger)
#     @app, @logger = app, logger
#   end
#
#   def call(env)
#     env['mylogger'] = @logger
#     @app.call(env)
#   end
# end
# logger = Logger.new('log/app.log')
# use Rack::CommonLogger, logger
# use MyLoggerMiddleware, logger
# run MyApp

app = Rack::Builder.new do
  use Rack::CommonLogger
  use Rack::Reloader # it reloads only reqired files, app/rack.rb in the case
  use Rack::ShowExceptions
  use Rack::Session::Cookie,
    :domain => 'orders.com',
    :path => '/',
    :expire_after => 3600*24,
    :secret => '900150983cd24fb0d6963f7d28e17f72900150983cd24fb0d6963f7d28e17f72'

  use Auth # mock authentication

  map "/face" do
    # use Rack::Lint
    run RackFace.new
  end
end

run app
# run App.new
