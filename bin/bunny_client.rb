require "json"
require "bunny"

conn = Bunny.new
conn.start

ch = conn.create_channel
ch.confirm_select

subscriber = proc{|delivery_info, metadata, payload|
  puts "> #{delivery_info.routing_key}"
  string = JSON.pretty_generate(JSON.parse(payload))
    .lines.map{|l| l =~ /^\{/ ? l :  "  #{l}"}.join
  puts "  payload: #{string}"
}

# the queue for getting replies
replyto = 'reply.here'
replyq = ch.queue(replyto)
replyq.subscribe(&subscriber)

# the queue to watch other orders events
events = 'orders.events'
eventsq = ch.queue(events)
eventsq.subscribe(&subscriber)

# the queue to request actions
action = 'orders.action'
actionq = ch.queue(action)

# call for few actions
actionq.publish("faulty one")

args = {'title' => 'Bunny', 'description' => 'Bunny', 'price' => '0.0'}
payload = JSON.dump(args)
actionq.publish(payload, type: 'manager.create.article', reply_to: replyto)

# await confirmations from RabbitMQ, see
# https://www.rabbitmq.com/publishers.html#data-safety for details
ch.wait_for_confirms
sleep 1
puts "Finished"
ch.close
conn.close
