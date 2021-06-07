# frozen_string_literal: true

require 'sinatra'
require 'json'
require 'erb'
require 'time'
require 'securerandom'
require 'sinatra/reloader'
require 'pg'

APP_NAME = 'メモアプリ'
STORAGE_PATH = 'memo_files'

module MemoUtils
  def load_memos
    memos = []
    conn = PG.connect(dbname: 'sinatra_memo')
    conn.exec("select * from memos") do |result|
      result.each do |row|
        memos << {
          'id' => row['id'],
          'title' => row['title'],
          'body' => row['body'],
          'created_at' => row['created_at']
        }
      end
    end
    memos.sort_by { |memo| memo['created_at'] }
  end

  def find_memo
    file_path = memo_id_to_file_path(params['id'])
    JSON.parse(File.read(file_path)) if FileTest.exist?(file_path)
  end

  def memo_id_to_file_path(memo_id)
    "#{STORAGE_PATH}/#{memo_id}.json"
  end

  def create_memo
    create_or_update_memo
  end

  def create_or_update_memo
    memo_id = params['id'] || SecureRandom.uuid
    file_path = memo_id_to_file_path(memo_id)
    File.open(file_path, 'w') do |file|
      memo = {
        'id' => memo_id,
        'title' => (title = h(params['title']).strip).empty? ? '無題' : title,
        'body' => h(params['body']),
        'created_at' => params['created_at'] || Time.now.iso8601
      }
      JSON.dump(memo, file)
    end
  end

  def update_memo
    create_or_update_memo
  end

  def delete_memo
    file_path = memo_id_to_file_path(params['id'])
    FileTest.exist?(file_path) && File.delete(file_path)
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
