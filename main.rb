# frozen_string_literal: true

require 'sinatra/reloader'
require 'sinatra'
require 'pg'
require 'cgi'
require 'debug'

def conn
  @conn ||= PG.connect(dbname: 'postgres')
end

def read_memos
  conn.exec('select * from memos;')
end

def post_memo(title, content)
  conn.exec('insert into memos(title, content) values($1,$2);', [title,content])
end

configure do
  result = conn.exec("select * from information_schema.tables where table_name = 'memos';")
  conn.exec('create table memos (id serial, title varchar(255), content text);') if result.values.empty?
end

before do
  @page_title = 'メモアプリ'
end

get '/' do
  @all_memos = read_memos
  erb :index
end

get '/new' do
  erb :new
end

get %r{/(\d+)} do |id|
  @memo = read_json[id]
  erb :show
end

get %r{/(\d+)/edit} do |id|
  @page_title = 'メモ編集'
  @memo = read_json[id]
  erb :edit
end

post '/new' do
  post_memo(params['title'], params['content'])
  redirect '/'
end

patch %r{/(\d+)/edit} do |id|
  old_data = read_json
  old_data[id] = { 'id' => id.to_i, 'title' => params['title'], 'content' => params['content'] }
  write_json(old_data)
  redirect "/#{id}"
end

delete %r{/(\d+)/delete} do |id|
  old_data = read_json
  old_data.delete(id)
  write_json(old_data)
  redirect '/'
end

not_found do
  'Something went wrong,
  but we\'re working on it.'
end
