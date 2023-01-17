require_relative "../../test_helper"
require "./app/gadgets"

describe Presenter do
  let(:dummy) { Struct.new(:param, :value, :items) }
  let(:subject) {
    subj = dummy
    Class.new(Presenter) do
      present subj
      attributes :param, :value
      collection :items, :param, :value
    end
  }

  it {
    obj = dummy.new('param a', 'value b', [
      dummy.new('param b', 'value c'),
      dummy.new('param c', 'value d'),
    ])
    presented = subject.(obj)
    assert_kind_of Hash, presented
    assert presented.fetch('type')
    assert presented['attributes'].fetch('param')
    assert presented['attributes'].fetch('value')
    assert presented['collections'].fetch('items')
  }
end

class TestPresenter < Minitest::Test
  def subject
    Presenter
  end

  def test_class_present
    # it must be Object when not provided
    dummy = Class.new(subject)
    assert dummy.presented
    assert_equal Object, dummy.presented

    subj = Struct.new(:prop, :value)
    Class.new(subject) do
      present subj
    end

    assert_raises(RuntimeError) {
      subj = Object.new
      Class.new(subject) do
        present subj
      end
    }
  end

  def test_class_attributes
    # it must be [] when not provided
    subj = Class.new(subject)
    assert subj.properties
    assert_equal [], subj.properties

    # it must be unique
    subj = Class.new(subject) do
      attributes :one, :two
      attributes :two, :three
    end
    assert subj.properties
    assert_equal [:one, :two, :three], subj.properties
  end

  def test_class_collection
    # it must be [] when not provided
    subj = Class.new(subject)
    assert subj.collections
    assert_equal [], subj.collections

    subj = Class.new(subject) do
      collection :items, :param, :value
      collection :sales, :param, :value
    end
    assert subj.collections
    assert_equal 2, subj.collections.size
  end

  def test_class_call
    subj = Class.new(subject)
    assert_equal Hash['type' => "#{Object.new.class}"], subj.(Object.new)

    dummy = Struct.new(:param, :value)
    subj = Class.new(subject) do
      attributes :param, :value
    end

    obj = dummy.new('param', 'value')
    presented = subj.(obj)
    assert presented.fetch('type')
    assert presented.fetch('attributes')
    assert presented['attributes'].fetch('param')
    assert presented['attributes'].fetch('value')
  end
end
