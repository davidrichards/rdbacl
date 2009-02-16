module RDbacl #:nodoc:
  class Text < Wrapper
    def initialize(opts={})
      opts[:T] = :text
      opts.delete(:type)
      super
    end
  end
end