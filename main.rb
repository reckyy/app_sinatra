require 'sinatra/reloader'
require 'sinatra'
require 'json'

get '/' do
  @page_title = 'メモアプリ'
	File.open('db.json', 'r') { |io| 
		@json = JSON.load(io)
  }
	erb :index
end

get '/new' do
  @page_title = 'メモアプリ'
  erb :new
end

post '/new' do
  @page_title = 'メモアプリ'
  old_data_json = File.read('db.json')
  old_data = JSON.parse(old_data_json)
  old_data.push({"id" => old_data.size + 1, "title" => params['title'], "content" => params['content']})
  pushed_data = JSON.dump(old_data)
  File.write('db.json', pushed_data)
  redirect '/'
end
