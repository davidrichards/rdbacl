module RDbacl #:nodoc:
  class Xml < Wrapper
    def initialize(opts={})
      opts[:T] = :xml
      opts.delete(:type)
      super
    end
  end
end