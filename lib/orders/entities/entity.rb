# frozen_string_literal: true
require_relative "../basics"
require_relative "../sentries"

module Orders
  module Entities

    # Entity of Orders domain
    class Entity < Punch::Entity

      # clone entity with changed attributes
      def clone_with(**params)
        faulty = params.keys.reject{|k| self.respond_to?(k)}
        fail ArgumentError, "unknown keys: #{faulty}" if faulty.any?
        self.clone.tap{|klone|
          params.each{|key, val|
            klone.instance_variable_set("@#{key}".to_sym, val)
          }
        }
      end
    end

  end
end
