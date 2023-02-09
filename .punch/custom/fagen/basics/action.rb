# frozen_string_literal: true
require_relative "proxy"

class Action < Proxy
  class << self
    def handle(arg)
      # fail "faulty handle" unless arg.is_a?(Hash)
      @action = arg
    end

    def action
      @action
    end
  end

  def initialize(request)
    @request = request
  end
end