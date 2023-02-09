require 'json'
require 'faraday'
require 'faraday/net_http'
Faraday.default_adapter = :net_http

URL = 'http://localhost:9292'
HEADERS = {'Content-Type' => 'application/json'}

def service
  @service ||= Faraday.new(url: URL, headers: HEADERS)
end

res = service.get('/face/query-articles')
pp JSON.parse(res.body)

# create article
art = {"title" => "my new book", "description" => "", "price" => "9.99"}
res = service.post('/face/manager-create-article', JSON.dump(art))
pp JSON.parse(res.body)

# create article with missing parameters
art = {"title" => "my new book", "price" => "9.99"}
res = service.post('/face/manager-create-article', JSON.dump(art))
pp JSON.parse(res.body)

res = service.get('/face/query-articles')
pp JSON.parse(res.body)
