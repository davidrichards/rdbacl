require File.join(File.dirname(__FILE__), "/../../spec_helper")

describe Runner do
  it "should allow you to set a pwd" do
    @r = Runner.new(:name => :name, :pwd => '/tmp')
    @r.pwd.should eql '/tmp'
  end
  
  it "should allow you to set a command" do
    @r = Runner.new(:name => :name, :cmd => 'pwd')
    @r.cmd.should eql('pwd')
  end
  
  it "should run a command" do
    @r = Runner.new(:name => :name, :cmd => 'pwd')
    lambda{@res = @r.run}.should_not raise_error
  end
  
  it "should change directories before running" do
    @r = Runner.new(:name => :name, :pwd => '/tmp', :cmd => 'pwd')
    @r.run.should eql("/tmp\n")
  end
  
  it "should store the result" do
    @r = Runner.new(:name => :name, :pwd => '/tmp', :cmd => 'pwd')
    @r.run
    @r.result.should eql("/tmp\n")
  end
  
  it "should require a name" do
    lambda{Runner.new}.should raise_error
    lambda{Runner.new(:name => :name)}.should_not raise_error
    Runner.new(:name => :name).name.should eql(:name)
  end
  
  it "should default the pwd first to local tmp if one exists" do
    File.stub!(:exist?).and_return(true)
    @r = Runner.new(:name => :name, :cmd => 'pwd')
    @r.pwd.should eql('tmp/name')
  end
  
  it "should take an optional wrapped dbacl command" do
    @w = Wrapper.new
    lambda{@r = Runner.new(:name => :name, :dbacl => @w)}.should_not raise_error
    @r.dbacl.should eql(@w)
  end
  
  it "should reset all classifications" do
    File.stub!(:exist).and_return(true)
    @r = Runner.new(:name => :name, :dbacl => Wrapper.new(:classes => %w(one two three)))
    @r.reset
  end
end

# There are some possible things to do here:
# allow for multiple commands in the runner?
# combine cmd with dbacl somehow
# finish the reset
# set the classify
# set the learn
# write the wrapped dbacl classes
# write the repository mixins