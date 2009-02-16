module RDbacl #:nodoc:
  class Email < Wrapper
    def initialize(opts={})
      opts[:T] = :email
      opts.delete(:type)
      super
    end
  end
end