# MD5 c939ee893d49cccfd826c7834f176e4b
# see https://github.com/nvoynov/punch
# frozen_string_literal: true
require_relative "../basics"

module Orders
  module Plugins

    # Basic storage interface that stores everything respond to :id
    class Store
      extend Plugin

      Failure = Class.new(StandardError)

      def self.inherited(klass)
        klass.const_set(:Failure, Class.new(klass::Failure))
        super
      end

      # Puts object to the storage
      # @param object [Object] to store
      # @return [Object] stored object
      # @todo how about putting multiple objects at once
      def put(object)
        fail "#{self.class}#put(object) must be overridden"
      end

      # Return klass object by id
      # @param klass [Class]
      # @param id [Object]
      # @return [Object] klass object
      def get(klass, id)
        fail "#{self.class}#get(klass, id) must be overridden"
      end

      # Return first klass object matched to criterion
      # @param klass [Class] class to get object of
      # @param criterion [keyword arguments] object matching criterion
      # @return [Object] first object that matches to criterion
      def find(klass, **criterion)
        fail "#{self.class}#get(klass, **criterion) must be overridden"
      end

      # Return collection of object matched to criterion
      # @param klass [Class] class to get objects of
      # @param criterion [keyword arguments] matching criterion
      # @return [Array<klass>] objects matched to criterion
      def all(klass, **criterion)
        fail "#{self.class}#all(klass, **criterion) must be overridden"
      end

      # Removes klass objects matched criterion
      # @param klass [Class] object class to remove of
      # @param criterion [keyword arguments] matching criterion
      # @return [Integer] number of object removed
      def rm(klass, **criterion)
        fail "#{self.class}#rm(klass, **criterion) must be overridden"
      end

      # Find identifiers
      # @param klass [Class] class to get objects of
      # @param keys [*Array] identifiers to check for
      # @return [true, []] when all ids are presented
      # @return [false, [id, id]] when some ids missed
      def key?(klass, *keys)
        fail "#{self.class}#key?(klass, *keys) must be overridden"
      end

      # Query for klass objects
      # @param klass [Class] class to get objects of
      # @param where [Array] array of conditions
      # @param order [Hash] hasf of :param => :asc | :desc
      # @param limit [Integer] number of items to select
      # @param offset [Integer] number of items to skip before select
      # @return [Array<objects>, Hash<metadata>] where metadata is
      #   about navigation and provide :first, :prev, :next, :last
      def q(klass, where: [], order: {}, limit: 0, offset: 50)
        fail "#{self.class}.#q(klass, where:, order:, limit:, offset:) must be overridden"
      end
    end
  end
end
