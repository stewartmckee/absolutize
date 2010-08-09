require 'rubygems'
require 'uri'
require File.expand_path(File.dirname(__FILE__) + '/absolutize')

class Absolutize

  def initialize(base_url, options = {})
    @base_url = base_url
    @options = options
    
    @options[:remove_anchors] = false if @options[:remove_anchors].nil? 
    @options[:force_escaping] = true if @options[:force_escaping].nil?
    @options[:output_debug] = false if @options[:output_debug].nil?
  end
  
  def url(relative_url)
    # encode the url if the new url contains spaces but doesn't contain %, i.e isn't already encoded
    relative_url = relative_url.split("#").first if relative_url.include?"#" and @options[:remove_anchors]
    relative_url = URI.encode(relative_url, " <>\{\}|\\\^\[\]|`") if @options[:force_escaping]
    
    absolute_url = nil
    begin
      absolute_url = URI.join(@base_url, relative_url)
    rescue URI::InvalidURIError => urie
      puts "Unable to use URI.join attempting manually" if @options[:output_debug]
      if @base_url =~ /\Ahttp/ and relative_url =~ /\A\//
        puts "base url starts with http and relative_url is relative to root" if @options[:output_debug]
        uri = URI.parse(@base_url)
        if uri.port
          absolute_url = URI.parse("#{uri.scheme}://#{uri.host}:#{uri.port}#{relative_url}")
        else
          absolute_url = URI.parse("#{uri.scheme}://#{uri.host}#{relative_url}")
        end
      elsif relative_url =~ /\Ahttp/
        #new url is absolute anyway
        absolute_url = URI.parse(relative_url)
      else
        raise "Unable to absolutize #{base_url} and #{relative_url}"
      end
    end
    
    # remove any double slashes in the path
    absolute_url.path = absolute_url.path.gsub("//", "/") unless absolute_url.path.nil?
    
    absolute_url
  end
end