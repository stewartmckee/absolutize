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
  it "should return the same url for an absolute url" do
    @absolutize.url("http://www.bbc.co.uk//asdf/asdf.html").to_s.should == "http://www.bbc.co.uk/asdf/asdf.html" 
  end
  it "should return the absolute url for a relative to root url" do
    @absolutize.url("/asdf.html").to_s.should == "http://www.baseurl.com/asdf.html" 
  end
  it "should return the absolute url for a relative to folder url" do
    @absolutize.url("asdf.html").to_s.should == "http://www.baseurl.com/asdf.html" 
  end  
  it "should handle urls with spaces" do
    @absolutize.url("/root folder/asdf.html").to_s.should == "http://www.baseurl.com/root%20folder/asdf.html"     
  end
  it "should handle urls with ['s" do
    @absolutize.url("/folder/asdf.html?id=[asdf]").to_s.should == "http://www.baseurl.com/folder/asdf.html?id=%5Basdf%5D"         
  end
  it "should not encode urls with %'s" do
    @absolutize.url("/root%20folder/asdf.html?id=asdf").to_s.should == "http://www.baseurl.com/root%20folder/asdf.html?id=asdf"         
  end
  it "should not encode existing encoded characters" do
    @absolutize.url("/root%20folder/asdf.html?id=[asdf]").to_s.should == "http://www.baseurl.com/root%20folder/asdf.html?id=%5Basdf%5D"         
  end
end 
