# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'
require 'erb'
require 'time'

APP_NAME = 'メモアプリ'

helpers do
  def load_memo_files
    memos = []
    Dir.glob('memo_files/*') do |file|
      memos << JSON.parse(File.read(file))
    end
    memos.sort_by { |memo| memo['created_at'] }
  end

  def fetch_latest_next_id
    memos = load_memo_files
    memos.max_by { |memo| memo['id'] }['id'].next
  end

  def find_memo
    memos = load_memo_files
    memos.find { |memo| memo['id'].to_s == params['id'] }
  end

  def delete_memo(params)
    file_path = "memo_files/#{params['id']}.json"
    FileTest.exist?(file_path) && File.delete(file_path)
  end

  def build_page_title(page_title)
    [page_title, APP_NAME].compact.join(' | ')
  end

  def h(text)
    ERB::Util.h(text)
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

get '/memos/new/?' do
  @page_title = build_page_title('メモの作成')
  erb :new
end

post '/memos' do
  id = fetch_latest_next_id
  File.open("memo_files/#{id}.json", 'w') do |file|
    memo = {
      'id' => id,
      'title' => h(params['title']),
      'body' => h(params['body']),
      'create_at' => Time.now.iso8601
    }
    JSON.dump(memo, file)
  end
  redirect to('/memos')
end

get '/memos/:id/?' do
  if (@memo = find_memo)
    @page_title = build_page_title('メモの詳細')
    erb :show
  else
    status 404
    erb :error
  end
end

get '/memos/:id/edit/?' do
  if (@memo = find_memo)
    @page_title = build_page_title('メモの変更')
    erb :edit
  else
    status 404
    erb :error
  end
end

delete '/memos/:id/?' do
  delete_memo(params)
  redirect to('/memos')
end

get '/*' do
  @page_title = build_page_title('ページが見つかりませんでした')
  status 404
  erb :error
end
