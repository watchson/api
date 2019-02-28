require 'sinatra/base'
require 'json'

class Sinatra::Base

  before do
    content_type 'application/json'
  end

  get '/health' do
    'ok'
  end
end
