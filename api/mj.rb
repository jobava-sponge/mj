require 'sinatra/base'
require 'sinatra/reloader' if development?
require './helpers/database'
require 'savon'

module API
  class Mj < Sinatra::Application
    #set :db, Helpers::Database.new().connect()
    
    namespace '/api/v1' do
      get '/' do
        content_type :json
        client = Savon.client(endpoint: "http://portalquery.just.ro/Query.asmx", wsdl: "http://portalquery.just.ro/Query.asmx?WSDL", pretty_print_xml: true)
        message = {institutie: "TribunalulTIMIS"}
        response = client.call(:cautare_dosare, message: message)
        response.body.to_json
      end
    end

  end
end
