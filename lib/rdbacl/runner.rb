module RDbacl #:nodoc:
  class Runner
    
    attr_accessor :name, :cmd, :pwd, :dbacl
    attr_reader :result
    
    def initialize(opts={})
      raise ArgumentError, "Must at least provide a name" unless opts[:name]
      opts[:pwd] ||= "#{tmp}/#{opts[:name]}"
      assert_dir(opts[:pwd])
      opts.each {|k, v| set(k, v)}
    end

    def run
      command_string = self.pwd ? "cd #{self.pwd}; #{self.cmd}" : self.cmd
      @result = %x[#{command_string}]
    end
    
    def reset
      return false unless self.dbacl
      %x[rm #{category_files}]
    end
    
    protected
    
      # Whitespace-delimited list of category files
      def category_files
        self.dbacl.categories.map do |category|
          File.expand_path(File.join(self.pwd, category.to_s)) 
        end.join(" ")
      end
    
      # Set an instance variable out of an option key/value pair.
      def set(k, v)
        self.send(to_setter(k), v)
      end
      
      # Make a setter name out of an options key.
      def to_setter(sym)
        (sym.to_s + "=").to_sym
      end

      # Gets either a local or a global tmp directory.
      def tmp
        File.exist?("tmp") ? "tmp" : "/tmp"
      end
      
      # Makes the directory, in case it doesn't exist.  Very useful for
      # creating many different classifiers for a single application. 
      def assert_dir(loc)
        %x[mkdir #{loc} ] unless File.exist?(loc)
      end
  end
end
