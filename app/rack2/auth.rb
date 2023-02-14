require "delegate"
require_relative "config"

class UserDecorator < SimpleDelegator
  def user?
    true
  end

  def manager?
    true
  end
end

class Auth
  def initialize(app)
    @app = app
  end

  def user
    @user ||= begin
      store = StoreHolder.object
      UserDecorator.new(
        store.find(User, name: 'John')
      )
    end
  end

  def call(env)
    session = env['rack.session']
    session[:user] = user

    @app.call(env)
  end
end
