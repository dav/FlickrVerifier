require 'yaml'
require 'flickraw'
require 'pp'

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

results = flickr.photos.search :user_id => 'me', :page => 1, :sort => 'date-posted-asc', :extras => 'original_format,url_o,date_taken', :per_page => 10
results.each do |result|
  puts "#{result["datetaken"]}\t#{result['url_o']}"
end

pp results[0]
