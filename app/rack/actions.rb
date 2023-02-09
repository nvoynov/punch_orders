# frozen_string_literal: true
require_relative "config"
require_relative "links_mixin"

module RackActions
  class << self
    def find(meth, path)
      args = [
        meth.downcase.to_sym,
        path.start_with?('/') ? path[1..-1] : path
      ]
      roster.fetch(args, nil)
    end
    alias :call :find

    protected
    def roster
      # @todo behold the difference between Service and Query :)
      @roster ||= begin
        source = Orders::Services
        constf = proc{|arg| source.const_get(arg)}
        basics = proc{|arg| %i[Service Query].include?(arg)}
        consts = source.constants.reject(&basics).map(&constf)

        [].tap{|roster|
          consts.each{|kon|
            path = hyphencase(kon.name)
            meth, klass = if kon < Orders::Services::Query
              [:get, Query]
            elsif kon < Orders::Services::Service
              [:post, Action]
            else
              fail "unknown #{kon}"
            end
            roster << [[meth, path],
              Class.new(klass) do
                action meth, path
                origin kon
              end
            ]
          }
        }.to_h
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

  # Action serves sort as a proxy for domain service
  class Action < ProxyCall
    class << self
      def action(meth, path)
        @meth = meth
        @path = path
      end

      def meth
        @meth
      end

      def path
        @path
      end
    end

    def initialize(request)
      @request = request
    end

    def arguments
       [[], params, nil]
    end

    def params
      @params ||= {}.tap{|para|
        para.merge! @request.params if @request.get?
        para.merge! JSON.parse(@request.body.read) if body?
      }.transform_keys(&:to_sym)
    end

    def body?
      %i[post? put? patch?].any?{|m| @request.send(m)}
    end
  end

  # class ManagerAcceptOrderAction < Action
  #   action :post, "manager-accept-order"
  #   origin ManagerAcceptOrder
  #
  #   def arguments
  #     required = %w|order_id|
  #     missed!(required)
  #     kwargs = {}
  #     order_id = params.fetch('order_id')
  #     kwargs.store(:order_id, order_id)
  #     kwargs.compact!
  #     [[], kwargs, nil]
  #   end
  # end

  # Query differs from Action by mixing links
  class Query < Action
    include LinksMixin

    def present(result)
      data, more = result
      [data, links(more)]
    end
  end

  # class QueryArticlesAction < Action
  #   include LinksMixin
  #   action :get, "query-articles"
  #   origin QueryArticles
  #
  #   def arguments
  #     @page_number = params.fetch('page_number', '0').to_i
  #     @page_size = params.fetch('page_size', '25').to_i
  #     where = params.fetch('where', [])
  #     order = params.fetch('order', {})
  #     kwargs = {
  #       where: where,
  #       order: order,
  #       page_number: @page_number,
  #       page_size: @page_size
  #     }
  #     [[], kwargs, nil]
  #   end
  #
  #   def present(result)
  #     data, more = result
  #     [data, links(more)]
  #   end
  # end

end
