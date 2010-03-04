require 'sinatra'
require 'haml'
require 'sass'
require 'net/http'
require 'httparty'

PATTERN = %r|http://farm\d+.static.flickr.com/\d+/(\d+)_.+|

class Flickr
  include HTTParty
  base_uri "http://api.flickr.com/services/rest/"
  default_params :api_key => ENV['WHOSE_FLICKR_API_KEY']

  class << self
    def photo(id)
      get("", :query => {:method => "flickr.photos.getInfo", :photo_id => id})
    end

    def user(id)
      get("", :query => {:method => "flickr.people.getInfo", :user_id => id})
    end
  end
end

get '/' do
  if params[:url]
    @profile = fetch_profile(params[:url])
  end
  haml :index
end

get '/screen.css' do
  content_type "text/css"
  sass :screen
end

helpers do
  def fetch_profile(url)
    return unless id = url.match(PATTERN)
    uri = URI.parse(FLICKR_REST_URL)
    uri.query = QUERY + "&photo_id=" + id.captures.first
    @profile = Crack::XML.parse(Net::HTTP.get(uri))['rsp']
    haml :profile
  end
end
