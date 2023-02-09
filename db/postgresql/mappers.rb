require "runch"
require "runch/sequel_pg_store"
require "./lib/orders"
include Runch
include Orders::Entities

module Mappers
  class << self
    def find(arg)
      klass = arg.is_a?(Class) ? arg : arg.class
      roster.fetch(klass, nil) # NullMapper?
    end
    alias :call :find

    protected

    def roster
      @roster ||= constants.map{|kon|
        const = const_get(kon)
        [const.klass, const]
      }.to_h
    end
  end

  class ArticleMapper < SequelPgMapper
    from Article
    into :articles
    property :id, :title, :price
  end

  class UserMapper < SequelPgMapper
    from User
    into :users
    property :id, :name
  end

  class OrderMapper < SequelPgMapper
    from Order
    into :orders
    property :id, :customer_id, :created_at, :total
    collection :articles, :article_id, :quantity, :price, :total
  end
end

# create database schema
if __FILE__ == $0
  Mappers.public_class_method :roster
  mappers = Mappers.roster.values
  puts "/* Database Schema (PostgreSQL) */"
  puts
  ddl = [].tap{|schema|
    fu = proc{|acc, item| acc << item.ddl }
    mappers.inject(schema, &fu)
  }
  puts ddl
end
