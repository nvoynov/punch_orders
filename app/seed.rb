# create starter data

require "bigdecimal/util"
require "./lib/orders"
include Orders::Services

store = StoreHolder.object

%w|John Jane Alice Bob|.each{ store.put(User.new(name: _1))}

articles = [
  {title: 'dRuby',  description: 'dRuby Book',  price: 9.99},
  {title: 'Rack',   description: 'Rack Book',   price: 9.99},
  {title: 'Redis',  description: 'Redis Book',  price: 9.99},
  {title: 'Mongo',  description: 'Mongo Book',  price: 9.99},
  {title: 'Docker', description: 'Docker Book', price: 9.99},
  {title: 'The Clean Architecture', description: 'The Book!', price: 9.99},
]
articles.each{|art| ManagerCreateArticle.(**art) }

john = store.find(User, name: 'John')
jane = store.find(User, name: 'Jane')
arts = store.all(Article).map(&:id)

UserCreateOrder.(created_by: john.id, articles: [
  {'article_id' => arts[0], 'quantity' => 1, 'price' => 9.99},
  {'article_id' => arts[1], 'quantity' => 1, 'price' => 9.99},
  {'article_id' => arts[2], 'quantity' => 1, 'price' => 9.99},
])

UserCreateOrder.(created_by: jane.id, articles: [
  {'article_id' => arts[0], 'quantity' => 1, 'price' => 9.99},
  {'article_id' => arts[1], 'quantity' => 1, 'price' => 9.99},
  {'article_id' => arts[2], 'quantity' => 1, 'price' => 9.99},
])
