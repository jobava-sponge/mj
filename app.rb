require 'bundler'
Bundler.require

class Company
  # define property here
end

get '/' do
  # send_file './public/index.html'
end

get '/company' do
  content_type :json
  @company = Company.all(:order => :created_at.desc)
  @company.to_json
end

post '/company/new/:cui' do
  content_type :json
end

get '/company/:id' do
  content_type :json
  @company = Company.get(params[:id].to_i)

  if @company
    @company.to_json
  else
    halt 404
  end
end

delete '/company/:id/delete' do
  content_type :json
  @company = Company.get(params[:id].to_i)

  if @company.destroy
    {:success => "ok"}.to_json
  else
    halt 500
  end
end
