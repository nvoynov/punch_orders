# MD5 c939ee893d49cccfd826c7834f176e4b
# see https://github.com/nvoynov/punch
# frozen_string_literal: true
require_relative "../basics"

module Orders
  module Plugins
    # Orders Store
    class Store
      extend Plugin

      Failure = Class.new(StandardError)

      def self.inherited(klass)
        klass.const_set(:Failure, Class.new(klass::Failure))
        super
      end

      def initialize()

      end
    end

  end
end
