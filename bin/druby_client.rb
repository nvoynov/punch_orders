require 'drb/drb'
require "json"

uri = ARGV.shift || "druby://localhost:8787"
DRb.start_service

orders = DRbObject.new_with_uri(uri)

puts ">> create a new article"
payload = {title: 'dRuby Client', description: '', price: 0.99}
response = orders.manager_create_article(**payload)
pp JSON.parse(response)

puts "\n>> query articles"
response = orders.query_articles
pp JSON.parse(response)

puts "\n>> query articles [:title, :eq, 'dRuby']"
payload = {where: [:title, :eq, 'dRuby']}
response = orders.query_articles(**payload)
pp JSON.parse(response)

puts "\n>> query articles [:title, :match, 'Ruby']"
payload = {where: [:title, :match, 'Ruby']}
response = orders.query_articles(**payload)
pp JSON.parse(response)

puts "\n>> create a new John's order"
arts = JSON.parse(response).fetch('data').map{|art|
  {'article_id' => art['id'], 'quantity' => 1, 'price' => 9.99}
}
# see server console John's Id for the value
user_id = 'e38d403d-1dea-4028-bd96-5fdba49270bc'
payload = {user_id: user_id, articles: arts}
response = orders.user_create_order(**payload)
pp JSON.parse(response)

puts "\n>> query orders"
response = orders.query_orders
pp JSON.parse(response)

puts "\n>> unknown action"
response = orders.unknown_action
pp JSON.parse(response)
