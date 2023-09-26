# frozen_string_literal: true

require 'sinatra/reloader'
require 'sinatra'
require 'json'
require 'cgi'

def read_json
  JSON.parse(File.read('db.json'))
end

def judge_request(json)
  memo_title = CGI.escapeHTML(params['title'])
  memo_content = CGI.escapeHTML(params['content'])
  if request.request_method == 'POST'
    id = json.size + 1
    json.push({ 'id' => id, 'title' => memo_title, 'content' => memo_content })
  else
    json[@id - 1] = { 'id' => @id, 'title' => memo_title, 'content' => memo_content }
  end
end

def edit_db
  old_data = read_json
  judge_request(old_data)
  pushed_data = JSON.dump(old_data)
  File.write('db.json', pushed_data)
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

get %r{/(\d+)} do |id|
  @id = id.to_i
  @json = read_json
  erb :show
end

get %r{/(\d+)/edit} do |id|
  @page_title = 'メモ編集'
  @id = id.to_i
  @json = read_json
  erb :edit
end

post '/new' do
  edit_db
  redirect '/'
end

patch %r{/(\d+)/edit} do |id|
  @id = id.to_i
  edit_db
  redirect "/#{@id}"
end

delete %r{/(\d+)/edit} do |id|
  @id = id.to_i
  old_data = read_json
  old_data.delete_at(@id - 1)
  new_data = JSON.dump(old_data)
  File.write('db.json', new_data)
  redirect '/'
end

not_found do
  'Something went wrong,
  but we\'re working on it.'
end
