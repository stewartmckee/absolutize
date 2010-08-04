require 'rubygems'
require 'uri'
require File.expand_path(File.dirname(__FILE__) + '/absolutize')

class Absolutize

  def initialize(base_url, options = {})
    @base_url = base_url
    @options = options
    
    @options[:remove_anchors] = false
    @options[:force_escaping] = true
    
  end
  
  def url(new_url)
    # encode the url if the new url contains spaces but doesn't contain %, i.e isn't already encoded
    new_url = new_url.split("#").first if new_url.include?"#" and @options[:remove_anchors]
    new_url = URI.encode(new_url, " <>\{\}|\\\^\[\]`") if not new_url =~ /%/ and @options[:force_escaping]
    begin
      URI.join(@base_url, new_url).to_s
    rescue URI::InvalidURIError => urie
      puts "Unable to use URI.join attempting manually"
      if @base_url =~ /\Ahttp/ and new_url =~ /\A\//
        puts "base url starts with htt and new_url is relative to root"
        uri = URI.parse(@base_url)
        if uri.port
          "#{uri.scheme}://#{uri.host}:#{uri.port}#{new_url}"
        else
          "#{uri.scheme}://#{uri.host}#{new_url}"
        end
      elsif new_url =~ /\Ahttp/
        #new url is absolute anyway
        new_url
      else
        raise "Unable to absolutize #{base_url} and #{new_url}"
      end
    end 
    
    ### remove double slashes
  end
end