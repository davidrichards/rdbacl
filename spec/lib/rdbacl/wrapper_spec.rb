require File.join(File.dirname(__FILE__), "/../../spec_helper")

describe Wrapper do
  
  before(:each) do
    @w = Wrapper.new
  end
  
  it "should look like a command-line call" do
    Wrapper.new.inspect.should eql("dbacl")
  end
  
  it "should be able to go into learner mode" do
    Wrapper.new(:l => :spam).inspect.should eql("dbacl -l spam")
    @w.l = :spam
    @w.inspect.should eql("dbacl -l spam")
  end
  
  it "should be able to get out of classifer mode into learner mode" do
    @w.inspect.should eql("dbacl")
    @w.l = :spam
    @w.inspect.should eql("dbacl -l spam")
  end
  
  it "should be able to get out of learner mode into classifier mode" do
    @w.learn = :spam
    @w.inspect.should eql("dbacl -l spam")
    @w.l = false
    @w.classifier_mode = :one
    @w.inspect.should eql("dbacl -c one")
  end
  
  it "should be able to set the type with -T" do
    @w = Wrapper.new(:T => :email)
    @w.T.should eql(:email)
    @w.inspect.should eql("dbacl -T email")
  end
  
  it "should be able to set the type with type as well" do
    check_signature_with_new('dbacl -T email', :type => :email)
    check_signature('dbacl -T email') {|r| r.type = :email}
  end
  
  it "should allow only email, html, xml, and text as types" do
    @w.T = :email
    @w.inspect.should eql("dbacl -T email")
    @w.T = :html
    @w.inspect.should eql("dbacl -T html")
    @w.T = :xml
    @w.inspect.should eql("dbacl -T xml")
    @w.T = :text
    @w.inspect.should eql("dbacl -T text")
    @w.T = :anything_else
    @w.inspect.should eql("dbacl -T text")
    @w.T = false
    @w.inspect.should eql("dbacl")
    @w.T = nil
    @w.inspect.should eql("dbacl")
  end
  
  it "should be able to take a filename" do
    Wrapper.new(:filename => 'some_file.txt').inspect.should eql("dbacl some_file.txt")
    @w.filename = 'some_file.txt'
    @w.inspect.should eql("dbacl some_file.txt")
  end
  
  it "should be able to pass in text" do
    Wrapper.new(:text => 'some text').inspect.should eql(%{echo "some text" \| dbacl})
    @w.text = 'some text'
    @w.inspect.should eql(%{echo "some text" \| dbacl})
  end
  
  it "should ignore the filename if both the text and filename are passed in" do
    @w.filename = 'some_file.txt'
    @w.text = 'some text'
    @w.inspect.should eql(%{echo "some text" \| dbacl})
  end
  
  it "should have a version mode" do
    @w.V = true
    @w.inspect.should eql("dbacl -V")
  end
  
  it "should ignore everything but V if using V" do
    @w.T = :text
    @w.V = true
    @w.inspect.should eql("dbacl -V")
  end
  
  it "should be able to have more than one category" do
    @w.categories << :one
    @w.categories << :two
    @w.categories.should eql([:one, :two])
    @w.inspect.should eql("dbacl -c one -c two")
  end
  
  it "should take an array of categories at intialize" do
    Wrapper.new(:c => [:one, :two]).inspect.should eql("dbacl -c one -c two")
    Wrapper.new(:classes => [:one, :two]).inspect.should eql("dbacl -c one -c two")
    @w.classes = [:one, :two]
    @w.inspect.should eql("dbacl -c one -c two")
  end
  
  it "should use << to push to the classifications list" do
    @w << :one
    @w.inspect.should eql("dbacl -c one")
  end
  
  it "should be able to preload weights" do
    check_signature_with_new('dbacl -1', :preloading => true)
    check_signature('dbacl -1') {|r| r.preloading = true}
  end

  it "should be able to produce a dump mode" do
    check_signature_with_new('dbacl -d', :dump => true)
    check_signature_with_new('dbacl -d', :d => true)
    check_signature('dbacl -d') {|r| r.dump = true}
    check_signature('dbacl -d') {|r| r.d = true}
  end
  
  it "should be able to produce a verbose mode" do
    check_signature_with_new('dbacl -v', :verbose => true)
    check_signature_with_new('dbacl -v', :v => true)
    check_signature('dbacl -v') {|r| r.verbose = true}
    check_signature('dbacl -v') {|r| r.v = true}
  end

  it "should be able to produce a printing scores mode" do
    check_signature_with_new('dbacl -n', :print_scores => true)
    check_signature_with_new('dbacl -n', :n => true)
    check_signature('dbacl -n') {|r| r.print_scores = true}
    check_signature('dbacl -n') {|r| r.n = true}
  end

  it "should be able to produce an internationalized mode" do
    check_signature_with_new('dbacl -i', :internationalized => true)
    check_signature_with_new('dbacl -i', :i => true)
    check_signature('dbacl -i') {|r| r.internationalized = true}
    check_signature('dbacl -i') {|r| r.i = true}
  end

  it "should be able to produce a reference mode" do
    check_signature_with_new('dbacl -r', :digramic_reference_only => true)
    check_signature_with_new('dbacl -r', :reference_only => true)
    check_signature_with_new('dbacl -r', :r => true)
    check_signature('dbacl -r') {|r| r.digramic_reference_only = true}
    check_signature('dbacl -r') {|r| r.reference_only = true}
    check_signature('dbacl -r') {|r| r.r = true}
  end

  it "should be able to lock classifications into memory to reduce swapping on large data sets" do
    check_signature_with_new('dbacl -m', :aggressively_use_memory => true)
    check_signature_with_new('dbacl -m', :memory_lock => true)
    check_signature_with_new('dbacl -m', :m => true)
    check_signature('dbacl -m') {|r| r.aggressively_use_memory = true}
    check_signature('dbacl -m') {|r| r.memory_lock = true}
    check_signature('dbacl -m') {|r| r.m = true}
  end
  
  it "should be able to set the number of n-grams unless g is set" do
    check_signature_with_new('dbacl -w2', :num_n_grams => 2)
    check_signature_with_new('dbacl -w2', :w => 2)
    check_signature('dbacl -w2') {|r| r.num_n_grams = 2}
    check_signature('dbacl -w2') {|r| r.w = 2}
    check_signature('dbacl -w2') {|r| r.w = "2"}
    check_signature('dbacl -w2') {|r| r.w = "2.1"}
    check_signature('dbacl -w2') {|r| r.w = 2.1}
    @w.w = 2
    @w.g = true # May change, once I define g
    @w.inspect.should_not match(/\-w/)
  end
  
  it "should be able to force multinomial calculations" do
    check_signature_with_new('dbacl -M', :force_multinomial => true)
    check_signature_with_new('dbacl -M', :M => true)
    check_signature('dbacl -M') {|r| r.force_multinomial = true}
    check_signature('dbacl -M') {|r| r.M = true}
  end
  
  it "should be able to print posterior probabilities" do
    check_signature_with_new('dbacl -N', :print_posteriors => true)
    check_signature_with_new('dbacl -N', :N => true)
    check_signature('dbacl -N') {|r| r.print_posteriors = true}
    check_signature('dbacl -N') {|r| r.N = true}
  end
  
  it "should have a debug mode" do
    check_signature_with_new('dbacl -D', :debug => true)
    check_signature_with_new('dbacl -D', :D => true)
    check_signature('dbacl -D') {|r| r.debug = true}
    check_signature('dbacl -D') {|r| r.D = true}
  end
  
  it "should be able to show the confidence scores" do
    check_signature_with_new('dbacl -X', :show_confidence => true)
    check_signature_with_new('dbacl -X', :X => true)
    check_signature('dbacl -X') {|r| r.show_confidence = true}
    check_signature('dbacl -X') {|r| r.X = true}
  end

  it "should be able to set the number of n-grams on the same line unless g is set" do
    check_signature_with_new('dbacl -W2', :num_same_line_n_grams => 2)
    check_signature_with_new('dbacl -W2', :W => 2)
    check_signature('dbacl -W2') {|r| r.num_same_line_n_grams = 2}
    check_signature('dbacl -W2') {|r| r.W = 2}
    check_signature('dbacl -W2') {|r| r.W = "2"}
    check_signature('dbacl -W2') {|r| r.W = "2.1"}
    check_signature('dbacl -W2') {|r| r.W = 2.1}
    @w.W = 2
    @w.g = true # May change, once I define g
    @w.inspect.should_not match(/\-W/)
  end
  
  it "should be able to set the minimim size of the hash table" do
    check_signature_with_new('dbacl -h2', :hash_table_size => 2)
    check_signature_with_new('dbacl -h2', :h => 2)
    check_signature_with_new('dbacl -h2', :h => "2")
    check_signature('dbacl -h2') {|r| r.hash_table_size = 2}
    check_signature('dbacl -h2') {|r| r.h = 2}
    check_signature('dbacl -h2') {|r| r.h = "2"}
  end
  
  it "should be able to set the maximum size of the hash table" do
    check_signature_with_new('dbacl -H2', :hash_table_max => 2)
    check_signature_with_new('dbacl -H2', :H => 2)
    check_signature_with_new('dbacl -H2', :H => "2")
    check_signature('dbacl -H2') {|r| r.hash_table_max = 2}
    check_signature('dbacl -H2') {|r| r.H = 2}
    check_signature('dbacl -H2') {|r| r.H = "2"}
  end
  
  it "should be able to force a decimation probability to reduce memory requirements.  Uses 1 - 2^(-x)." do
    check_signature_with_new('dbacl -x0.3', :decimation_probability => 0.3)
    check_signature_with_new('dbacl -x0.3', :x => 0.3)
    check_signature_with_new('dbacl -x0.3', :x => "0.3")
    check_signature('dbacl -x0.3') {|r| r.decimation_probability = 0.3}
    check_signature('dbacl -x0.3') {|r| r.x = 0.3}
    check_signature('dbacl -x0.3') {|r| r.x = "0.3"}
  end
  
  it "should be able to set the quality threshold to 1, 2, 3, or 4" do
    check_signature_with_new('dbacl -q1', :quality => 1)
    check_signature_with_new('dbacl -q1', :q => 1)
    check_signature('dbacl -q1') {|r| r.quality = 1}
    check_signature('dbacl -q1') {|r| r.q = 1}
    check_signature('dbacl -q1') {|r| r.q = "1"}
    check_signature('dbacl -q2') {|r| r.q = 2}
    check_signature('dbacl -q3') {|r| r.q = 3}
    check_signature('dbacl -q4') {|r| r.q = 4}
    check_signature('dbacl') {|r| r.q = 5}
    check_signature('dbacl') {|r| r.q = nil}
    check_signature('dbacl') {|r| r.q = "other"}
  end
  
  it "should be able to set the tokenizing class to alpha, alnum, graph, cef, or adp" do
    check_signature_with_new('dbacl -e alpha', :tokenization => :alpha)
    check_signature_with_new('dbacl -e alpha', :e => :alpha)
    check_signature('dbacl -e alpha') {|r| r.tokenization = :alpha}
    check_signature('dbacl -e alpha') {|r| r.e = :alpha}
    check_signature('dbacl -e alnum') {|r| r.e = :alnum}
    check_signature('dbacl -e graph') {|r| r.e = :graph}
    check_signature('dbacl -e cef') {|r| r.e = :cef}
    check_signature('dbacl -e adp') {|r| r.e = :adp}
    check_signature('dbacl -e alpha') {|r| r.e = 'alpha'}
    check_signature('dbacl -e alnum') {|r| r.e = 'alnum'}
    check_signature('dbacl -e graph') {|r| r.e = 'graph'}
    check_signature('dbacl -e cef') {|r| r.e = 'cef'}
    check_signature('dbacl -e adp') {|r| r.e = 'adp'}
    check_signature('dbacl') {|r| r.e = nil}
    check_signature('dbacl') {|r| r.e = :other}
    check_signature('dbacl') {|r| r.e = 1}
  end
  
  it "should have an online mode" do
    check_signature_with_new('dbacl -o', :online => true)
    check_signature_with_new('dbacl -o', :o => true)
    check_signature('dbacl -o') {|r| r.online = true}
    check_signature('dbacl -o') {|r| r.o = true}
  end
  
  it "should be able to set the digramic reference measure to uniform, dirichlet, or maxent" do
    check_signature_with_new('dbacl -L uniform', :reference_measure => :uniform)
    check_signature_with_new('dbacl -L uniform', :L => :uniform)
    check_signature('dbacl -L uniform') {|r| r.reference_measure = :uniform}
    check_signature('dbacl -L uniform') {|r| r.L = :uniform}
    check_signature('dbacl -L dirichlet') {|r| r.L = :dirichlet}
    check_signature('dbacl -L maxent') {|r| r.L = :maxent}
    check_signature('dbacl -L uniform') {|r| r.L = 'uniform'}
    check_signature('dbacl -L dirichlet') {|r| r.L = 'dirichlet'}
    check_signature('dbacl -L maxent') {|r| r.L = 'maxent'}
    check_signature('dbacl') {|r| r.L = :other}
  end

end

def standard_signature
  'dbacl'
end

def check_signature(changed_signature, &block)
  obj = Wrapper.new
  obj.inspect.should eql(standard_signature)
  block.call(obj)
  obj.inspect.should eql(changed_signature)
end

def check_signature_with_new(changed_signature, opts={})
  @w = Wrapper.new(opts)
  @w.inspect.should eql(changed_signature)
end
