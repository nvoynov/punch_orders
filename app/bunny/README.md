% RabbitMQ

TODO

- [x] it handles messages from `order.action` direct channel
- [x] it relies on `metadata.type` to identify service
- [x] it replies the result to `metadata.reply_to` channel
- [x] it broadcasts into `orders.events` fanout
- [x] it rejects wrong messages
- [ ] it replies with original message id if provided
- [ ] it handles action in a separate thread, maybe Queue and few workers

```ruby
require 'connection_pool'

def channel
  @channel_pool ||= ConnectionPool.new do
    connection.create_channel
  end
end
```

Run the broker with reasonable defaults:

```
docker run -d --hostname my-rabbit --name my-rabbit -p 5672:5672 -p 15672:15672 -e RABBITMQ_ERLANG_COOKIE='cookie_for_clustering' -e RABBITMQ_DEFAULT_USER=user -e RABBITMQ_DEFAULT_PASS=password --name some-rabbit rabbitmq:3-management
```
