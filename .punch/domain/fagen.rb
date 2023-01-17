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

  # Face result wrapper
  Response = Struct.new(:data, :meta, :error, keyword_init: true)

  # response helper
  def respond(data: nil, meta: nil, error: nil)
    fail "service must repond with :data ^ :error" unless data.nil? ^ error.nil?
    Response.new(data: data, meta: meta, error: error).freeze
  end

  def secure_call &block
    respond(data: yield)
  rescue ArgumentError, Service::Failure, Store::Failure => e
    logger.error e
    respond(error: e)
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
