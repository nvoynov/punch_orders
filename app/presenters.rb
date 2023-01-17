require_relative "gadgets"
require_relative "config"

require "./lib/orders"
include Orders::Entities

class ArticlePresenter < Presenter
  present Article
  attributes :title, :description, :price
end

class OrderPresenter < Presenter
  present Order
  attributes :created_by, :created_at, :user_name, :status, :status_at
  collection :articles, :article_id, :title, :quantity, :price
end

roster = PresentersHolder.roster
roster << ArticlePresenter
roster << OrderPresenter
