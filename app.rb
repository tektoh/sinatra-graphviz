require 'sinatra'
require 'uri'
require 'open-uri'
require 'ruby-graphviz'

get '/' do
  url = request.query_string

  unless url =~ URI::regexp
    status 400 # Bad Request
    return
  end

  body = 'Error'

  begin
    open url do |f|
      body = GraphViz.parse_string(f.read).output(:png => String)
      content_type "image/png"
    end
  rescue OpenURI::HTTPError => error
    res = error.io
    body = "#{res.status[0]} #{res.status[1]} : #{url}"
  end

  return body
end
