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

get '/:id' do
	@page_title = 'メモアプリ'
	@id = params[:id].to_i
	File.open('db.json', 'r') { |io| 
		@json = JSON.load(io)
  }
	erb :show
end

get '/:id/edit' do
  @page_title = 'メモ編集'
  @id = params[:id].to_i
  File.open('db.json', 'r') { |io| 
		@json = JSON.load(io)
  }
  erb :edit
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

patch '/:id/edit' do
  @id = params[:id].to_i
  old_data_json = File.read('db.json')
  old_data = JSON.parse(old_data_json)
  old_data[@id - 1] = {"id" => @id, "title" => params['title'], "content" => params['content']}
  pushed_data = JSON.dump(old_data)
  File.write('db.json', pushed_data)
  redirect "/#{@id}"
end
