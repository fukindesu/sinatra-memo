# frozen_string_literal: true

require 'sinatra'
require 'erb'
require 'securerandom'
require 'sinatra/reloader'
require 'pg'

APP_NAME = 'メモアプリ'

before do
  @conn = connect_db
end

module MemoUtils
  def connect_db
    PG.connect(dbname: 'sinatra_memo')
  end

  def load_memos
    memos = []
    prepared_name = 'load_memos'
    @conn.prepare(prepared_name, 'select * from memos')
    @conn.exec_prepared(prepared_name).each do |row|
      memos << {
        'id' => row['id'],
        'title' => row['title'],
        'body' => row['body'],
        'created_at' => row['created_at']
      }
    end
    memos.sort_by { |memo| memo['created_at'] }
  end

  def find_memo
    load_memos.find { |memo| memo['id'] == params['id'] }
  end

  def create_memo
    prepared_name = 'create_memo'
    values = values_for_create_or_update
    @conn.prepare(prepared_name, 'insert into memos (id, title, body) values ($1, $2, $3)')
    @conn.exec_prepared(prepared_name, [values['id'], values['title'], values['body']])
  end

  def values_for_create_or_update
    {
      'id' => params['id'] || SecureRandom.uuid,
      'title' => (title = h(params['title']).strip).empty? ? '無題' : title,
      'body' => h(params['body'])
    }
  end

  def update_memo
    prepared_name = 'update_memo'
    values = values_for_create_or_update
    @conn.prepare(prepared_name, 'update memos set title = $1, body = $2 where id = $3')
    @conn.exec_prepared(prepared_name, [values['title'], values['body'], values['id']])
  end

  def delete_memo
    prepared_name = 'delete_memo'
    @conn.prepare(prepared_name, 'delete from memos where id = $1')
    @conn.exec_prepared(prepared_name, [params['id']])
  end
end

helpers do
  include MemoUtils
  include ERB::Util

  def build_page_title(page_title)
    [page_title, APP_NAME].compact.join(' | ')
  end
end

get '/' do
  redirect to('/memos')
end

get '/memos/?' do
  @memos = load_memos
  @page_title = build_page_title(nil)
  erb :index
end

post '/memos' do
  create_memo
  redirect to('/memos')
end

get '/memos/new/?' do
  @page_title = build_page_title('メモの作成')
  erb :new
end

get '/memos/:id/?' do
  if (@memo = find_memo)
    @page_title = build_page_title('メモの詳細')
    erb :show
  else
    status 404
  end
end

get '/memos/:id/edit/?' do
  if (@memo = find_memo)
    @page_title = build_page_title('メモの変更')
    erb :edit
  else
    status 404
  end
end

patch '/memos/:id/?' do
  if find_memo
    update_memo
    redirect to("/memos/#{params['id']}")
  else
    status 404
  end
end

delete '/memos/:id/?' do
  if find_memo
    delete_memo
    redirect to('/memos')
  else
    status 404
  end
end

not_found do
  @page_title = build_page_title('ページが見つかりませんでした')
  erb :error
end
