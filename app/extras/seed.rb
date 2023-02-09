# create starter data

require "bigdecimal/util"
require "./lib/orders"
include Orders::Services

store = StoreHolder.object

%w|John Jane Alice Bob|.each{ store.put(User.new(name: _1))}

articles = [
  {title: 'dRuby', description: 'dRuby Book', price: 9.99},
  {title: 'RRack', description: 'RRack Book', price: 9.99},
  {title: 'Redis', description: 'Redis Book', price: 9.99},
  {title: 'Mongo', description: 'Mongo Book', price: 9.99},
  {title: 'Docker', description: 'Docker Book', price: 9.99},
  {title: 'The Clean Architecture', description: 'The Book!', price: 9.99},
  {title: 'Introducing Go', description: 'Interesting', price: 9.99},
  {title: 'DDD with Golang', description: 'Promising', price: 9.99},
]
articles.each{|art| ManagerCreateArticle.(**art) }

john = store.find(User, name: 'John')
jane = store.find(User, name: 'Jane')
arts = store.all(Article).map(&:id)

UserCreateOrder.(user_id: john.id, articles: [
  {'article_id' => arts[0], 'quantity' => 1, 'price' => 9.99},
  {'article_id' => arts[1], 'quantity' => 1, 'price' => 9.99},
  {'article_id' => arts[2], 'quantity' => 1, 'price' => 9.99},
])

UserCreateOrder.(user_id: jane.id, articles: [
  {'article_id' => arts[0], 'quantity' => 1, 'price' => 9.99},
  {'article_id' => arts[1], 'quantity' => 1, 'price' => 9.99},
  {'article_id' => arts[2], 'quantity' => 1, 'price' => 9.99},
])
