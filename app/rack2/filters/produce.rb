require 'rack'
require 'json'
require './lib/orders'
require_relative 'filter'

module Filters

  NotFound404 = Class.new(StandardError)

  # get action and parameters
  class Produce < Filter

    class << self
      # @param payload [Hash] Rack env
      # @return [payload, context] where payload is the result of service call,
      #   and context is Rack::Request that might be helpful to have for some
      #   filters
      def call(payload, context = nil)
        request = Rack::Request.new(payload)
        service = roster.fetch(request.path_info, nil)
        fail NotFound404, request.path_info unless service

        params = {}
        params.merge! Hash[request.params] if request.params.any?
        body = request.body.read
        params.merge! JSON.parse(body) unless body.empty?
        params.transform_keys!(&:to_sym)
        
        params[:page_number] = params[:page_number].to_i if params.key?(:page_number)
        params[:page_size] = params[:page_size].to_i if params.key?(:page_size)

        [service.(**params), request]
      end

      # @return [Hash<name, service>]
      def roster
        @roster ||= begin
          services = Orders::Services
          skipfu = proc{|konst| %i[Service Query].include?(konst)}
          makefu = proc{|konst| [
            '/' + hyphencase(konst.to_s),
            services.const_get(konst)
          ]}
          services.constants
            .reject(&skipfu)
            .map(&makefu)
            .to_h
        end
      end

      def hyphencase(str)
        str
          .split('::').last
          .gsub(/([A-Z]+)([A-Z][a-z])/,'\1-\2')
          .gsub(/([a-z\d])([A-Z])/,'\1-\2')
          .downcase
      end
    end
  end

end
