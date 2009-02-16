module RDbacl #:nodoc:
  class Html < Wrapper
    def initialize(opts={})
      opts[:T] = :html
      opts.delete(:type)
      super
    end
  end
end