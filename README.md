% Punch Orders

# TODO

git log --pretty=oneline
git reset --soft HEAD~n
git reset --soft HEAD^1

- `punch`
  - [ ] remove `punch.yml` from git repo (git rm)
  - [ ] add README.md, Dockerfile into assets/starter
  - [ ] check `PunchDomain` for `require "domain/sentries"`
  - [ ] check `PunchDomain` for `config.rb` for `include domain::Plugins`
  - [ ] generated test fails "not implemented yet"


- [ ] develop orders domain DSL
- [ ] develop orders domain
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

This repository represents simple orders domain with two actors - User and Manager, where

Entities:

- User(name) @@todo suppose that users are inside Users domain :)
- Article(title, description, price, removed_at)
- Order(created_by, created_at, status, status_at, articles)

User:

- query articles(where, order, page_number, page_size)
- query orders(where, order, page_number, page_size)
- create order(user_id, items)
- remove order(order_id)
- submit order(order_id)

Manager

- query articles(where, order, page_number, page_size)
- query orders(where, order, page_number, page_size)
- create article(title, description, price)
- modify article(article_id, payload)
- remove article(article_id)
- accept order(order_id)
- cancel order(order_id)
