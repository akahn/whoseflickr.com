require 'sinatra'
require 'haml'
require 'sass'
require 'net/http'
require 'httparty'

PATTERN = %r|http://farm\d+.static.flickr.com/\d+/(\d+)_.+|

class Flickr
  include HTTParty
  base_uri "http://api.flickr.com/services/rest"
  default_params :api_key => ENV['WHOSE_FLICKR_API_KEY']

  class << self
    def photo(id)
      get("/", :query => {:method => "flickr.photos.getInfo", :photo_id => id})
    end

    def user(id)
      get("/", :query => {:method => "flickr.people.getInfo", :user_id => id})
    end
  end
end

get '/' do
  expires 86400 # One day
  if params[:url] && id = params[:url].match(PATTERN)
    @photo = Flickr.photo(id.captures.first)['rsp']
    @user = Flickr.user(@photo['photo']['owner']['nsid'])
  end
  haml :index
end

get '/screen.css' do
  expires 86400
  content_type "text/css"
  sass :screen
end
