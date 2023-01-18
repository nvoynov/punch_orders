require_relative "conf"
include Orders::Entities

class ArticlePresenter < Presenter
  present Article
  properties :title, :description, :price
end

class OrderPresenter < Presenter
  present Order
  properties :created_by, :created_at, :user_name, :status, :status_at
  collection :articles, :article_id, :title, :quantity, :price
end

roster = DecorHolder.object
roster << ArticlePresenter
roster << OrderPresenter
