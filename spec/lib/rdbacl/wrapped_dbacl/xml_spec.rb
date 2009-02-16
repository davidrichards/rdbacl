require File.join(File.dirname(__FILE__), "/../../../spec_helper")

describe Xml do
  it "should have a type of :xml" do
    Xml.new.T.should eql(:xml)
    Xml.new(:type => :text).T.should eql(:xml)
  end
end