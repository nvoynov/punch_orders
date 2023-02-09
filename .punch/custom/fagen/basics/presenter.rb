# frozen_string_literal: true

class Presenter
  class << self
    def present(subject)
      fail "subject must be Class" unless subject.is_a?(Class)
      @presented = subject
    end

    def properties(*args)
      @properties ||= []
      @properties.concat args
    end

    def collection(*args)
      @collections ||= []
      @collections << args
    end

    def presented
      @presented || Object
    end

    def _properties
      @properties&.uniq || []
    end

    def collections
      @collections ||= []
    end

    def call(object)
      new(object).()
    end
  end

  def initialize(object)
    fail "object must be #{presented}" unless object.is_a?(presented)
    @object = object
  end

  private_class_method :new

  def call
    {}.tap{|hsh|
      hsh.store('type', "#{@object.class}".split('::').last.downcase)
      hsh.store('id', @object.id) if @object.respond_to?(:id)

      fu = presentfu(@object)
      props = properties.map(&fu).to_h
      hsh.store('properties', props) if props.any?

      colls = collections.inject({}){|acc, co|
        acc.merge presentco(co)
      }
      hsh.store('collections', colls) if colls.any?
    }
  end

  protected

  # basic property presenter
  def present(obj, prop)
    [prop.to_s, _present(obj.send(prop))]
  end

  def _present(arg)
    case arg
    when BigDecimal
      arg.round(2, :up).to_s('F')
    else
      arg.to_s
    end
  end

  # basic presenting fu
  def presentfu(obj)
    method(:present).curry.(obj)
  end

  # present collection
  def presentco(coll)
    head, *tail = coll  # => collection, *properties
    tail.uniq!
    subj = @object.send(head)
    {
      head.to_s => subj.inject([]){|acc, co|
        fu = presentfu(co)
        acc << tail.map(&fu).to_h
      }
    }
  end

  def presented
    self.class.presented
  end

  def properties
    self.class._properties
  end

  def collections
    self.class.collections
  end
end