# frozen_string_literal: true
require_relative "../basics"
require_relative "../config"
require_relative "../sentries"
require_relative "../entities"
require_relative "../builders"
require "forwardable"
include Orders::Entities
include Orders::Builders

module Orders
  module Services

    # Orderd domain service
    class Service < Punch::Service
      extend Forwardable
      def_delegator :StoreHolder, :object, :store
    end

  end
end
