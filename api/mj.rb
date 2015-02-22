require 'sinatra/base'
require 'sinatra/reloader' if development?
require './helpers/database'
require 'savon'
require 'nori'
require './helpers/soap'

module API
  class Mj < Sinatra::Application
    set :db, Helpers::Database.new().connect()
    
    namespace '/api/v1' do
      get '/filldb/:institution' do
        coll = settings.db.collection('institutionsFiles')
        obj = Helpers::Soap.get_inst(params[:institution])
        coll.insert(obj)
        status 201
      end
    end

  end

end
