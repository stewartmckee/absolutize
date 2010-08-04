require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Absolutize do

  before(:each) do
    @base_url = "http://www.baseurl.com/" 
    @absolutize = Absolutize.new(@base_url)
  end

  it "should create an Absolutize object" do
    @absolutize.should be_an_instance_of Absolutize
  end
  
  it "should return the same url for an absolute url" do
    @absolutize.url("http://www.bbc.co.uk/").to_s.should == "http://www.bbc.co.uk/" 
  end
  it "should return the absolute url for a relative to root url" do
    @absolutize.url("/asdf.html").to_s.should == "http://www.baseurl.com/asdf.html" 
  end
  it "should return the absolute url for a relative to folder url" do
    @absolutize.url("asdf.html").to_s.should == "http://www.baseurl.com/asdf.html" 
  end  
end 
