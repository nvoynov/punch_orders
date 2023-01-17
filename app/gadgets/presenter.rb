class Presenter
  class << self
    def present(subject)
      fail "subject must be Class" unless subject.is_a?(Class)
      @presented = subject
    end

    def attributes(*args)
      @attributes ||= []
      @attributes.concat args
    end

    def collection(*args)
      @collections ||= []
      @collections << args
    end

    def presented
      @presented || Object
    end

    def properties
      @attributes&.uniq || []
    end

    def collections
      @collections ||= []
    end

    def call(subject)
      new(subject).()
    end
  end

  def initialize(object)
    fail "object must be #{presented}" unless object.is_a?(presented)
    @object = object
  end

  private_class_method :new

  def call
    prop = proc{|subj, prop| [prop.to_s, subj.send(prop)] }
    coll = proc{|coll| # => Array<Hash>
      type, *items = coll
      items.uniq!
      subj = @object.send(type)
      {
        type.to_s => subj.inject([]){|acc, i|
          fn = prop.curry.(i)
          acc << items.map(&fn).to_h
        }
      }
    }

    {}.tap{|hsh|
      hsh.store('type', "#{@object.class}")
      hsh.store('id', @object.id) if @object.respond_to?(:id)

      fn = prop.curry.(@object)
      props = properties.map(&fn).to_h
      hsh.store('attributes', props) if props.any?

      colls = collections.inject({}){|acc, i|
        acc.merge coll.(i)
      }
      hsh.store('collections', colls) if colls.any?
    }
  end

  protected

  def presented
    self.class.presented
  end

  def properties
    self.class.properties
  end

  def collections
    self.class.collections
  end

end
#
# Item = Struct.new(:name, :price, :quantity) do
#   def total = price * quantity
# end
#
#
# Order = Struct.new(:id, :user, :items) do
#   def total = items.map(&:total).sum
# end
#
# class OrderPresenter < Presenter
#   origin Order
#   attributes :user, :total
#   collection :items, :name, :price, :quantity, :total
# end
#
# items = [
#   Item.new('one', 9.99, 1),
#   Item.new('two', 9.99, 1),
# ]
#
# order = Order.new(1, 'John', items)
# pp OrderPresenter.(order)
