% Punch Orders

# TODO

git log --pretty=oneline
git reset --soft HEAD~n
git reset --soft HEAD^1

- `punch`
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
  - [ ] dRuby service
  - [ ] develop Sinatra service
  - [ ] develop Rack service
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
