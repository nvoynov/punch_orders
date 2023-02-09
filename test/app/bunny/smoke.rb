require "bunny"
require_relative "controller"

conn = Bunny.new
# conn = Bunny.new(hostname: '11728343671d')
conn.start

controller = Controller.new(conn)

# open a channel
ch = conn.create_channel
ch.confirm_select

# declare a queue for getting replies
reply_to = 'reply.here'
q1 = ch.queue(reply_to)
q1.subscribe do |delivery_info, metadata, payload|
  puts "> #{reply_to}: #{payload}"
end

events = 'orders.events'
qe = ch.queue(events)
qe.subscribe do |delivery_info, metadata, payload|
  puts "> #{events}: #{payload}"
end

# actions
action = 'orders.action'
q2 = ch.queue(action)

q2.publish("Hello", reply_to: reply_to)
# publish a message to the default exchange which then gets routed to this queue
# q.publish("Hello, everybody!")

# await confirmations from RabbitMQ, see
# https://www.rabbitmq.com/publishers.html#data-safety for details
ch.wait_for_confirms

# give the above consumer some time consume the delivery and print out the message
sleep 1


puts "Done"
ch.close
conn.close
