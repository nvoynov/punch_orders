require "punch/dsl"
include Punch

# Design your domain here
# look through sample.rb for details
def build_domain
  DSL::Builder.build do

    entity :user do
      param :name, "User name from Users domain"
    end

    entity :article do
      param :title, 'Article Title', :sentry => :title
      param :description, 'Article Description', :sentry => :description
      param :price, 'Article Price', :sentry => :money
      param :removed_at, 'Article Removed At', :sentry => :timestamp
    end

    entity :order do
      param :created_by, 'Order Created By', :sentry => :uuid
      param :created_at, 'Order Created At', :sentry => :timestamp
      param :status, 'Order Status', :sentry => :order_status
      param :status_at, 'Order Status Changed At', :sentry => :timestamp
      param :articles, 'Order Articles', :sentry => :order_articles
    end

    plugin :store, 'Orders Store'

    service :query_articles do
      param :where, :sentry => :array
      param :order, :sentry => :hash
      param :page_number, :sentry => :page_number
      param :page_size, :sentry => :page_size
    end

    service :query_orders do
      param :where, :sentry => :array
      param :order, :sentry => :hash
      param :page_number, :sentry => :page_number
      param :page_size, :sentry => :page_size
    end

    actor :user do
      service :create_order do
        param :user_id, :sentry => :uuid
        param :articles, :sentry => :order_articles
      end

      service :remove_order do
        param :user_id,  :sentry => :uuid
        param :order_id, :sentry => :uuid
      end

      service :submit_order do
        param :user_id,  :sentry => :uuid
        param :order_id, :sentry => :uuid
      end
    end

    actor :manager do
      service :create_article do
        param :title, :sentry => :title
        param :description, :sentry => :description
        param :price, :sentry => :money
      end

      service :modify_article do
        param :article_id, :sentry => :uuid
        param :title, :sentry => :title
        param :description, :sentry => :description
        param :price, :sentry => :money
      end

      service :remove_article do
        param :article_id, :sentry => :uuid
      end

      service :accept_order do
        param :order_id, :sentry => :uuid
      end

      service :cancel_order do
        param :order_id, :sentry => :uuid
      end
    end
  end
end
