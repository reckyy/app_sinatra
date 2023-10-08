# frozen_string_literal: true

require 'sinatra/reloader'
require 'sinatra'
require 'json'
require 'cgi'

def read_json
  JSON.parse(File.read('db.json'))
end

def judge_request(json)
  if request.request_method == 'POST'
    id = json.empty? ? 1 : json.keys.last.to_i + 1
    json[id.to_s] = { 'id' => id, 'title' => params['title'], 'content' => params['content'] }
  else
    json[@id.to_s] = { 'id' => @id, 'title' => params['title'], 'content' => params['content'] }
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
  unless File.exist?('db.json')
    File.write('db.json', '{}')
  end
end

get '/' do
  @json = read_json
  erb :index
end

get '/new' do
  erb :new
end

get %r{/(\d+)} do |id|
  @id = id
  @json = read_json
  erb :show
end

get %r{/(\d+)/edit} do |id|
  @page_title = 'メモ編集'
  @id = id
  @json = read_json
  erb :edit
end

post '/new' do
  edit_db
  redirect '/'
end

patch %r{/(\d+)/edit} do |id|
  @id = id
  edit_db
  redirect "/#{@id}"
end

delete %r{/(\d+)/edit} do |id|
  @id = id
  old_data = read_json
  old_data.delete(@id)
  new_data = JSON.dump(old_data)
  File.write('db.json', new_data)
  redirect '/'
end

not_found do
  'Something went wrong,
  but we\'re working on it.'
end
