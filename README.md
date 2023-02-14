% Punch Orders

# TODO

git log --pretty=oneline
git reset --soft HEAD~n
git reset --soft HEAD^1

This repo:

- [ ] design Ractors for dRuby and Bunny requests
- [ ] design clients scripts with a few concurrent threads
- [ ] desing domain events, `user.created|modified|removed`

# Purpose

The purposes of this project repository are:

1. To show how I see design of domain business logic with [Punch]()
2. To show how one can apply The Clean Architecture and DDD technics
3. To polish Punch and evolve my application design approach
4. To shows my applications design approach for potential customers

# Domain

Orders Domain consists of two actors, three entities, and ten services.

## Actors

- User
- Manager

## Entities

- User(name) @@todo suppose that users are inside Users domain :)
- Article(title, description, price, removed_at)
- Order(created_by, created_at, status, status_at, articles)

## Services

Shared:

- query articles(where, order, page_number, page_size)
- query orders(where, order, page_number, page_size)

User:

- create order(user_id, items)
- remove order(user_id, order_id)
- submit order(user_id, order_id)

Manager:

- create article(title, description, price)
- modify article(article_id, payload)
- remove article(article_id)
- accept order(order_id)
- cancel order(order_id)

## Plugins

- Store, Entity Store interface that provides 6 methods - `put`, `get`, `find`, `rm`, `key?`, `q`

# Apps (Faces)

The Orders Domain provides the following faces:

- dRuby
- Rack
- Rack face as pipeline of "authorize > produce > present"
- Bunny

Every Face:

- uses InMemoryStore implementation of Store Plugin
- uses shared set of entities presenters as JSON

## Face Design

Basically, every Face will consist of

- front object stand for controller
- set of proxy domain services
- set of presenters for domain entities

> `app/rack2` changes those structure for pipeline of filters: Authorize >> Process >> Present

## Controller

A front object exists in a particular environment and provides request-response cycle:

- get an actor's request from the environment
- locate domain service in accordance with the request
- translate request parameters from the environment into the domain
- call the located service
- translate the service response back into environment
- and finally, return the response to the actor.

## Action

Action there is a good abstraction for proxying service calls from environment requests. The Action class extend basic Proxy class. Where

- `Proxy` provides the ability to adopt a domain service by translating the service arguments from an environment presentation, and translating the service response back into the environment.
- `Action` implements the `arguments translation` and provides mechanism for domain service location.

The `Actions` module creates actions for all domain services available and implements the action location mechanism.

> Designed actions that way, when one adds, modifies, or removes domain services - there are no changes in `Actions` module required. So designed once it will serve right for other apps with little or no changes - it's sort of "generic" interface for any particular face tech (Rack, dRuby, Bunny)

## Presenter

Presenter just presents an domain entity in the face environment. It should use only general objects types like strings, numbers, arrays, and hashes. That way it will be "naturally portable" for any environment.

> All one could need there is Ruby Hash of strings, numbers, and arrays. It could be easily translated into JSON or like.

## Pagination

Querying big collection might cause sort of excessive service load and increase response time, so "face" should prevent such things by limiting number of record to return.

I chosen to provide a separate basic service for querying entities that provides `filter`, `order`, `page_number`, and `page_size` input parameters; and this returns the queried collection with a meta information is there more entities indide the store for `page_number`, `page_size`.

> Designed basic query that way, it will still the same for all collections - the only thing that changed is Entity to query!

## Store Plugins

Store Plugin implemented as InMemoryStore which holds entities in memory as PORO, it

- provides basic immutability by deep_dup from Rails
- and locking mechanism based on MonitorMixin.

At the moment, this InMemoryStore implemented in a separate gem, that is not presented here. But such thing actually is easy do design.

> Why InMemory? That way one could start clean without introducing dependence from storage technology at the beginning. It will serve perfectly for tests, could serve for MVP, etc. It will save one's time staying on PORO.

Other store implementations should be designed from the domain, where plugin implementation depends on the domain, NOT domain depends on store implementation!

Actually there should be just general store implementation, that translates entities into storage presentation by using `mappers` and construct entities from the storage using `builders`. Besides, those `mappers` will be very similar to presenters and `builders` could be adopted from existed already entities builders. That would be sort of Object-Relation-Mapper for SQL.

# Design Steps

At the beginning this repository was created using [Punch]() and the domain was designed by `Punch::DSL` in terms of Actors, Entities, and Services. Having the domain designed, all its source skeletons were generated by `PunchDomain` service.

The next step was manual design of the domain business logic with unit tests. In this process the store interface was established.

The following step was design particular faces - dRuby, Rack, and Bunny. At the beginning actions were generated from DSL created at the first place, but then those became rather generic and the generated code was replaced by crating actions just inside `Actions` module.

From the beginning I had InMemoryStore implementation, but it was connected only when I was testing face implementations calling for particular domain services.

And finally, I designed PostgreSQL Store interface with Sequel, where entities collections are storing as PostgreSQL Arrays and JSONB. Database schema wad generated based on mappers using `#ddl` method.

The decision to postpone database design for the last thing was the right one.
