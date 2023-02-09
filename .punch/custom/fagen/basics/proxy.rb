# frozen_string_literal: true

class Proxy
  class << self
    def origin(arg)
      fail ArgumentError, "must respond to :call" unless arg.respond_to? :call
      @subject = arg
    end

    def subject
      @subject
    end

    def call(*args, **kwargs, &block)
      new(*args, **kwargs, &block).call
    end
  end

  def initialize(*args, **kwargs, &block)
    @args, @kwargs, @block = args, kwargs, block
  end

  def call
    fail FAULTY_ORIGIN unless subject
    args = arguments
    subject.(*args[0], **args[1], &args[2])
  end

  protected

  def subject
    self.class.subject
  end

  def arguments
    [@args, @kwargs, @block]
  end

  FAULTY_ORIGIN = <<~EOF
    :origin must be provided
    class #{self.class.name}
      origin <callableconst>
      ^^^^^^^^^^^^^^^^^^^^^^
    end
  EOF
end