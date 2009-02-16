require File.join(File.dirname(__FILE__), "/../../../spec_helper")

describe Text do
  it "should have a type of :email" do
    Text.new.T.should eql(:text)
    Text.new(:type => :email).T.should eql(:text)
  end
end