require "rack"
require "json"
require "forwardable"
require_relative "config"
require_relative "actions"
# require_relative "../extras"

class RackFace
  extend Forwardable

  def headers
    { 'content-type' => 'application/json' }
  end

  def auth?(env)
    session = env['rack.session']
    user = session[:user]
    user && (user.user? || user.manager?)
  end

  def call(env)
    return [401, headers, 'unauthorized access'] unless auth?(env)
    req = Rack::Request.new(env)
    act = RackActions.(req.request_method, req.path_info)
    unless act
      err = "unknown action :#{req.request_method}, \"#{req.path_info}\""
      return [404, headers, err]
    end
    status, payload = do_call(env) { act.(req) }
    [status, headers, [payload]]
  end

  def do_call(env, &block)
    data, meta = yield
    payload = {data: present(data)}
    payload[:links] = meta if meta
    [200, payload.to_json]
  rescue => e
    err = { class: "#{e.class}", message: e.message }
    logger = env['rack.errors']
    logger.write "(#{e.class}) #{e.message}"
    logger.write e.backtrace.join ?\n
    [500, {error: err}.to_json]
  end

  def presenters
    Extras::Presenters
  end

  # @todo how pack queries metadata?
  def present(obj)
    return obj.map{present(_1)} if obj.is_a?(Array)
    pres = presenters.(obj)
    return obj unless pres
    pres.(obj)
  end

end
