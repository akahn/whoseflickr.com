require 'sinatra'
require 'haml'
require 'sass'
require 'net/http'
require 'json'

INFO_URI = "http://api.flickr.com/services/rest/"
QUERY = "method=flickr.photos.getInfo&api_key=197e2adb7e0ffd30a7441537726f756f"
PATTERN = %r|http://farm\d+.static.flickr.com/\d+/(\d+)_.+.jpg|

get '/' do
  if params[:url]
    @profile = photo_profile(params[:url])
  end
  haml :index
end

get '/screen.css' do
  content_type "text/css"
  sass :screen
end

helpers do
  def photo_profile(url)
    return unless id = url.match(PATTERN)
    uri = URI.parse(INFO_URI)
    uri.query = QUERY + "&photo_id=" + id.captures.first
    Net::HTTP.get(uri)
  end
end
