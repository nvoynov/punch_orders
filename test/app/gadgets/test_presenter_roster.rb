require_relative "../../test_helper"
require "./app/gadgets"

class TestPresenterRoster < Minitest::Test
  def subject
    @subject ||= PresenterRoster.new
  end

  def test_add
    # must accept only descendants
    subject << Class.new(Presenter)
    subject.add Class.new(Presenter) # alias
    assert_raises(ArgumentError) { subject << Object }
    assert_raises(ArgumentError) { subject << Presenter }
  end

  def test_get
    assert_equal subject.get(Object.new), Presenter
    assert_equal subject.(Object.new), Presenter

    param = Struct.new(:param)
    value = Struct.new(:param)
    unknown = Struct.new(:fourty_two)

    subj_par = Class.new(Presenter) do
      present param
      attributes :param
    end

    subj_val = Class.new(Presenter) do
      present value
      attributes :value
    end

    subject << subj_par
    subject << subj_val

    obj = param.new(42)
    assert_equal subj_par, subject.(obj)

    obj = value.new(42)
    assert_equal subj_val, subject.(obj)

    obj = unknown.new(42) # default presenter for unknown object
    assert_equal Presenter, subject.(obj)
  end
end
