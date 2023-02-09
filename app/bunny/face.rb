# require "bunny" # no Bunny constants there so it isn't required
require "json"
require "forwardable"
require_relative "conf"
require_relative "actions"
require_relative "../extras"

class BunnyFace
  extend Forwardable
  def_delegator :LoggerHolder, :object, :logger

  ACTION = 'orders.action'
  EVENTS = 'orders.events'

  def initialize(conn)
    @conn = conn
    @ch = conn.create_channel
    @ch.confirm_select
    @actionq = @ch.queue(ACTION)
    @eventsq = @ch.queue(EVENTS)
    mhandler = method(:handlemsg)
    @actionq.subscribe(manual_ack: true, &mhandler)
  end

  def handlers
    Actions
  end

  def handlemsg(delivery_info, metadata, payload)
    unless metadata.type # handle unknown action type
      message = "required metadata.type"
      logger.error message
      payload = present({error: message})
      replymsg(payload, metadata)
      @ch.reject(delivery_info.delivery_tag)
      return
    end

    handler = handlers.(metadata.type)

    unless handler # handle unknown action
      message = "unknown action #{metadata.type}"
      logger.error message
      payload = present({error: message})
      replymsg(payload, metadata)
      @ch.reject(delivery_info.delivery_tag)
      return
    end

    begin # handle action
      args = JSON.parse(payload)
      response = handler.(args)
      payload = present(response)
      replymsg(payload, metadata)
      eventmsg(payload, handler.action)
      logger.info handler.action
    rescue => e
      logger.error e
      payload = present(e)
      replymsg(payload, metadata)
    end

    @ch.ack(delivery_info.delivery_tag)
  end

  def replymsg(payload, metadata)
    replyto = metadata.reply_to
    return unless replyto
    q = replytoq(replyto)
    q.publish(payload) # @todo orginal message id?
  end

  def eventmsg(payload, action)
    @eventsq.publish(payload, 'action' => action)
  end

  def replytoq(replyto)
    @replyto ||= {}
    q = @replyto[replyto]
    unless q
      q = @ch.queue(replyto)
      @replyto[replyto] = q
    end
    q
  end

  def presenters
    Extras::Presenters
  end

  def present(arg)
    presenter = presenters.(arg)
    JSON.dump(presenter.(arg))
  end

  # from Rack for collections
  # def present(obj)
  #   return obj.map{present(_1)} if obj.is_a?(Array)
  #   pres = presenters.(obj)
  #   return obj unless pres
  #   pres.(obj)
  # end

end
