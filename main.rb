# frozen_string_literal: true

require 'sinatra/reloader'
require 'sinatra'
require 'json'
require 'cgi'

DB_PATH = 'db.json'

def read_json
  JSON.parse(File.read(DB_PATH))
end

def write_json(data)
  File.write(DB_PATH, JSON.dump(data))
end

before do
  @page_title = 'メモアプリ'
  File.write(DB_PATH, '{}') unless File.exist?('db.json')
end

get '/' do
  @all_memos = read_json
  erb :index
end

get '/new' do
  erb :new
end

get %r{/(\d+)} do |id|
  @id = id
  @all_memos = read_json
  erb :show
end

get %r{/(\d+)/edit} do |id|
  @page_title = 'メモ編集'
  @id = id
  @all_memos = read_json
  erb :edit
end

post '/new' do
  old_data = read_json
  id = old_data.empty? ? 1 : old_data.keys.last.to_i + 1
  old_data[id.to_s] = { 'id' => id, 'title' => params['title'], 'content' => params['content'] }
  write_json(old_data)
  redirect '/'
end

patch %r{/(\d+)/edit} do |id|
  @id = id
  old_data = read_json
  old_data[@id.to_s] = { 'id' => @id.to_i, 'title' => params['title'], 'content' => params['content'] }
  write_json(old_data)
  redirect "/#{@id}"
end

delete %r{/(\d+)/edit} do |id|
  @id = id
  old_data = read_json
  old_data.delete(@id)
  write_json(old_data)
  redirect '/'
end

not_found do
  'Something went wrong,
  but we\'re working on it.'
end
