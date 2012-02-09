require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Absolutize do

  before(:each) do
    @base_url = "http://www.baseurl.com/"   
  end

  describe "with default parameters" do
    before(:each) do
      @absolutize = Absolutize.new(@base_url)
    end
  
    it "should create an Absolutize object" do
      @absolutize.should be_an_instance_of Absolutize
    end
    
    it "should return the same url for an absolute url" do
      @absolutize.url("http://www.bbc.co.uk/").to_s.should == "http://www.bbc.co.uk/" 
    end
    it "should return the same url for an absolute url" do
      @absolutize.url("http://www.bbc.co.uk//asdf/asdf.html").to_s.should == "http://www.bbc.co.uk//asdf/asdf.html"
    end

    it "should return the correct absolute URL when the url is already encoded" do
      ab = Absolutize.new("http://www.baseurl.com/top_folder/index.html")
      ab.url("%2ftop_folder%2fsub_folder%2findex.html").to_s.should == "http://www.baseurl.com/top_folder/sub_folder/index.html"
      ab.url("/top_folder/sub_folder/index.html").to_s.should == "http://www.baseurl.com/top_folder/sub_folder/index.html"
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
    it "should encode with pipes" do
      @absolutize.url("/root%20folder/asdf.html?lang=en|us").to_s.should == "http://www.baseurl.com/root%20folder/asdf.html?lang=en%7Cus"         
    end
    it "should not raise an exception with really bad url" do
      @absolutize.url("http://.asdf.com/").to_s.should == "http://.asdf.com/"
    end
    it "should return the base url + '#' for '#'" do
      @absolutize.url("#").to_s.should == "#{@base_url}#"
    end
  end
  
  describe "with remove_anchors true" do
    before(:each) do 
      @absolutize = Absolutize.new(@base_url, :remove_anchors => true)
    end
    it "should remove an anchor" do
      @absolutize.url("/root folder/asdf.html#anchor").to_s.should == "http://www.baseurl.com/root%20folder/asdf.html"     
    end
    it "should return the base url for the url '#'" do
      @absolutize.url("#").to_s.should == @base_url        
    end
  end
  
  describe "with force_escaping false" do
    before(:each) do
      @absolutize = Absolutize.new(@base_url, :force_escaping => false)
    end
    it "should not escape invalid characters" do
      ab = Absolutize.new("http://www.baseurl.com/top_folder/index.html", :force_escaping => false)
      
      #this example should be decoded first, but we are checking that when force_escaping is off it does not
      ab.url("%2ftop_folder%2fsub_folder%2findex.html").to_s.should == "http://www.baseurl.com/top_folder/%2ftop_folder%2fsub_folder%2findex.html"
      ab.url("/top_folder/sub_folder/index.html").to_s.should == "http://www.baseurl.com/top_folder/sub_folder/index.html"
    end
  end
  
  describe "with raise_exceptions true" do
    before(:each) do
      @absolutize = Absolutize.new(@base_url, :raise_exceptions => true)
    end
    it "should not raise an exception when a valid url is given" do
      lambda { @absolutize.url("http://www.asdf.com/rootfolder/asdf.html#anchor")}.should_not raise_error
    end
    
    it "should not raise an exception when a fixable url is given" do
      lambda { @absolutize.url("http://www.asdf.com/root folder[1]/asdf.html#anchor")}.should_not raise_error    
    end 
  end
end 
