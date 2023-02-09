# domain faces generator

require_relative "domain"
require "punch"
require "erb"
include Punch

domain = build_domain
sample = DATA.read
@model = domain.services.map{|m| Factory.decorate(:service, m)}

renderer = ERB.new(sample)
puts renderer.result

__END__
# frozen_string_literal: true

require "logger"
require "./lib/orders"
include Orders::Services

module Face
  extend self

  protected

  def respond(data: nil, meta: nil, error: nil)
    fail "service must repond with :data ^ :error" unless data.nil? ^ error.nil?
    {}.tap{|res|
      res.store("data", data) if data
      res.store("meta", meta) if meta
      res.store("error", error) if error
    }.freeze
  end

  def present(obj)
    presenters = DecorHolder.object
    return obj.map{present(_1)} if obj.is_a?(Array)
    presenters.(obj).(obj)
  end

  def secure_call &block
    data, meta = yield
    respond(data: present(data), meta: meta)
  rescue ArgumentError, Service::Failure, Store::Failure => e
    logger.error e
    respond(error: "(#{e.class}) #{e.message}")
  rescue => e
    logger.error e.full_message
    raise $!
  end

  def logger
    @logger ||= Logger.new(STDOUT,
      datetime_format: '%Y-%m-%d %H:%M:%S',
      formatter: proc{|severity, datetime, progname, msg|
          "[#{datetime}] #{severity.ljust(5)}: #{msg}\n"
    })
  end

  public
  <% @model.each do |model| %>
  def <%= model.name %>(<%= model.parameters %>)
    secure_call {
      logger.info "<%= "call #{model.name}" %>"
      <%= model.const %>.(<%= model.arguments.gsub('@', '')%>)
    }
  end
  <% end %>
end
