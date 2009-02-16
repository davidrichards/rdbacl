require File.join(File.dirname(__FILE__), "/../../../spec_helper")

describe Email do
  it "should have a type of :email" do
    Email.new.T.should eql(:email)
    Email.new(:type => :text).T.should eql(:email)
  end
end