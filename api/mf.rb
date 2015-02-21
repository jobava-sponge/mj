require 'sinatra/base'
require 'sinatra/reloader' if development?
require './helpers/database'

module API
  class Mf < Sinatra::Application
    set :db, Helpers::Database.new().connect()
    
    def cleanup arr
      arr.map! { |str| str.gsub("\r", " ").gsub("\n", " ").gsub("\t", " ").gsub(' ', ' ').gsub('&amp;', '&').squeeze(" ").try(:strip) }
    end

    namespace '/api/v1' do
      get '/' do
        # send_file './public/index.html'
      end

      get '/companies' do
        content_type :json
        coll = settings.db.collection('companies')
        coll.find.to_a.to_json
      end

      get '/company/:cui' do
        content_type :json
        cui = params[:cui]
        coll = settings.db.collection('companies')
        record = coll.find_one({:_id => "#{cui}"})

        if record
          return record.to_json
        else
          # data doesn't exist in mongo, get data from mfinante and save it
          agent = Mechanize.new
          page = agent.post("http://www.mfinante.ro/infocodfiscal.html", { "cod" => "#{cui}", "pagina" => "domenii", "b1" => "VIZUALIZARE", "captcha" => "5bd"})
          keys = cleanup(page.search("//center[1]//tr//td[1]/font").map(&:text))
          vals = cleanup(page.search("//center[1]//tr//td[2]/font").map(&:text))
          data = Hash[keys.zip vals]
          
          if data.empty?
            halt 404, { message: "Not found", status: 404 }.to_json
          else
            obj = { :_id => "#{cui}", "data" => data }
            coll.insert(obj)
            return obj.to_json
          end
        end
      end

      delete '/company/:cui' do
      end
      
    end
  end
end