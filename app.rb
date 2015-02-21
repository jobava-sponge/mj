require 'bundler'
Bundler.require

require "sinatra/reloader" if development?

def cleanup arr
  arr.map! { |str| str.gsub("\r", " ").gsub("\n", " ").gsub("\t", " ").gsub(' ', ' ').gsub('&amp;', '&').squeeze(" ").try(:strip) }
end

get '/' do
  # send_file './public/index.html'
end

get '/company' do
  # Get all companies from mongo
end

get '/company/:cui' do
  content_type :json
  cui = params[:cui]
  
  # check if data already exists in mongo
  
  # data doesn't exist in mongo, get data from mfinante
  agent = Mechanize.new
  page = agent.post("http://www.mfinante.ro/infocodfiscal.html", { "cod" => "#{cui}", "pagina" => "domenii", "b1" => "VIZUALIZARE", "captcha" => "5bd"})
  keys = cleanup(page.search("//center[1]//tr//td[1]/font").map(&:text))
  vals = cleanup(page.search("//center[1]//tr//td[2]/font").map(&:text))
  Hash[keys.zip vals].to_json
  # Save data to mongo
end

delete '/company/:cui' do
end
