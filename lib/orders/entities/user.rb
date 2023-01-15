# MD5 692a013edb4288b897aff69035b4582f
# see https://github.com/nvoynov/punch
# frozen_string_literal: true
require_relative "../basics"

module Orders
  module Entities
    # 
    class User < Entity
      # @return [Object] User name from Users domain
      attr_reader :name

      def initialize(id: nil, name:)
        super(id)
        @name = name
      end
    end

  end
end
