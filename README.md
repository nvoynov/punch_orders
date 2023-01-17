% Punch Orders

# TODO

git log --pretty=oneline
git reset --soft HEAD~n
git reset --soft HEAD^1

- `Store.q` with `page_number, page_size` BUT `InMemoryStore.q` with `limit, offset` .. BUT IRB seems to work, but require to
  require "./lib/orders"
  require "./app/faces/ruby" TO GET Response class!!!!

- `Ranch`
  - [ ] move `Presenter` to gadgets

QueryService

- `punch`
  - [ ] `punch status` fix typo `though` to `through`!
  - [ ] add `.punch/domain/fagen.rb`
  - [ ] remove `punch.yml` from git repo (git rm)
  - [ ] punch migrations manually by `dogen.rb`
  - [ ] add README.md, Dockerfile into assets/starter
  - [ ] check `PunchDomain` for `require "domain/sentries"`
  - [ ] check `PunchDomain` for `config.rb` for `include domain::Plugins`
  - [ ] generated test as `fail "not implemented yet"`
  - [ ] remove `let(:payload)` from service tests, maybe better always create fake data dummies?
  - [ ] add `include Domain::Entities` when any?
  - [ ] service sample should provide yard comments for parameters; entity has attributes so it's obvious there


- [x] develop orders domain DSL
- develop orders domain
  - [x] sentries
  - [x] entities
  - [x] services
- develop a few faces
  - [x] dRuby service
  - [ ] develop Rack service
  - [ ] develop Sinatra service
  - [ ] develop RabbitMQ service (docker)
- develop StorePlugin for (docker)
  - [ ] Redis
  - [ ] Mongo
  - [ ] Sequel (migrations)
  - [ ] ElasticSearch

# Overview

This repository represents simple orders domain with two actors - User and Manager.

The Orders Domain operates with the following entities:

- User(name) @@todo suppose that users are inside Users domain :)
- Article(title, description, price, removed_at)
- Order(created_by, created_at, status, status_at, articles)

The domain provides services for two actors - User and Manager, where the User are provided with:

- query articles(where, order, page_number, page_size)
- query orders(where, order, page_number, page_size)
- create order(user_id, items)
- remove order(user_id, order_id)
- submit order(user_id, order_id)

and the Manager with:

- query articles(where, order, page_number, page_size)
- query orders(where, order, page_number, page_size)
- create article(title, description, price)
- modify article(article_id, payload)
- remove article(article_id)
- accept order(order_id)
- cancel order(order_id)

# Faces

@@todo The repository also equips users with few "faces" (user interface, dRuby, Rack, MQ) to the Order Domain to interact with.

@@todo Each "face" can configure data storage by using a particular plugin (In Memory, Redis, Sequel).

## Response

The _Face response should be expressed in exclusively in strings, numbers, arrays, and hashes_. That way it could be "naturally" portable for any consumer of the Face. It could be translated to JSON. For dRuby face you don't want to require domain library to understand responses.

So my fancy Response Struct should be changed to Hash

## Pagination

Querying big collection might cause sort of excessive service load and increase response time, so "face" should prevent such things by limiting number of record to return. This stuff is up to face, not services!

Query service should accept `page_number` and `page_size` and return result with the hint if there is next page. But Storage interface should remain with just `limit` and `offset`.

```ruby
class QueryService
  def call(page_number, page_size)
    limit = ..
    offset = ..
    data = store.q(limit + 1, offset)
    size = data.size
    data.pop if data.size > limit
    _next = size > limit
    data, _next

    store.q(Article,
      where: @where, order: @order,
      limit: @limit, offset: @offset)
  end
end
```

This way with Basic Query Service, you don't need to test descendants ... maybe there no need for UserQueryArticles and ManagerQueryArticles, because they are the same ... UserQueryOrders vary from ManagerQueryOrders by one paramter - `user_id` and it should be provided by "face"

@where.unshift([:user_id, :eq, @user_id])
