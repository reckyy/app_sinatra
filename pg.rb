# frozen_string_literal: true

require_relative 'main'

def create_db
  conn.exec('create table memos (id serial, title varchar(255), content text);')
end
