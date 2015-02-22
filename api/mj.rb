require 'sinatra/base'
require 'sinatra/reloader' if development?
require './helpers/database'
require 'savon'
require 'nori'
require './helpers/soap'
require 'pp'

module API
  class Mj < Sinatra::Application
    set :db, Helpers::Database.new().connect()
    
    namespace '/api/v1' do
      get '/filldb/:institution' do
        coll = settings.db.collection('institutionsFiles')
        obj = Helpers::Soap.new().get_inst(params[:institution])
        
        obj.each do |key,val|
            val = val.to_json
            val = val.hash
            coll.insert(val)
        end
        
        #coll.insert(obj)
        status 201
      end
    end

  end

end
