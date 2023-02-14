require 'json'
require_relative 'filter'
require_relative '../../extras'

module Filters

  # NotFound404 = Class.new(StandardError)
  Links = Struct.new(:page_number, :page_size, :this, :first, :prev, :next)

  # get action and parameters
  class Present < Filter
    class << self
      # @param paylaad [Object|Array<>]
      def call(payload, context)
        data, meta = payload
        result = {data: present_data(data)}
        result.merge!({links: present_links(meta, context)}) unless meta.nil?
        JSON.generate(result)
      end

      # @return [Hash<name, service>]
      def roster
        @roster ||=
          Extras::Presenters.constants.map{|kon|
            const = Extras::Presenters.const_get(kon)
            [const.klass, const]
          }.to_h
      end

      def present_data(data)
        subject = (data.is_a?(Array) ? data.first : data).class
        presenter = roster.fetch(subject, nil)
        fail "Unknown presenter for #{subject}" unless presenter
        data.is_a?(Array) ? data.map{presenter.(_1)} : presenter.(data)
      end

      # @todo how to pass request and params?
      def present_links(more, context)
        page_number = context.params['page_number']&.to_i || 0
        page_size = context.params['page_size']&.to_i || 25
        ptrn = "#{context.server_name}#{context.path_info}?page_number=%i?page_size=#{page_size}"
        Links.new(page_number, page_size).tap{|links|
          links.first= ptrn % 0
          links.this = ptrn % page_number
          links.prev = ptrn % (page_number - 1) if page_number > 0
          links.next = ptrn % (page_number + 1) if more
        }.to_h.reject{|_,v| v.nil?}
      end

    end
  end

end
