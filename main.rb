# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'
require 'erb'
require 'time'
require 'securerandom'

APP_NAME = 'メモアプリ'

module MemoUtils
  def load_memo_files
    memos = []
    Dir.glob('memo_files/*') do |file|
      memos << JSON.parse(File.read(file))
    end
    memos.sort_by { |memo| memo['created_at'] }
  end

  def find_memo(params)
    memos = load_memo_files
    memos.find { |memo| memo['id'].to_s == params['id'] }
  end

  def create_memo(params)
    memo_id = SecureRandom.uuid
    File.open("memo_files/#{memo_id}.json", 'w') do |file|
      memo = {
        'id' => id,
        'title' => (title = h(params['title']).strip).empty? ? '無題' : title,
        'body' => h(params['body']),
        'created_at' => Time.now.iso8601,
        'updated_at' => Time.now.iso8601
      }
      JSON.dump(memo, file)
    end
  end

  def update_memo(params)
    File.open("memo_files/#{params['id']}.json", 'w') do |file|
      memo = {
        'id' => params['id'],
        'title' => (title = h(params['title']).strip).empty? ? '無題' : title,
        'body' => h(params['body']),
        'created_at' => params['created_at'],
        'updated_at' => Time.now.iso8601
      }
      JSON.dump(memo, file)
    end
  end

  def delete_memo(params)
    file_path = "memo_files/#{params['id']}.json"
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
  @memos = load_memo_files
  @page_title = build_page_title(nil)
  erb :index
end

post '/memos' do
  create_memo(params)
  redirect to('/memos')
end

get '/memos/new/?' do
  @page_title = build_page_title('メモの作成')
  erb :new
end

get '/memos/:id/?' do
  if (@memo = find_memo(params))
    @page_title = build_page_title('メモの詳細')
    erb :show
  else
    status 404
  end
end

patch '/memos/:id/?' do
  update_memo(params)
  redirect to('/memos')
end

get '/memos/:id/edit/?' do
  if (@memo = find_memo(params))
    @page_title = build_page_title('メモの変更')
    erb :edit
  else
    status 404
  end
end

delete '/memos/:id/?' do
  delete_memo(params)
  redirect to('/memos')
end

not_found do
  @page_title = build_page_title('ページが見つかりませんでした')
  erb :error
end
