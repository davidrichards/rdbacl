require File.join(File.dirname(__FILE__), "/../../../spec_helper")

describe Html do
  it "should have a type of :html" do
    Html.new.T.should eql(:html)
    Html.new(:type => :text).T.should eql(:html)
  end
end