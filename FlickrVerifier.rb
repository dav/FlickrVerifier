require 'yaml'
require 'flickraw'
require 'pp'
require 'active_support/core_ext/object/blank'
require 'digest/md5'
require "open-uri"

CONFIG_FILE="config.yml"

config = YAML.load_file( CONFIG_FILE )

FlickRaw.api_key = config["flickr"]["api_key"]
FlickRaw.shared_secret= config["flickr"]["shared_secret"]

access_token = config["flickr"]["access_token"]
access_secret = config["flickr"]["access_secret"]

if access_token.nil? || access_secret.nil?
  token = flickr.get_request_token
  auth_url = flickr.get_authorize_url(token['oauth_token'], :perms => 'delete')

  puts "Open this url in your process to complete the authication process : #{auth_url}"
  puts "Copy here the number given when you complete the process."
  verify = gets.strip

  begin
    flickr.get_access_token(token['oauth_token'], token['oauth_token_secret'], verify)
    login = flickr.test.login
    puts "You are now authenticated as #{login.username} with token #{flickr.access_token} and secret #{flickr.access_secret}"
    config["flickr"]["access_token"] = flickr.access_token
    config["flickr"]["access_secret"] = flickr.access_secret
    File.open(CONFIG_FILE+".new", "w") do |f|
        f.write(YAML::dump(config))
    end
  rescue FlickRaw::FailedResponse => e
    puts "Authentication failed : #{e.msg}"
  end
else
  flickr.access_token = access_token
  flickr.access_secret = access_secret
end

def best_url(hash)
  %w(o l m).each do |type|
    url = hash["url_#{type}"]
    return url unless url.blank?
  end
  nil
end

def next_page
  STDERR.puts "Loading page #{@page}"
  results = flickr.photos.search :user_id => 'me', 
                      :page => @page, 
                      :sort => 'date-posted-desc', 
                      :extras => 'original_format,url_o,url_l,url_m,date_taken', 
                      :per_page => 500
  @page+=1
  return results
end

@page = 1
results = next_page
while results && results.size > 0 do
  results.each do |result|
    url = best_url(result)
    unless url.blank?
      open(url) {|f|
        md5 = Digest::MD5.hexdigest(f.read)
        puts "#{result["datetaken"]}\t#{md5}\t#{best_url(result)}"
      }
    end
  end
  results = next_page
end
