module RDbacl #:nodoc:
  
  # This class contains the intent of what should be run on the command
  # line, checks it for consistency (learners must have one and only one
  # category, that sort of thing)
  # 
  # I've considered building a new interface to dbacl in C and then
  # building an FFI interface to the library directly, but this will work
  # for now. 
  # 
  # The API is:
  # dbacl [-01dvnirmwMNDXW] [-T type ] -l category [-h size] [-H gsize] 
  #   [-x decim] [-q quality] [-w max_order] [-e deftok] [-o online] 
  #   [-L measure] [-g regex]... [FILE]...
  # dbacl [-vnimNRX] [-h size] [-T type] -c category [-c category]... 
  #   [-f keep]... [FILE]...
  # dbacl -V
  class Wrapper
    
    def initialize(opts={})
      opts.each {|k, v| self.send(to_setter(k), v)}
    end
    
    attr_accessor :l, :T, :filename, :text, :V, :preloading, :d, :v, :n, :i, :r, :m, :w, :g, :M, :N, :D, :X, :W,
      :h, :H, :x, :q, :e, :o, :L
    alias :learn= :l=
    alias :learn :l
    alias :type= :T=
    alias :type :T
    alias :dump= :d=
    alias :dump :d
    alias :verbose= :v=
    alias :verbose :v
    alias :print_scores= :n=
    alias :print_scores :n
    alias :internationalized= :i=
    alias :internationalized :i
    alias :digramic_reference_only= :r=
    alias :digramic_reference_only :r
    alias :reference_only= :r=
    alias :reference_only :r
    alias :aggressively_use_memory= :m=
    alias :aggressively_use_memory :m
    alias :memory_lock= :m=
    alias :memory_lock :m
    alias :num_n_grams= :w=
    alias :num_n_grams :w
    alias :force_multinomial= :M=
    alias :force_multinomial :M
    alias :print_posteriors= :N=
    alias :print_posteriors :N
    alias :debug= :D=
    alias :debug :D
    alias :show_confidence= :X=
    alias :show_confidence :X
    alias :num_same_line_n_grams= :W=
    alias :num_same_line_n_grams :W
    alias :hash_table_size= :h=
    alias :hash_table_size :h
    alias :hash_table_max= :H=
    alias :hash_table_max :H
    alias :decimation_probability= :x=
    alias :decimation_probability :x
    alias :quality= :q=
    alias :quality :q
    alias :tokenization= :e=
    alias :tokenization :e
    alias :online= :o=
    alias :online :o
    alias :reference_measure= :L=
    alias :reference_measure :L

    def c=(val)
      case val
      when Hash
        val.each {|k, v| self.categories << v}
      when Enumerable # All other Enumerables besied Hash
        val.each {|v| self.categories << v}
      else
        self.categories << val
      end
      self.categories.uniq!
      val
    end
    alias :classifier_mode= :c=
    alias :classes= :c=
    alias :<< :c=
    
    def c
      self.l ? false : true
    end
    alias :classifier_mode :c
    
    def categories
      @categories ||= []
    end
    
    def inspect
      self.command_line
    end
    
    protected
    
      def to_setter(sym)
        (sym.to_s + "=").to_sym
      end

      def command_line
        validate
        assert_command_line_api
      end
      
      def validate
        self.methods.grep(/validate_/).each do |meth|
          self.send(meth)
        end
      end
      
      def assert_command_line_api
        # Later, figure out from 1, 2, or 3.
        if self.V
          command_line_api_3
        elsif self.l
          command_line_api_2
        else
          command_line_api_1
        end
      end
      
      # dbacl [-01dvnirmwMNDXW] [-T type ] -l category [-h size] [-H gsize] 
      #   [-x decim] [-q quality] [-w max_order] [-e deftok] [-o online] 
      #   [-L measure] [-g regex]... [FILE]...
      def command_line_api_1
        Logger.info "Inferred API version 1"
        [
          text_input,
          "dbacl",
          preloading_mode,
          dump_mode,
          verbose_mode,
          printing_scores_mode,
          internationalized_mode,
          reference_only_mode,
          memory_lock_mode,
          extend_n_grams_mode,
          forcing_multinomial_mode,
          printing_posteriors_mode,
          debug_mode,
          show_confidence_mode,
          extend_same_line_n_grams_mode,
          type_mode, 
          
          list_categories,
          
          setting_hash_start_value,
          forcing_hash_limits,
          setting_decimation_probability,
          setting_quality,
          setting_tokenization_class,
          online_mode,
          setting_reference_measure,
          
          
          file_input
        ].compact.join(" ")
      end
      
      # dbacl [-vnimNRX] [-h size] [-T type] -c category [-c category]... 
      #   [-f keep]... [FILE]...
      def command_line_api_2
        [
          text_input,
          "dbacl",
          verbose_mode,
          printing_scores_mode,
          internationalized_mode,
          memory_lock_mode,
          printing_posteriors_mode,
          
          show_confidence_mode,

          type_mode, 
          
          learn_category,
          
          file_input
        ].compact.join(" ")
      end
      
      # dbacl -V
      def command_line_api_3
        Logger.info "Inferred API version 3: Only outputing dbacl -V, ignoring all other configuration."
        "dbacl -V"
      end
      
      def learn_category; "-l #{self.l}" if self.l end
      
      def list_categories
        return nil if categories.empty?
        categories.map{|cat| "-c #{cat.to_s}"}.join(" ")
      end
      
      def preloading_mode; "-1" if self.preloading end
      def dump_mode; "-d" if self.d end
      def verbose_mode; "-v" if self.v end
      def printing_scores_mode; "-n" if self.n end
      def internationalized_mode; "-i" if self.i end
      def reference_only_mode; "-r" if self.r end
      def memory_lock_mode; "-m" if self.m end
      def extend_n_grams_mode; "-w#{self.w}" if self.w end
      def forcing_multinomial_mode; "-M" if self.M end
      def printing_posteriors_mode; "-N" if self.N end
      def debug_mode; "-D" if self.D end
      def show_confidence_mode; "-X" if self.X end
      def extend_same_line_n_grams_mode; "-W#{self.W}" if self.W end
      def setting_hash_start_value; "-h#{self.h}" if self.h end
      def forcing_hash_limits; "-H#{self.H}" if self.H end
      def setting_decimation_probability; "-x#{self.x}" if self.x end
      def setting_quality; "-q#{self.q}" if self.q end
      def setting_tokenization_class; "-e #{self.e}" if self.e end
      def online_mode; "-o" if self.o end
      def setting_reference_measure; "-L #{self.L}" if self.L end
      
      def type_mode; "-T #{self.T.to_s}" if self.T end
      def text_input; %{echo "#{self.text}" |} if self.text end
      def file_input; self.filename if self.filename end
      
      def validate_type
        return true unless self.T
        case self.T
        when :email, :html, :xml, :text
          return true
        else
          Logger.info "Parameter inference: type was set to #{self.type}, which was changed to the default (text)."
          # Default to :text
          self.T = :text
        end
      end
      
      def validate_filename_or_text
        return true unless self.text and self.filename
        Logger.info "Text inference: had both text and filename set.  Used the text and ignored the filename"
        self.filename = nil
      end
      
      # g invalidates w.  dbacl ignores w when we set g, so we keep it clean here
      def validate_g_w_exclusivity; force_exclusivity(:w, :g) end
      def validate_numericity_of_w; force_numericity(:@w) end

      # g invalidates w.  dbacl ignores w when we set g, so we keep it clean here
      def validate_g_W_exclusivity; force_exclusivity(:W, :g) end
      def validate_numericity_of_W; force_numericity(:@W) end
      def validate_numericity_of_h; force_numericity(:@h) end
      def validate_numericity_of_H; force_numericity(:@H) end
      def validate_numericity_of_x; force_numericity(:@x) {|x| x.to_f} end
      
      def validate_q_in_set
        return true unless self.q
        force_numericity(:@q)
        unless [1,2,3,4].include?(self.q)
          Logger.info "Quality (q) must be set to 1, 2, 3, 4 where 4 is the highest quality.  You supplied #{self.q}.  Removing q value, defaults will prevail."
          self.q = nil
        end
      end
      
      def validate_e_in_set
        return true unless self.e
        self.e = self.e.to_s
        unless %w(alpha alnum graph cef adp).include?(self.e)
          Logger.info "Tokenizer class (e) must be set to alpha, alnum, graph, cef, or adp.  You set it to #{self.e}.  Removing e value, defaults will prevail."
          self.e = nil
        end
      end
      
      def validate_L_in_set
        return true unless self.L
        self.L = self.L.to_s
        unless %w(uniform dirichlet maxent).include?(self.L)
          Logger.info "Digramic reference measure must be one of: uniform, dirichlet, or maxent.  You provided #{self.L}.  Removing L value, defaults will prevail."
          self.L = nil
        end
      end

      def force_exclusivity(deferred, preferred)
        deferred_var, preferred_var = ("@" + deferred.to_s).to_sym, ("@" + preferred.to_s).to_sym
        if self.instance_variable_get(preferred_var)
          Logger.info "#{preferred} and #{deferred} are mutually exclusive.  Ignoring #{deferred}."
          self.instance_variable_set(deferred_var, nil) 
        end
      end
      
      def force_numericity(method, &block)
        block ||= lambda{|x| x.to_i}
        val = self.instance_variable_get(method)
        return unless val
        begin
          val = block.call(val)
          self.instance_variable_set(method, val)
        rescue
          Logger.info "Attempted to coerce #{method.to_s} into a Numeric and failed."
        end
      end

  end
end

# Now, get subclasses of this file.
Dir.glob("#{File.dirname(__FILE__)}/wrapped_dbacl/*.rb").each { |file| require file }




# So, build this, then subclass it a few times to get some default
# configuraitions for the various common use cases. 


# Candidates: X, n, N, l, v

# Also, need to make sure that the unusable configuraitons don't hit.  I've got 3 categories, if ther's a V, it's 3, if there's an l, it's 2, else 1.  So, set all the parameters, make sure things are setup in order.  Make sure things don't show up that shouldn't.

# Need to break things down: a standard configuration, and a way to slurp up the output into a class.  The class maybe should be part of the Wrapper above.