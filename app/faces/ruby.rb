# frozen_string_literal: true

require "bigdecimal/util"
require "logger"
require "./lib/orders"
require_relative "../presenters"
include Orders::Services

module Faces

  # simply ruby interface for dRuby
  module Ruby
    extend self

    protected

    # response helper
    def respond(data: nil, meta: nil, error: nil)
      fail "service must repond with :data ^ :error" unless data.nil? ^ error.nil?
      {}.tap{|res|
        res.store("data", data) if data
        res.store("meta", meta) if meta
        res.store("error", error) if error
      }.freeze
    end

    def present(obj)
      return @presenter.(obj) unless obj.is_a?(Array)
      obj.map{ present(_1) }
    end

    # @example
    #   secure_call {
    #      logger.info "some call"
    #      payload = serice.()
    #      [payload, nil]
    #   }
    def secure_call &block
      data, meta = yield
      logger.info present(data)
      respond(data: present(data), meta: meta)
    rescue ArgumentError, Service::Failure, Store::Failure => e
      logger.error e
      respond(error: "(#{e.class}) #{e.message}")
    rescue => e
      logger.error e.full_message
    end

    def session
      @session ||= {}
    end

    def logger
      @logger ||= Logger.new(IO::NULL,
        datetime_format: '%Y-%m-%d %H:%M:%S',
        formatter: proc{|severity, datetime, progname, msg|
          "[#{datetime}] #{severity.ljust(5)}: #{msg}\n"
      })
    end

    public

    def logger=(logger)
      @logger = logger
    end

    def initialize
      @presenter = PresenterRegistry.new
    end

    def query_articles(where: [], order: {}, page_number: 0, page_size: 25)
      secure_call {
        logger.info "call query_articles"
        data, meta = QueryArticles.(
          where: where, order: order,
          page_number: page_number,
          page_size: page_size)
        [data, meta]
      }
    end

    def query_orders(where: [], order: {}, page_number: 0, page_size: 25)
      # where to gen user_id from? Session required!
      secure_call {
        logger.info "call user_query_orders"
        data, meta = QueryOrders.(
          where: where, # @todo patch where with [:user_id, :eq, user_id]
          order: order,
          page_number: page_number,
          page_size: page_size)
        [data, meta]
      }
    end

    def user_create_order(user_id:, articles:)
      secure_call {
        logger.info "call user_create_order"
        data = UserCreateOrder.(user_id: user_id, articles: articles)
        [data]
      }
    end

    # @todo get user_id form session
    # @todo face shoud be jsust user_remove_order(order_id)
    def user_remove_order(user_id:, order_id:)
      secure_call {
        logger.info "call user_remove_order"
        data = UserRemoveOrder.(user_id: user_id, order_id: order_id)
        [data]
      }
    end

    def user_submit_order(user_id:, order_id:)
      secure_call {
        logger.info "call user_submit_order"
        data = UserSubmitOrder.(user_id: user_id, order_id: order_id)
        [data]
      }
    end

    def manager_create_article(title:, description:, price:)
      secure_call {
        logger.info "call manager_create_article"
        data = ManagerCreateArticle.(title: title, description: description, price: price)
        [data]
      }
    end

    def manager_modify_article(article_id:, title:, description:, price:)
      secure_call {
        logger.info "call manager_modify_article"
        data = ManagerModifyArticle.(article_id: article_id, title: title, description: description, price: price)
        [data]
      }
    end

    def manager_remove_article(article_id:)
      secure_call {
        logger.info "call manager_remove_article"
        data = ManagerRemoveArticle.(article_id: article_id)
        [data]
      }
    end

    def manager_accept_order(order_id:)
      secure_call {
        logger.info "call manager_accept_order"
        data = ManagerAcceptOrder.(order_id: order_id)
        [data]
      }
    end

    def manager_cancel_order(order_id:)
      secure_call {
        logger.info "call manager_cancel_order"
        data = ManagerCancelOrder.(order_id: order_id)
        [data]
      }
    end
  end
end
