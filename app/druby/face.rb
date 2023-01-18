require "logger"
require_relative "conf"
include Orders::Services

# "Ruby Face" for Orders Domain
module Face
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
    presenters = DecorHolder.object
    return obj.map{present(_1)} if obj.is_a?(Array)
    presenters.(obj).(obj)
  end

  def secure_call &block
    data, meta = yield
    respond(data: present(data), meta: meta)
  rescue ArgumentError, Service::Failure, Store::Failure => e
    logger.error e
    respond(error: "(#{e.class}) #{e.message}")
  rescue => e
    logger.error e.full_message
    raise $!
  end

  def logger
    @logger ||= ::Logger.new(IO::NULL,
      datetime_format: '%Y-%m-%d %H:%M:%S',
      formatter: proc{|severity, datetime, progname, msg|
        "[#{datetime}] #{severity.ljust(5)}: #{msg}\n"
    })
  end

  public

  def logger=(logger)
    @logger = logger
  end

  def query_articles(where: [], order: {}, page_number: 0, page_size: 25)
    secure_call {
      logger.info "call query_articles"
      QueryArticles.(
        where: where, order: order,
        page_number: page_number,
        page_size: page_size)
    }
  end

  def query_orders(where: [], order: {}, page_number: 0, page_size: 25)
    # where to gen user_id from? Session required!
    secure_call {
      logger.info "call user_query_orders"
      QueryOrders.(
        where: where, # @todo patch where with [:user_id, :eq, user_id]
        order: order,
        page_number: page_number,
        page_size: page_size)
    }
  end

  def user_create_order(user_id:, articles:)
    secure_call {
      logger.info "call user_create_order"
      UserCreateOrder.(user_id: user_id, articles: articles)
    }
  end

  # @todo get user_id form session
  # @todo face shoud be jsust user_remove_order(order_id)
  def user_remove_order(user_id:, order_id:)
    secure_call {
      logger.info "call user_remove_order"
      UserRemoveOrder.(user_id: user_id, order_id: order_id)
    }
  end

  def user_submit_order(user_id:, order_id:)
    secure_call {
      logger.info "call user_submit_order"
      UserSubmitOrder.(user_id: user_id, order_id: order_id)
    }
  end

  def manager_create_article(title:, description:, price:)
    secure_call {
      logger.info "call manager_create_article"
      ManagerCreateArticle.(title: title, description: description, price: price)
    }
  end

  def manager_modify_article(article_id:, title:, description:, price:)
    secure_call {
      logger.info "call manager_modify_article"
      ManagerModifyArticle.(article_id: article_id, title: title, description: description, price: price)
    }
  end

  def manager_remove_article(article_id:)
    secure_call {
      logger.info "call manager_remove_article"
      ManagerRemoveArticle.(article_id: article_id)
    }
  end

  def manager_accept_order(order_id:)
    secure_call {
      logger.info "call manager_accept_order"
      ManagerAcceptOrder.(order_id: order_id)
    }
  end

  def manager_cancel_order(order_id:)
    secure_call {
      logger.info "call manager_cancel_order"
      ManagerCancelOrder.(order_id: order_id)
    }
  end
end
