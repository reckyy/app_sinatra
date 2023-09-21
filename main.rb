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
