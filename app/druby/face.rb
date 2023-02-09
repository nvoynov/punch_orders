require "logger"
require "json"
require_relative "conf"
require_relative "../extras"
include Orders::Services

# "Ruby Face" for Orders Domain
module DRubyFace
  extend self

  def logger=(logger)
    @logger = logger
  end

  def method_missing(symbol, *args, **kwargs, &block)
    serv = roster.fetch(symbol.to_s, nil)
    fail "unknown service :#{symbol}" unless serv
    logger.info "#{symbol}"
    data, meta = serv.(**kwargs)
    respond(data: present(data), meta: meta)
  rescue => e
    logger.error e.message
    logger.error e.backtrace.join ?\n
    respond(error: e.message)
  end

  protected

  # response helper
  def respond(data: nil, meta: nil, error: nil)
    fail "service must repond with :data ^ :error" unless data.nil? ^ error.nil?
    JSON.pretty_generate({}.tap{|res|
      res[:error] = error if error
      res[:data] = data if data
      res[:meta] = meta if meta
    })
  end

  def present(obj)
    return obj.map{present(_1)} if obj.is_a?(Array)
    presenter = presenters.(obj)
    fail "unknown presenter for :#{obj.class}" unless presenter
    presenter.(obj)
  end

  def presenters
    Extras::Presenters
  end

  def service(arg)
    roster.fetch(arg, nil) # NullService?
  end

  def underscore(str)
    str
      .split('::').last
      .gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2')
      .gsub(/([a-z\d])([A-Z])/,'\1_\2')
      .downcase
  end

  # roster of services
  def roster
    @roster ||= Orders::Services.constants.map{|kon|
      const = const_get(kon)
      [underscore(const.to_s), const]
    }.to_h
  end

  # default logger
  def logger
    @logger ||= ::Logger.new(IO::NULL)
  end

end
