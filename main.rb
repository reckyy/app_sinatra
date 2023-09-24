# frozen_string_literal: true

require 'sinatra/reloader'
require 'sinatra'
require 'json'
require 'cgi'

def read_json
  JSON.parse(File.read('db.json'))
end

before do
  @page_title = 'メモアプリ'
end

get '/' do
  @json = read_json
  erb :index
end

get '/new' do
  erb :new
end

get '/:id' do
  @id = params[:id].to_i
  @json = read_json
  erb :show
end

get '/:id/edit' do
  @page_title = 'メモ編集'
  @id = params[:id].to_i
  @json = read_json
  erb :edit
end

post '/new' do
  old_data = read_json
  memo_title = CGI.escapeHTML(params['title'])
  memo_content = CGI.escapeHTML(params['content'])
  old_data.push({ 'id' => old_data.size + 1, 'title' => memo_title, 'content' => memo_content })
  pushed_data = JSON.dump(old_data)
  File.write('db.json', pushed_data)
  redirect '/'
end

patch '/:id/edit' do
  @id = params[:id].to_i
  old_data = read_json
  memo_title = CGI.escapeHTML(params['title'])
  memo_content = CGI.escapeHTML(params['content'])
  old_data[@id - 1] = { 'id' => @id, 'title' => memo_title, 'content' => memo_content }
  pushed_data = JSON.dump(old_data)
  File.write('db.json', pushed_data)
  redirect "/#{@id}"
end

delete '/:id/edit' do
  @id = params[:id].to_i
  old_data = read_json
  old_data.delete_at(@id - 1)
  new_data = JSON.dump(old_data)
  File.write('db.json', new_data)
  redirect '/'
end
